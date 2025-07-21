import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:share_plus/share_plus.dart';

import 'package:spendo/models/transaction_model.dart';

Future<void> exportToExcelTransactions({
  required double receita,
  required double despesa,
  required List<TransactionModel> transactions,
  required String nomeArquivo,
}) async {
  final workbook = xlsio.Workbook();
  final sheet = workbook.worksheets[0];
  sheet.name = 'Receita vs Despesa';

  // Estilos principais
  final headerStyle = workbook.styles!.add('headerStyle');
  headerStyle.backColor = '#4678c0';
  headerStyle.fontColor = '#FFFFFF';
  headerStyle.bold = true;
  headerStyle.hAlign = xlsio.HAlignType.center;
  headerStyle.vAlign = xlsio.VAlignType.center;

  final cellCenterStyle = workbook.styles!.add('cellCenterStyle');
  cellCenterStyle.hAlign = xlsio.HAlignType.center;
  cellCenterStyle.vAlign = xlsio.VAlignType.center;

  // Estilos por tipo
  final receitaStyle = workbook.styles!.add('receitaStyle');
  receitaStyle.backColor = '#d4edda'; // verde claro
  receitaStyle.hAlign = xlsio.HAlignType.center;
  receitaStyle.vAlign = xlsio.VAlignType.center;

  final despesaStyle = workbook.styles!.add('despesaStyle');
  despesaStyle.backColor = '#f8d7da'; // vermelho claro
  despesaStyle.hAlign = xlsio.HAlignType.center;
  despesaStyle.vAlign = xlsio.VAlignType.center;

  // Resumo
  sheet.getRangeByIndex(1, 1).setText('Tipo');
  sheet.getRangeByIndex(1, 2).setText('Valor');
  sheet.getRangeByIndex(1, 1).cellStyle = headerStyle;
  sheet.getRangeByIndex(1, 2).cellStyle = headerStyle;

  sheet.getRangeByIndex(2, 1).setText('Receita');
  sheet.getRangeByIndex(2, 2).setNumber(receita);
  sheet.getRangeByIndex(2, 1).cellStyle = cellCenterStyle;
  sheet.getRangeByIndex(2, 2).cellStyle = cellCenterStyle;

  sheet.getRangeByIndex(3, 1).setText('Despesa');
  sheet.getRangeByIndex(3, 2).setNumber(despesa);
  sheet.getRangeByIndex(3, 1).cellStyle = cellCenterStyle;
  sheet.getRangeByIndex(3, 2).cellStyle = cellCenterStyle;

  sheet.getRangeByIndex(4, 1).setText('Saldo');
  sheet.getRangeByIndex(4, 2).setNumber(receita - despesa);
  sheet.getRangeByIndex(4, 1).cellStyle = headerStyle;
  sheet.getRangeByIndex(4, 2).cellStyle = headerStyle;

  // Largura das colunas do resumo
  sheet.getRangeByIndex(1, 1).columnWidth = 30;
  sheet.getRangeByIndex(1, 2).columnWidth = 20;

  // Cabeçalho das transações
  final startRow = 6;
  sheet.getRangeByIndex(startRow, 1).setText('Descrição');
  sheet.getRangeByIndex(startRow, 2).setText('Data');
  sheet.getRangeByIndex(startRow, 3).setText('Tipo');
  sheet.getRangeByIndex(startRow, 4).setText('Valor (R\$)');

  for (int col = 1; col <= 4; col++) {
    sheet.getRangeByIndex(startRow, col).cellStyle = headerStyle;
    sheet.getRangeByIndex(startRow, col).columnWidth = 20;
  }

  // Conteúdo das transações
  if (transactions.isEmpty) {
    sheet.getRangeByIndex(startRow + 1, 1).setText('Nenhuma transação encontrada');
  } else {
    for (int i = 0; i < transactions.length; i++) {
      final t = transactions[i];
      final row = startRow + 1 + i;

      final title = (t.title ?? '').trim();
      final date = t.date;
      final type = (t.type ?? '').trim();
      final value = t.value;
      final isReceita = type == 'r';

      final bgStyle = isReceita ? receitaStyle : despesaStyle;

      sheet.getRangeByIndex(row, 1).setText(title.isNotEmpty ? title : '');
      sheet.getRangeByIndex(row, 2).setText(date != null
          ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
          : '');
      sheet.getRangeByIndex(row, 3).setText(isReceita ? 'Receita' : 'Despesa');
      sheet.getRangeByIndex(row, 4).setNumber(value ?? 0.0);

      for (int col = 1; col <= 4; col++) {
        sheet.getRangeByIndex(row, col).cellStyle = bgStyle;
      }
    }
  }

  final bytes = workbook.saveAsStream();
  workbook.dispose();

  // Permissões Android
  if (Platform.isAndroid) {
    final status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      final result = await Permission.manageExternalStorage.request();
      if (!result.isGranted) {
        await openAppSettings();
        throw Exception('Permissão de armazenamento negada.');
      }
    }
  }

  Directory? dir;
  if (Platform.isAndroid) {
    dir = Directory('/storage/emulated/0/Download');
    if (!await dir.exists()) {
      dir = await getExternalStorageDirectory();
    }
  } else if (Platform.isIOS) {
    dir = await getApplicationDocumentsDirectory();
  }

  if (dir == null) throw Exception('Diretório não encontrado.');

  final path = '${dir.path}/$nomeArquivo.xlsx';
  final file = File(path);
  await file.writeAsBytes(bytes, flush: true);
  print('✅ Excel salvo em: $path');

  await Share.shareXFiles(
    [XFile(path)],
    text: 'Relatório Receita vs Despesa',
    subject: 'Relatório financeiro mensal',
  );
}
