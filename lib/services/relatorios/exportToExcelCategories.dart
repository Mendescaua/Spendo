import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:share_plus/share_plus.dart';


Future<void> exportToExcelCategories({
  required Map<String, double> categoriaGastos,
  required double total,
  required String nomeArquivo,
}) async {
  final workbook = xlsio.Workbook();
  final sheet = workbook.worksheets[0];
  sheet.name = 'Relatório de Gastos';

  // Estilo do cabeçalho: fundo roxo, texto branco, negrito, alinhado centro
  final headerStyle = workbook.styles!.add('headerStyle');
  headerStyle.backColor = '#4678c0';
  headerStyle.fontColor = '#FFFFFF';
  headerStyle.bold = true;
  headerStyle.hAlign = xlsio.HAlignType.center;
  headerStyle.vAlign = xlsio.VAlignType.center;

  // Estilo para células de dados: texto alinhado ao centro
  final cellCenterStyle = workbook.styles!.add('cellCenterStyle');
  cellCenterStyle.hAlign = xlsio.HAlignType.center;
  cellCenterStyle.vAlign = xlsio.VAlignType.center;

  // Cabeçalhos
  sheet.getRangeByName('A1').setText('Categoria');
  sheet.getRangeByName('A1').cellStyle = headerStyle;

  sheet.getRangeByName('B1').setText('Valor');
  sheet.getRangeByName('B1').cellStyle = headerStyle;

  sheet.getRangeByName('C1').setText('Porcentagem');
  sheet.getRangeByName('C1').cellStyle = headerStyle;

  // Conteúdo
  int row = 2;
  categoriaGastos.forEach((categoria, valor) {
    final porcentagem = (valor / total * 100).toStringAsFixed(1);

    sheet.getRangeByName('A$row').setText(categoria);
    sheet.getRangeByName('A$row').cellStyle = cellCenterStyle;

    sheet.getRangeByName('B$row').setNumber(valor);
    sheet.getRangeByName('B$row').cellStyle = cellCenterStyle;

    sheet.getRangeByName('C$row').setText('$porcentagem%');
    sheet.getRangeByName('C$row').cellStyle = cellCenterStyle;

    row++;
  });

  // Linha total com estilo de cabeçalho
  sheet.getRangeByName('A$row').setText('Total');
  sheet.getRangeByName('A$row').cellStyle = headerStyle;

  sheet.getRangeByName('B$row').setNumber(total);
  sheet.getRangeByName('B$row').cellStyle = headerStyle;

  sheet.getRangeByName('C$row').setText('100%');
  sheet.getRangeByName('C$row').cellStyle = headerStyle;

  // Ajustar largura das colunas
  sheet.getRangeByName('A1:A$row').columnWidth = 30;
  sheet.getRangeByName('B1:B$row').columnWidth = 20;
  sheet.getRangeByName('C1:C$row').columnWidth = 20;

  final bytes = workbook.saveAsStream();
  workbook.dispose();

  // Permissões no Android
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

  // Definir diretório para salvar o arquivo
  Directory? dir;
  if (Platform.isAndroid) {
    dir = Directory('/storage/emulated/0/Download');
    if (!await dir.exists()) {
      dir = await getExternalStorageDirectory(); // fallback
    }
  } else if (Platform.isIOS) {
    dir = await getApplicationDocumentsDirectory();
  }

  if (dir == null) {
    throw Exception('Não foi possível obter o diretório para salvar o arquivo.');
  }

  final path = '${dir.path}/$nomeArquivo.xlsx';
  final file = File(path);

  await file.writeAsBytes(bytes, flush: true);

  print('✅ Arquivo Excel salvo em: $path');

  // Compartilhar arquivo
  await Share.shareXFiles(
    [XFile(path)],
    text: 'Relatório de Gastos',
    subject: 'Aqui está seu relatório de gastos em Excel',
  );
}
