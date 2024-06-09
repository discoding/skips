import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/boxmodel.dart';
import '../providers/fliterprovider.dart';
import '../services/boxservice.dart';
import 'boxbezetting.dart';

class opmerkingenPrint extends StatelessWidget {
  final Stream<List<Box>> boxesStream = BoxService().getBoxesStreamFromFirestore();

  Future<Uint8List> _generatePdf(PdfPageFormat format, List<Box> filteredBoxes, String filter) async {
    final customFont = pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (pw.Context context) {
          return filteredBoxes.map((box) {
            return pw.Container(
              margin: pw.EdgeInsets.only(bottom: 10.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Box number: ${box.nummer}', style: pw.TextStyle(font: customFont, fontSize: 10)),
               //  pw.Text('Date: ${DateFormat('dd-MM-yyyy').format(DateTime.now())}', style: pw.TextStyle(font: customFont, fontSize: 10)),
                  pw.Text('Remarks: ${box.opmerkingen ?? "No remarks"}', style: pw.TextStyle(font: customFont, fontSize: 10)),
                ],
              ),
            );
          }).toList();
        },
        header: (pw.Context context) {
          return pw.Text(
            'overzicht opmerkingen ' + DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
            style: pw.TextStyle(font: customFont, fontSize: 20),
          );
        },
        footer: (pw.Context context) {
          return pw.Text(
            'Filter: $filter',
            style: pw.TextStyle(font: customFont, fontSize: 12),
          );
        },
      ),
    );

    return pdf.save();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Box>>(
      stream: boxesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error reading: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No boxes found.');
        } else {
          List<Box> allBoxes = snapshot.data!;

          // Filter the boxes with non-empty opmerkingen
          List<Box> filteredBoxes = allBoxes.where((box) => (box.opmerkingen ?? '').isNotEmpty).toList();

          // Return MaterialApp and PdfPreview with filteredBoxes
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text('opmerkingen'),
              ),
              body: PdfPreview(
                build: (format) => _generatePdf(format, filteredBoxes, ' Opmerkingen'), // Pass the filtered boxes
              ),
            ),
          );
        }
      },
    );
  }
}
