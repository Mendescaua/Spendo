import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

Future<void> exportToPdfCategories({
  required Map<String, double> categoriaGastos,
  required double total,
  required String nomeArquivo,
}) async {
  final pdf = pw.Document();

  // Carregar logo do app (PNG)
  final Uint8List logoBytes =
      (await rootBundle.load('assets/images/IconSpendoCurvo.png'))
          .buffer
          .asUint8List();
  final logoImage = pw.MemoryImage(logoBytes);

  final headers = ['Categoria', 'Valor (R\$)', 'Porcentagem'];
  final data = categoriaGastos.entries.map((e) {
    final porcentagem = (e.value / total * 100).toStringAsFixed(1) + '%';
    return [e.key, e.value.toStringAsFixed(2), porcentagem];
  }).toList();

  data.add(['Total', total.toStringAsFixed(2), '100%']);

  final headerStyle = pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.white,
  );

  final maxValue = categoriaGastos.values.isEmpty
      ? 0
      : categoriaGastos.values.reduce((a, b) => a > b ? a : b);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      footer: (context) => pw.Text(
        'Página ${context.pageNumber} de ${context.pagesCount}',
        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
        textAlign: pw.TextAlign.center,
      ),
      build: (context) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Cabeçalho: logo esquerda + texto "Spendo" ao lado
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Image(logoImage, width: 40, height: 40),
                pw.SizedBox(width: 8),
                pw.Text(
                  'Spendo',
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Título com fundo azul e cantos arredondados
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFF4678C0),
                borderRadius:
                    const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Text(
                'Relatório de Gastos',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFFFFFFFF),
                ),
              ),
            ),
            pw.SizedBox(height: 8),

            // Data/hora geração
            pw.Text(
              'Gerado em: ${DateTime.now().toLocal()}',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
            pw.SizedBox(height: 20),

            // Tabela com linhas alternadas
            pw.Table.fromTextArray(
              headers: headers,
              data: data,
              headerDecoration:
                  pw.BoxDecoration(color: PdfColor.fromInt(0xFF4678C0)),
              headerHeight: 25,
              cellAlignment: pw.Alignment.center,
              cellHeight: 30,
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              headerStyle: headerStyle,
              cellStyle: const pw.TextStyle(fontSize: 12),
              rowDecoration: pw.BoxDecoration(color: PdfColors.grey200),
              oddRowDecoration: pw.BoxDecoration(color: PdfColors.grey100),
              columnWidths: {
                0: const pw.FixedColumnWidth(150),
                1: const pw.FixedColumnWidth(80),
                2: const pw.FixedColumnWidth(80),
              },
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
              },
            ),
            pw.SizedBox(height: 30),
          ],
        ),

        // Gráficos divididos em múltiplos cards
        ..._buildBarChartCards(categoriaGastos, maxValue.toDouble()),
      ],
    ),
  );

  final bytes = await pdf.save();

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

  if (dir == null) {
    throw Exception(
        'Não foi possível obter o diretório para salvar o arquivo.');
  }

  final path = '${dir.path}/$nomeArquivo.pdf';
  final file = File(path);

  await file.writeAsBytes(bytes, flush: true);

  print('✅ Arquivo PDF salvo em: $path');

  await Share.shareXFiles(
    [XFile(path)],
    text: 'Relatório de Gastos',
    subject: 'Aqui está seu relatório de gastos em PDF',
  );
}

List<pw.Widget> _buildBarChartCards(Map<String, double> data, double maxValue) {
  const int categoriasPorCard = 8;
  // Ordenar por valor decrescente
  final entries = data.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final List<pw.Widget> cards = [];

  for (int i = 0; i < entries.length; i += categoriasPorCard) {
    final bloco = entries.skip(i).take(categoriasPorCard).toList();

    cards.addAll([
      pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey200,
          border: pw.Border.all(color: PdfColors.grey600, width: 1),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        ),
        height: 200,
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          children: bloco.map((e) {
            final barHeight = maxValue == 0 ? 0 : (e.value / maxValue) * 130;
            return pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 2),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    e.value.toStringAsFixed(2),
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Container(
                    width: 16,
                    height: barHeight.toDouble(),
                    color: PdfColor.fromInt(0xFF4678C0),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Container(
                    width: 60,
                    child: pw.Text(
                      e.key,
                      style: const pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.center,
                      maxLines: 3,
                      overflow: pw.TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      pw.SizedBox(height: 16),
    ]);
  }

  return cards;
}

