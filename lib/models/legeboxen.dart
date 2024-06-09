import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart';
import 'package:skipsmaritiem/models/boxmodel.dart';

import '../assets/constants.dart';

class LegeBoxen {
  DateTime? date;
  List<Box>? legeboxen;

  LegeBoxen({
    this.date,
    this.legeboxen
    });

  // Default constructor for a placeholder box
  LegeBoxen.placeholder()
      : date =  DateTime.now(),
        legeboxen = [];

  // Convert the 'Box' object to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'legeboxen': legeboxen // Added field
    };
  }

  // Create a 'Box' object from Firestore document snapshot
  factory LegeBoxen.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
    return LegeBoxen(
      date: data['date'],
      legeboxen: data['legeboxen'],
    );
  }
}
