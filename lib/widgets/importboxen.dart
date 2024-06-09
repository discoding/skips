import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:skipsmaritiem/services/boxservice.dart';
import '../models/boxmodel.dart'; // Import your Box model


class ImportBoxen {
  Future<void> importCSV() async {
    try {
      if (kIsWeb) {
        final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

        if (result != null) {
          final List<int> fileBytes = result.files.single.bytes!;
          final input = utf8.decode(fileBytes);
          final fields = const CsvToListConverter(fieldDelimiter: ';', shouldParseNumbers: false).convert(input);
         // final fields = const CsvToListConverter(eol: "\r\n").convert(input);
         //       print(fields);
          for (final row in fields) {
              String nummer = row[2].toString();

              // Format nummer field to have at least 3 characters
              if (nummer.length == 1) {
                nummer = '00' + nummer;
              } else if (nummer.length == 2) {
                nummer = '0' + nummer;
              }
              nummer = row[0].toString() + ' '+ nummer;

              final Box box = Box(
              status: row[5].toString() =='',
              steiger: row[0].toString(),
              typeBox: row[1].toString(), // Assuming 'Type box' is in the second column
              nummer:  nummer,
              lengte: double.parse(row[3].toString().replaceAll(',', '.')),
              breedte: double.parse(row[4].toString().replaceAll(',', '.')),
              bootnaamvlh: row[5].toString(),
            );

            BoxService().createBox(box);

          }
        }
      }
      else {

        final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);

      if (result != null) {
        final File file = File(result.files.single.path!);
        final input = file.openRead();
        final fields = await input.transform(utf8.decoder).transform(CsvToListConverter(eol: "\r\n")).toList();

        for (final row in fields) {
          String nummer = row[2].toString();

          // Format nummer field to have at least 3 characters
          if (nummer.length == 1) {
            nummer = '00' + nummer;
          } else if (nummer.length == 2) {
            nummer = '0' + nummer;
          }
          nummer = nummer + ' ' + row[2].toString();

          final Box box = Box(
            steiger: row[0].toString(),
            typeBox: row[1].toString(), // Assuming 'Type box' is in the second column
            nummer:  nummer,
            lengte: double.parse(row[3].toString().replaceAll(',', '.')),
            breedte: double.parse(row[4].toString().replaceAll(',', '.')),
            bootnaamvlh: row[5].toString(),
          );

          BoxService().createBox(box);
        }
      }
    } }
    catch (e) {
      print('Error importing CSV: $e');
    }
  }

}
