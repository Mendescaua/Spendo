import 'dart:io';
import 'package:diacritic/diacritic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/transaction_model.dart';

class ChatState {
  final List<Map<String, dynamic>> messages;
  final Map<String, dynamic>? pendingTransaction;

  ChatState({required this.messages, this.pendingTransaction});

  ChatState copyWith({
    List<Map<String, dynamic>>? messages,
    Map<String, dynamic>? pendingTransaction,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      pendingTransaction: pendingTransaction,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  final Ref ref;

  ChatController(this.ref) : super(ChatState(messages: []));

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Adiciona mensagem do usuário
    state = state.copyWith(
      messages: [
        ...state.messages,
        {'text': text, 'isUser': true}
      ],
    );

    // Interpreta e responde
    final response = await _interpretMessage(text.trim());

    // Adiciona respostas do bot na UI, com indicador de digitação
    if (response is List<String>) {
      for (var msg in response) {
        state = state.copyWith(
          messages: [
            ...state.messages,
            {'isTyping': true, 'isUser': false}
          ],
        );

        await Future.delayed(const Duration(milliseconds: 1000));

        final msgsWithoutTyping =
            List<Map<String, dynamic>>.from(state.messages)
              ..removeWhere((m) => m['isTyping'] == true);

        state = state.copyWith(
          messages: [
            ...msgsWithoutTyping,
            {'text': msg, 'isUser': false}
          ],
        );
      }
    } else {
      state = state.copyWith(
        messages: [
          ...state.messages,
          {'text': response.toString(), 'isUser': false}
        ],
      );
    }
  }

  Future<dynamic> _interpretMessage(String input) async {
    final lowerInput = input.toLowerCase().trim();

    // 1. Pendência de transação
    if (state.pendingTransaction != null) {
      if (lowerInput == 'cancelar') {
        state = state.copyWith(pendingTransaction: null);
        return ['❌ Transação cancelada.'];
      }

      if (state.pendingTransaction!['waitingCategory'] == true) {
        final categorias = ref
            .read(transactionControllerProvider.notifier)
            .categories
            .where((cat) => cat.isArchived != true)
            .map((e) => e.name.toLowerCase())
            .toList();

        if (!categorias.contains(lowerInput)) {
          return [
            '⚠️ Categoria inválida. Por favor, escolha uma categoria da lista ou digite "cancelar".'
          ];
        }

        final pending = state.pendingTransaction!;
        final transactionController =
            ref.read(transactionControllerProvider.notifier);

        final transaction = TransactionModel(
          type: pending['type'],
          value: pending['value'],
          title: pending['title'],
          description: pending['description'],
          category: lowerInput,
          date: DateTime.now(),
          repeat: 1,
          bank: 'Carteira Digital',
        );

        final response = await transactionController.addTransaction(
            transaction: transaction);

        state = state.copyWith(pendingTransaction: null);

        if (response != null) {
          return ['❌ Erro ao salvar: $response'];
        } else {
          return ['✅ Transação salva na categoria "$lowerInput".'];
        }
      }

      return [
        '⚠️ Você tem uma transação pendente. Por favor, conclua selecionando uma categoria válida ou digite "cancelar" para abortar.'
      ];
    }

    // 2. Usa apenas respostas locais
    final fallbackReply = _getFallbackReply(lowerInput);
    if (fallbackReply != null) return [fallbackReply];

    // 3. Caso nenhuma resposta seja encontrada
    return ['🤖 Ainda estou aprendendo! Pode tentar reformular sua mensagem.'];
  }

  String? _getFallbackReply(String input) {
    final defaultReply = getStandardReply(input);
    if (defaultReply != null) return defaultReply;

    if ([
      'estou ótimo! e com você?',
      'estou otimo! e com voce?',
      'estou ótimo e com você?',
      'estou otimo e com voce?'
    ].contains(input)) {
      return '😊 Que bom! Estou aqui para ajudar no que precisar.';
    }

    if (input == 'spendo') {
      return 'Zen do Spendo — import spendo\nGastar é inevitável, controlar é essencial.\nCada centavo conta; registre com precisão.\nSimplifique as entradas; evite o excesso.\nCategorias claras criam visão limpa.\nO futuro financeiro nasce do presente equilibrado.\nSaldo transparente gera confiança.\nRevisar é hábito, não obrigação.\nDados organizados guiam decisões sábias.\nSpendo é parceiro, não complicador.';
    }

    if (input.startsWith('+') || input.startsWith('-')) {
      try {
        if (state.pendingTransaction != null) {
          return '⚠️ Você já tem uma transação pendente. Por favor, conclua ou cancele antes de iniciar outra.';
        }

        final isIncome = input.startsWith('+');
        final parts = input.substring(1).trim().split(' ');

        if (parts.length < 2) {
          return '❌ Por favor, informe o valor e o título da transação. Exemplo: +100 mercado';
        }

        final value = double.parse(parts[0]);
        final description = parts.sublist(1).join(' ');

        if (description.isEmpty) {
          return '❌ O título da transação não pode ficar vazio.';
        }

        state = state.copyWith(
          pendingTransaction: {
            'type': isIncome ? 'r' : 'd',
            'value': value,
            'title': description,
            'description': "",
            'waitingCategory': true,
          },
        );

        final categories = ref
            .read(transactionControllerProvider.notifier)
            .categories
            .where((cat) => cat.isArchived != true)
            .toList();

        final categoriasStr = categories.isNotEmpty
            ? categories.map((e) => '- ${e.name}').join('\n')
            : 'Nenhuma categoria disponível.';

        return 'Valor: R\$${value.toStringAsFixed(2)}\nTítulo: "$description"\n📌 Informe a categoria:\n$categoriasStr\n\nOu digite "cancelar" para descartar.';
      } catch (e) {
        return '❌ Erro. Use: +100 mercado ou -80 gasolina';
      }
    }

    return null;
  }

  Future<void> pickImage(File imageFile, String imageName) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    final extractedText = recognizedText.text;

    state = state.copyWith(
      messages: [
        ...state.messages,
        {
          'isUser': true,
          'image': imageFile,
          'text': 'Nota fiscal enviada: $imageName',
        }
      ],
      pendingTransaction: {
        'type': 'd',
        'value': 0.0,
        'title': 'Nota fiscal',
        'description': extractedText,
        'waitingCategory': true,
      },
    );

    final reply = [
      '🧾 Texto reconhecido:\n"$extractedText"',
      '📌 Qual a categoria para essa nota?\n\nOu digite "cancelar" para descartar.'
    ];

    for (var msg in reply) {
      await Future.delayed(const Duration(milliseconds: 600));
      state = state.copyWith(
        messages: [
          ...state.messages,
          {'text': msg, 'isUser': false}
        ],
      );
    }
  }

  void clearMessages() {
    state = ChatState(messages: []);
  }
}

String? getStandardReply(String input) {
  input = removeDiacritics(input.toLowerCase().trim());

  final patternMap = <Pattern, String>{
    RegExp(r'\b(oi|ola|olá|opa|eae|fala|bom dia|boa tarde|boa noite)\b'):
        '👋 Olá! Como posso te ajudar?',
    RegExp(r'\b(tudo bem|tudo bom|como vai|suave|de boa|dboa|beleza|blz|tudo certo)\b'):
        '🤖 Estou ótimo! E com você?',
    RegExp(r'\b(estou triste|tô mal|to mal|bad|depressivo|cansado|sem vontade)\b'):
        '😟 Poxa... se precisar desabafar, estou por aqui!',
    RegExp(r'\b(estou feliz|tô bem|to bem|animado|contente|alegre)\b'):
        '😄 Que ótimo! Me conta mais!',
    RegExp(r'\b(obrigado|obrigada|valeu|agradecido|grato)\b'):
        '😊 De nada! Sempre por aqui.',
    RegExp(r'\b(quem é você|quem é vc|o que você faz|o que vc faz)\b'):
        '🤖 Sou o SpenAi, seu assistente no controle financeiro!',
    RegExp(r'\b(qual seu nome|como se chama|como te chamo|seu nome)\b'):
        '📛 Pode me chamar de SpenAi!',
    RegExp(r'\b(você é real|você é humano|vc é gente)\b'):
        '🧠 Sou virtual, mas sempre pronto para te ajudar com suas transações!',
    RegExp(r'\b(adeus|tchau|flw|falou|até mais|fui)\b'):
        '👋 Até mais! Se cuida.',
    RegExp(r'\b(que dia é hoje|qual a data de hoje|data de hoje|hoje é que dia)\b'):
        '📅 Hoje é ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}.',
    RegExp(r'\b(gastei demais|controle de gastos|organizar dinheiro|me ajuda com dinheiro|sem grana)\b'):
        '💰 Posso te ajudar com seu controle financeiro. Quer registrar uma despesa?',
    RegExp(r'\b(economia|guardar dinheiro|dicas financeiras|como poupar)\b'):
        '💡 Uma boa dica é definir metas mensais e acompanhar seus gastos por categoria!',
    RegExp(r'\b(o que é o spendo|pra que serve o spendo|o que faz o app|como usar o app)\b'):
        '📲 O Spendo é um app para te ajudar a controlar suas finanças pessoais de forma simples e prática.',
    RegExp(r'\b(tem versão pro|versão premium|pagar pelo app)\b'):
        '💎 Em breve teremos novidades com recursos avançados!',
    RegExp(r'\b(aniversário|meus parabéns|feliz aniversário)\b'):
        '🎉 Parabéns! Que seu dia seja incrível!',
    RegExp(r'\b(você aprende|você entende|vc é inteligente|inteligente você)\b'):
        '🤖 Tento melhorar a cada dia para te ajudar melhor!',
    RegExp(r'\b(cadastrar gasto|nova despesa|registrar compra|anotar gasto|adicionar despesa|despesa)\b'):
        '🛒 Vamos cadastrar uma nova despesa? Me diga o valor e o titulo\nEx:(-100 Mercado)',
    RegExp(r'\b(cadastrar receita|nova receita|registrar receita|anotar receita|adicionar receita|receita)\b'):
        '🛒 Vamos cadastrar uma nova despesa? Me diga o valor e o titulo\nEx:(+1600 Salário)',
    RegExp(r'\b(como faço transação|como faço transações|transacao)\b'):
        '🧾 Vamos cadastrar uma nova transação? Me diga o valor e o titulo.\nEx:(+100 Mercado)',
  };

  // Quebra o input em palavras
  final inputWords = input.split(RegExp(r'\s+'));

  for (final entry in patternMap.entries) {
    final reg = entry.key as RegExp;
    final patternStr = reg.pattern;
    final regexInner = RegExp(r'\((.*?)\)');
    final match = regexInner.firstMatch(patternStr);
    if (match == null) continue;
    final keywords = match.group(1)!.split('|').map((k) => removeDiacritics(k.toLowerCase())).toList();

    // Match por palavra exata (exato na lista de palavras do input)
    if (keywords.any((keyword) => inputWords.contains(keyword))) {
      return entry.value;
    }
  }

  return null;
}



final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>(
  (ref) => ChatController(ref),
);
