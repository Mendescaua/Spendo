import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/models/transaction_model.dart';
import 'package:spendo/controllers/transaction_controller.dart';

enum ChatStep {
  waitingForType,
  waitingForTitle,
  waitingForValue,
  waitingForCategory,
  done,
}

class ChatState {
  final List<Map<String, dynamic>> messages;
  final ChatStep step;
  final String? type; // 'd' ou 'r'
  final String? title;
  final double? value;
  final String? category;

  ChatState({
    required this.messages,
    required this.step,
    this.type,
    this.title,
    this.value,
    this.category,
  });

  ChatState copyWith({
    List<Map<String, dynamic>>? messages,
    ChatStep? step,
    String? type,
    String? title,
    double? value,
    String? category,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      step: step ?? this.step,
      type: type ?? this.type,
      title: title ?? this.title,
      value: value ?? this.value,
      category: category ?? this.category,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  final Ref ref;

  ChatController(this.ref)
      : super(
          ChatState(
            messages: [
              {
                'text': '👋 Olá! Como posso te ajudar?',
                'isUser': false,
                'options': ['Nova Despesa', 'Nova Receita'],
              }
            ],
            step: ChatStep.waitingForType,
          ),
        );

  void sendMessage(String text) {
    final transactionController =
        ref.read(transactionControllerProvider.notifier);
    final msg = text.trim();

    // 🔴 Comando para cancelar e reiniciar tudo
    if (msg.toLowerCase() == 'cancelar') {
      state = ChatState(
        messages: [
          {
            'text': '🚫 Transação cancelada. Como posso te ajudar?',
            'isUser': false,
            'options': ['Nova Despesa', 'Nova Receita'],
          }
        ],
        step: ChatStep.waitingForType,
      );
      return;
    }

    _addUserMessage(msg);

    switch (state.step) {
      case ChatStep.waitingForType:
        if (msg.toLowerCase().contains('despesa')) {
          state = state.copyWith(step: ChatStep.waitingForTitle, type: 'd');
          _botSay('Ok, vamos registrar uma despesa. Qual o título?');
        } else if (msg.toLowerCase().contains('receita')) {
          state = state.copyWith(step: ChatStep.waitingForTitle, type: 'r');
          _botSay('Ok, vamos registrar uma receita. Qual o título?');
        } else {
          _botSay(
              'Por favor, digite "Nova Despesa" ou "Nova Receita" para começarmos.');
        }
        break;

      case ChatStep.waitingForTitle:
        if (msg.isEmpty) {
          _botSay('Título não pode ser vazio. Por favor, informe o título.');
          break;
        }
        state = state.copyWith(step: ChatStep.waitingForValue, title: msg);
        _botSay('Agora informe o valor da ${_getLabel(state.type!)}.');
        break;

      case ChatStep.waitingForValue:
        final value = double.tryParse(msg.replaceAll(',', '.'));
        if (value == null) {
          _botSay(
              'Valor inválido. Tente informar o valor numérico, por exemplo: 100 ou 55.50');
          break;
        }
        state = state.copyWith(step: ChatStep.waitingForCategory, value: value);
        final categories =
            transactionController.categories.map((c) => c.name).toList();
        _botSay('Escolha a categoria:', options: categories);
        break;

      case ChatStep.waitingForCategory:
        final categories =
            transactionController.categories.map((c) => c.name).toList();

        if (msg.isEmpty) {
          _botSay('Por favor, escolha uma categoria.');
          break;
        }
        if (!categories.contains(msg)) {
          _botSay('Categoria inválida. Por favor, escolha uma das opções:',
              options: categories);
          break;
        }

        state = state.copyWith(step: ChatStep.done, category: msg);
        _finalizeTransaction(transactionController);
        break;

      case ChatStep.done:
        _botSay(
            'Se quiser registrar outra transação, digite "Nova Despesa" ou "Nova Receita".');

        // Reseta o estado
        state = ChatState(
          messages: [
            {
              'text': '👋 Olá! Como posso te ajudar?',
              'isUser': false,
              'options': ['Nova Despesa', 'Nova Receita'],
            }
          ],
          step: ChatStep.waitingForType,
        );
        break;
    }
  }

  void selectOption(String option) {
    sendMessage(option);
  }

  void pickImage(File imageFile, String fileName) {
    final userMsg = {
      'text': fileName,
      'isUser': true,
      'image': imageFile,
    };

    final botMsg = {
      'text': 'Imagem recebida! O que deseja fazer com ela?',
      'isUser': false,
    };

    state = state.copyWith(messages: [...state.messages, userMsg, botMsg]);
  }

  void _finalizeTransaction(TransactionController controller) async {
    final t = TransactionModel(
      type: state.type!,
      title: state.title!,
      value: state.value!,
      category: state.category!,
      description: '',
      date: DateTime.now(),
      repeat: 1,
      bank: 'Carteira Digital',
    );

    final result = await controller.addTransaction(transaction: t);

    if (result == null) {
      _botSay('✅ ${_getLabel(state.type!)} salva com sucesso!');
    } else {
      _botSay('❌ Erro ao salvar: $result');
    }
  }

  void _botSay(String text, {List<String>? options}) {
    final botMsg = {'text': text, 'isUser': false};
    if (options != null) botMsg['options'] = options;
    state = state.copyWith(messages: [...state.messages, botMsg]);
  }

  void _addUserMessage(String text) {
    final userMsg = {'text': text, 'isUser': true};
    state = state.copyWith(messages: [...state.messages, userMsg]);
  }

  String _getLabel(String type) => type == 'r' ? 'receita' : 'despesa';
}

final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>(
  (ref) => ChatController(ref),
);
