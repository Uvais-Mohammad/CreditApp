import 'dart:convert' show utf8;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PDFHelper {
  static Future<File> generateTable(
      {required List<String> headers,
      required List<List> data,
      required List<int> party,
      required double drTotal,
      required double crTotal,
      required double mainTotal}) async {
    var _dt = DateTime.now();
    var _formatter = DateFormat('dd-MM-yyyy');
    final pdf = pw.Document();

    final font = await rootBundle.load("assets/fonts/open-sans.ttf");
    final ttf = pw.Font.ttf(font);
    var decoded = utf8.decode(party, allowMalformed: true);
    print(decoded);
    pdf.addPage(
      pw.MultiPage(
        build: (context) => <pw.Widget>[
          pw.Header(
              text: "Ledger Report of $decoded on ${_formatter.format(_dt)}",
              textStyle: pw.TextStyle(font: ttf)),
          pw.Table.fromTextArray(
            headers: headers,
            data: data,
            cellAlignments: {
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight
            },
            columnWidths: {
              0: pw.FlexColumnWidth(1.5),
              1: pw.FlexColumnWidth(1.5),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(2),
              4: pw.FlexColumnWidth(2),
              5: pw.FlexColumnWidth(2),
              6: pw.FlexColumnWidth(2),
            },
          ),
          pw.Table.fromTextArray(
            columnWidths: {
              0: pw.FlexColumnWidth(1.5),
              1: pw.FlexColumnWidth(1.5),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(2),
              4: pw.FlexColumnWidth(2),
              5: pw.FlexColumnWidth(2),
              6: pw.FlexColumnWidth(2),
            },
            cellAlignments: {
              4: pw.Alignment.centerRight,
              5: pw.Alignment.centerRight,
              6: pw.Alignment.centerRight
            },
            // headers: headers,
            data: [
              ['', '', '', 'Total', '$drTotal', '$crTotal', '$mainTotal']
            ],
          ),
        ],
        // footer: (context) => pw.Footer(
        //   title: pw.Text("Total"),
        // ),
      ),
    );
    return saveDocument(name: 'date_wise_report.pdf', pdf: pdf);
  }

  static Future<File> saveDocument(
      {required String name, required pw.Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

// Page(
// margin: EdgeInsets.all(10),
// pageFormat: PdfPageFormat.a4,
// build: (context) => Table.fromTextArray(
// headers: headers,
// data: data,
// ))
