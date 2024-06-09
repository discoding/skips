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

class BoxPrint extends StatefulWidget {
  @override
  _BoxPrintState createState() => _BoxPrintState();
}

class _BoxPrintState extends State<BoxPrint> {
  bool _pdfPrinted = false;

  @override
  Widget build(BuildContext context) {
    final Stream<List<Box>> boxesStream = BoxService()
        .getBoxesStreamFromFirestore();

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
          List<Box> boxes = snapshot.data!;
          FilterProvider activeFilter = Provider.of<FilterProvider>(context);
          boxes = BoxService().filterBoxes(boxes, activeFilter);

          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text(activeFilter.FilterTekst),
              ),
              body: PdfPreview(
                onPrinted: (BuildContext context)  {
                  setState(() {
                    _pdfPrinted = true;
                  });
                },
                build: (format) {
                  if (_pdfPrinted) {
                    BoxService().archiveStatus();
                  }
                  return _generatePdf(format, boxes, activeFilter.FilterTekst);
                },
              ),
            ),
          );
        }
      },
    );
  }


  Future<Uint8List> _generatePdf(PdfPageFormat format, List<Box> boxes,
      String filter) async {
    // Load the font from assets
    final customFont = pw.Font.ttf(
        await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));

// Add the loaded font to the PDF document

    final pdf = pw.Document();

    int boxesPerColumn = 35; // Number of boxes per column
    int columnsPerPage = 5; // Number of columns per page

    int totalBoxes = boxes.length;
    int totalPages = (totalBoxes / (boxesPerColumn * columnsPerPage)).ceil();

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      pdf.addPage(
        pw.Page(
          pageFormat: format,
          build: (context) {
            List<pw.Widget> columns = [];
            for (int columnIndex = 0; columnIndex <
                columnsPerPage; columnIndex++) {
              int startingBoxIndex = pageIndex * columnsPerPage *
                  boxesPerColumn +
                  columnIndex * boxesPerColumn;
              List<pw.Widget> columnChildren = [];
              for (int boxIndex = startingBoxIndex; boxIndex <
                  startingBoxIndex + boxesPerColumn; boxIndex++) {
                if (boxIndex < totalBoxes) {
                  //      print('Box number: ${boxes[boxIndex].nummer}');
                  columnChildren.add(
                    pw.Container(

                      margin: pw.EdgeInsets.only(bottom: 5.0),
                      child: pw.Text(
                          style: pw.TextStyle(font: customFont, fontSize: 10),
                          boxes[boxIndex].nummer!),

                    ),
                  );
                } else {
                  break; // No more boxes to add
                }
              }
              columns.add(pw.Column(children: columnChildren));
            }

            return pw.Center(
              child: pw.Column(
                children: [

                  pw.Text('overzicht boxen  ' + DateFormat('dd-MM-yyyy')
                      .format(DateTime.now())
                      .toString(),
                    style: pw.TextStyle(font: customFont, fontSize: 20),),
                  pw.SizedBox(height: 20),
                  // Add some spacing
                  pw.Text('Filter: $filter',
                      style: pw.TextStyle(font: customFont, fontSize: 12)),
                  // Show the filter information
                  pw.SizedBox(height: 20),
                  // Add some spacing
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                    children: columns,
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    // Save the PDF after all pages have been added
    return pdf.save();
  }

}