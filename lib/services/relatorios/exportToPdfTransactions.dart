import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'package:spendo/models/transaction_model.dart';

Future<void> exportToPdfTransactions({
  required double receita,
  required double despesa,
  required List<TransactionModel> transactions,
  required String nomeArquivo,
}) async {
  final pdf = pw.Document();

  // Carrega a logo
  final Uint8List logoBytes =
      (await rootBundle.load('assets/images/IconSpendoCurvo.png'))
          .buffer
          .asUint8List();
  final logoImage = pw.MemoryImage(logoBytes);

  final saldo = receita - despesa;
  final maxValor = [receita, despesa].reduce((a, b) => a > b ? a : b);

  pdf.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(24),
      pageFormat: PdfPageFormat.a4,
      footer: (context) => pw.Text(
        'Página ${context.pageNumber} de ${context.pagesCount}',
        style: pw.TextStyle(fontSize: 10, color: PdfColors.grey),
        textAlign: pw.TextAlign.center,
      ),
      build: (context) => [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            pw.Row(
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

            // Título
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromInt(0xFF4678C0),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Text(
                'Relatório Receita vs Despesa',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Gerado em: ${DateTime.now().toLocal()}',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
            pw.SizedBox(height: 20),

            // Tabela resumo
            pw.Table.fromTextArray(
              headers: ['Tipo', 'Valor (R\$)'],
              data: [
                ['Receita', receita.toStringAsFixed(2)],
                ['Despesa', despesa.toStringAsFixed(2)],
                ['Saldo', saldo.toStringAsFixed(2)],
              ],
              headerDecoration:
                  pw.BoxDecoration(color: PdfColor.fromInt(0xFF4678C0)),
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              cellStyle: const pw.TextStyle(fontSize: 12),
              cellAlignment: pw.Alignment.center,
              headerHeight: 25,
              cellHeight: 30,
              border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
              rowDecoration: pw.BoxDecoration(color: PdfColors.grey200),
              oddRowDecoration: pw.BoxDecoration(color: PdfColors.grey100),
              columnWidths: {
                0: const pw.FixedColumnWidth(150),
                1: const pw.FixedColumnWidth(100),
              },
            ),
            pw.SizedBox(height: 30),

            // Título da tabela detalhada
            pw.Text(
              'Detalhes das Transações:',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
          ],
        ),

        // Tabela detalhada das transações (fora do Column para quebrar corretamente)
        pw.Table.fromTextArray(
          headers: ['Descrição', 'Data', 'Tipo', 'Valor (R\$)'],
          data: transactions.map((t) => [
            t.title,
            '${t.date.day.toString().padLeft(2, '0')}/${t.date.month.toString().padLeft(2, '0')}/${t.date.year}',
            t.type == 'r' ? 'Receita' : 'Despesa',
            t.value.toStringAsFixed(2),
          ]).toList(),
          headerDecoration:
              pw.BoxDecoration(color: PdfColor.fromInt(0xFF4678C0)),
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
          cellStyle: const pw.TextStyle(fontSize: 10),
          cellAlignment: pw.Alignment.centerLeft,
          headerHeight: 25,
          cellHeight: 20,
          border: pw.TableBorder.all(width: 0.3, color: PdfColors.grey),
          rowDecoration: pw.BoxDecoration(color: PdfColors.grey200),
          oddRowDecoration: pw.BoxDecoration(color: PdfColors.grey100),
          columnWidths: {
            0: const pw.FlexColumnWidth(3),
            1: const pw.FlexColumnWidth(2),
            2: const pw.FlexColumnWidth(2),
            3: const pw.FlexColumnWidth(2),
          },
        ),

        pw.SizedBox(height: 30),

        // Gráfico
        pw.Text(
          'Gráfico de Barras Comparativo:',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey200,
            border: pw.Border.all(color: PdfColors.grey600),
            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          ),
          height: 200,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _buildBar('Receita', receita, maxValor, PdfColors.green),
              _buildBar('Despesa', despesa, maxValor, PdfColors.red),
            ],
          ),
        ),
        pw.SizedBox(height: 30),
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

  if (dir == null) throw Exception('Erro ao obter diretório.');

  final path = '${dir.path}/$nomeArquivo.pdf';
  final file = File(path);
  await file.writeAsBytes(bytes, flush: true);

  print('✅ PDF Receita vs Despesa salvo em: $path');

  await Share.shareXFiles(
    [XFile(path)],
    text: 'Relatório Receita vs Despesa',
    subject: 'Aqui está seu relatório em PDF',
  );
  
}

pw.Widget _buildBar(String label, double valor, double max, PdfColor color) {
  final barHeight = max == 0 ? 0 : (valor / max) * 130;
  return pw.Column(
    mainAxisAlignment: pw.MainAxisAlignment.end,
    children: [
      pw.Text(
        valor.toStringAsFixed(2),
        style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 4),
      pw.Container(
        width: 28,
        height: barHeight.toDouble(),
        color: color,
      ),
      pw.SizedBox(height: 5),
      pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
    ],
  );
}
