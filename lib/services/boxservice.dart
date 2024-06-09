import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/fliterprovider.dart';
import '/models/boxmodel.dart';
import '/models/legeboxen.dart';

class BoxService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ... other methods ...
  Future<void> createBox(Box newBox) async {
    try {
      await _firestore.collection('boxes').add(newBox.toMap());
    } catch (e) {
      print('Error creating box: $e');
      throw e;
    }
  }

  Future<void> updateBox(Box box) async {
    try {
      await _firestore
          .collection('boxes')
          .doc(box.id)
          .update(box.toMap());
    } catch (e) {
      print('Error updating box in Firestore: $e');
    }
  }

  // Get a stream of boxes from Firestore
  Stream<List<Box>> getBoxesStreamFromFirestore() {
    return _firestore.collection('boxes')
        .snapshots()
        .map((snapshot) {
      List<Box> boxList = [];
      for (var document in snapshot.docs) {
        Box box = Box.fromSnapshot(document);
        if (box.nummer.toString().length == 1) {
          box.nummer = '00' + box.nummer.toString();
        } else if (box.nummer.toString().length == 2) {
          box.nummer = '0' + box.nummer.toString();
        }
        boxList.add(box);
      }
      boxList.sort((a, b) => a.nummer.toString().compareTo(b.nummer.toString()));
      return boxList;
    });
  }
  Future<void> archiveStatus() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    QuerySnapshot snapshot = await _firestore.collection('boxes').get();
    DateTime now = DateTime.now();
    DateTime dateOnly = DateTime(now.year, now.month, now.day);

    for (var document in snapshot.docs) {
      Box box = Box.fromSnapshot(document);
      bool entryExistsForToday=false;
      // Initialize archief if it doesn't exist
      List<History> updatedArchief = box.archief ?? [];

      // Check if an entry for the current date already exists
      entryExistsForToday = box.archief?.any((history) =>
      history.date?.year == dateOnly.year &&
          history.date?.month == dateOnly.month &&
          history.date?.day == dateOnly.day) ??
          false;

      // If an entry doesn't exist for today, add it
      if (!entryExistsForToday) {
        // Add the new history entry
        List<History> updatedArchief = box.archief ?? [];
        updatedArchief.add(History(date: dateOnly, status: box.status));

        // Convert the updated archive to a list of maps
        List<Map<String, dynamic>> archiefMaps = updatedArchief.map((history) => history.toMap()).toList();

        // Update the Firestore document
        await _firestore.collection('boxes').doc(box.id).update({
          'archief': archiefMaps,
        });
      }
    }
  }
  Future<void> showCreateBoxForm(BuildContext context) async {
    Box newBox = Box.placeholder();
    bool isConfirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Box'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Box Number'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newBox.nummer = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Lengte'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newBox.lengte = double.tryParse(value) ?? 0;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Breedte'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  newBox.breedte = double.tryParse(value) ?? 0;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Opmerkingen'),
                onChanged: (value) {
                  newBox.opmerkingen = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Boot Naam'),
                onChanged: (value) {
                  newBox.bootnaam = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Boot Naam VLH'),
                onChanged: (value) {
                  newBox.bootnaamvlh = value;
                },
              ),
              // Add more fields as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );

    if (isConfirmed) {
      await createBox(newBox);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Box created successfully'),
     ));
    }
  }

   Future<List<List<dynamic>>> readCSV() async {
    String csvData = await rootBundle.loadString('assets/your_csv_file.csv');
    List<List<dynamic>> rows = CsvToListConverter().convert(csvData);
    return rows;
  }

  Future<void> uploadBoxesToFirebase(List<Box> boxes) async {

    for (Box box in boxes) {
      await _firestore.collection('boxes').add(box.toMap());
    }
  }
  Future<void> DownloadBoxes() async {
    LegeBoxen bu = LegeBoxen.placeholder();
    bu.date = DateTime.now();
    bu.legeboxen=[];

    await _firestore.collection('boxes').get().
    then((QuerySnapshot snapshot) {

      for (var doc in snapshot.docs) {
        Box box=Box.fromSnapshot(doc);
        box.datum=DateTime.now();
        _firestore.collection('archive').add(box.toMap() );}


      }


    );
  }
  //
  //  }
 // }

  void importBoxesToFirebase() async {
    List<List<dynamic>> csvRows = await readCSV();
    List<Box> boxes = [];

    for (List<dynamic> row in csvRows) {
      boxes.add(Box(
        steiger: row[0],
        typeBox: row[1],
        nummer: row[2],
        lengte: row[3],
        breedte: row[4],
        bootnaamvlh: row[5],


      ));
    }

    await uploadBoxesToFirebase(boxes);
  }
  List<Box> filterBoxes(List<Box> boxes, FilterProvider filterOptions) {
    return boxes.where((box) {
      bool passFilter = true;

      // Apply status filter
      if (filterOptions.selectedStatus != 'alle boxen') {
        passFilter = passFilter && (box.status == filterOptions.statusBool);
      }

      // Apply 'bezetDoor' filter
      if (filterOptions.bezetDoor != 'alle boxen') {
        passFilter = passFilter && (box.bezetdoor == filterOptions.bezetDoorBool);
      }

      // Apply 'verhuurd' filter
      if (filterOptions.verhuurd != 'alle boxen') {
        passFilter = passFilter && (box.verhuurd == filterOptions.verhuurdBool);
      }
      if (filterOptions.selectedSteiger != 0) {
        passFilter = passFilter && (box.steigerIndex == filterOptions.selectedSteiger);
      }

      if (filterOptions.searchQuery!.isNotEmpty) {
        String lowercaseQuery = filterOptions.searchQuery!.toLowerCase();
        passFilter = passFilter &&
            (box.bootnaam?.toLowerCase().contains(lowercaseQuery) == true ||
                box.bootnaamvlh?.toLowerCase().contains(lowercaseQuery) == true);
      }

      return passFilter;
    }).toList();
  }
}
