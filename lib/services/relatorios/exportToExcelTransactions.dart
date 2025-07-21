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

  final headerStyle = workbook.styles!.add('headerStyle');
  headerStyle.backColor = '#4678c0';
  headerStyle.fontColor = '#FFFFFF';
  headerStyle.bold = true;
  headerStyle.hAlign = xlsio.HAlignType.center;
  headerStyle.vAlign = xlsio.VAlignType.center;

  final cellCenterStyle = workbook.styles!.add('cellCenterStyle');
  cellCenterStyle.hAlign = xlsio.HAlignType.center;
  cellCenterStyle.vAlign = xlsio.VAlignType.center;

  // Resumo
  sheet.getRangeByName('A1').setText('Tipo');
  sheet.getRangeByName('B1').setText('Valor');
  sheet.getRangeByName('A1').cellStyle = headerStyle;
  sheet.getRangeByName('B1').cellStyle = headerStyle;

  sheet.getRangeByName('A2').setText('Receita');
  sheet.getRangeByName('B2').setNumber(receita);
  sheet.getRangeByName('A2').cellStyle = cellCenterStyle;
  sheet.getRangeByName('B2').cellStyle = cellCenterStyle;

  sheet.getRangeByName('A3').setText('Despesa');
  sheet.getRangeByName('B3').setNumber(despesa);
  sheet.getRangeByName('A3').cellStyle = cellCenterStyle;
  sheet.getRangeByName('B3').cellStyle = cellCenterStyle;

  sheet.getRangeByName('A4').setText('Saldo');
  sheet.getRangeByName('B4').setNumber(receita - despesa);
  sheet.getRangeByName('A4').cellStyle = headerStyle;
  sheet.getRangeByName('B4').cellStyle = headerStyle;

  sheet.getRangeByName('A1:A4').columnWidth = 30;
  sheet.getRangeByName('B1:B4').columnWidth = 20;

  // Tabela transações - cabeçalho
  final startRow = 6;
  sheet.getRangeByName('A$startRow').setText('Descrição');
  sheet.getRangeByName('B$startRow').setText('Data');
  sheet.getRangeByName('C$startRow').setText('Tipo');
  sheet.getRangeByName('D$startRow').setText('Valor (R\$)');
  for (final col in ['A', 'B', 'C', 'D']) {
    sheet.getRangeByName('$col$startRow').cellStyle = headerStyle;
  }
  sheet.getRangeByName('A:D').columnWidth = 20;

  if (transactions.isEmpty) {
    sheet.getRangeByName('A${startRow + 1}').setText('Nenhuma transação encontrada');
  } else {
    for (int i = 0; i < transactions.length; i++) {
      final t = transactions[i];
      final row = startRow + 1 + i;

      sheet.getRangeByName('A$row').setText(t.title);
      sheet.getRangeByName('B$row').setText(
        '${t.date.day.toString().padLeft(2, '0')}/${t.date.month.toString().padLeft(2, '0')}/${t.date.year}',
      );
      sheet.getRangeByName('C$row').setText(t.type == 'r' ? 'Receita' : 'Despesa');
      sheet.getRangeByName('D$row').setNumber(t.value);

      for (final col in ['A', 'B', 'C', 'D']) {
        sheet.getRangeByName('$col$row').cellStyle = cellCenterStyle;
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
