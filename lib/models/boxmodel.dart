import 'package:cloud_firestore/cloud_firestore.dart';

import '../assets/constants.dart';
class History {
  DateTime? date;
  bool? status;

  History({this.date, this.status});

  // Convert a History object to a Map
  Map<String, dynamic> toMap() {
    return {
      'date': date?.toIso8601String(),
      'status': status,
    };
  }

  // Create a History object from a Map
  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      date: DateTime.parse(map['date']),
      status: map['status'],
    );
  }
}

class Box {
  String? id;
  String? nummer;
  String? typeBox; // Added field
  bool? status;
  double? lengte;
  double? breedte;
  String? opmerkingen;
  DateTime? datum;
  String? bootnaam;
  String? bootnaamvlh;
  bool? passant;
  String? steiger;
  List<History>? archief;

  // Computed property: true if bootnaamvlh is not empty, false otherwise
  bool get verhuurd => bootnaamvlh?.isNotEmpty ?? false;

  // Computed property: true if bootnaam is not empty, false otherwise
  bool get bezetdoor => bootnaam?.isNotEmpty ?? false;
  int? get steigerIndex {
    if (steiger != null) {
      int index = Constanten.steigers.indexOf(steiger!);
      if (index >= 0) {
        return index;
      }
    }
    return null;
  }

  Box({
    this.id,
    this.nummer,
    this.typeBox,
    this.status,
    this.lengte,
    this.breedte,
    this.opmerkingen,
    this.datum,
    this.bootnaam,
    this.bootnaamvlh,
    this.passant,
    this.steiger,
    this.archief,
  });

  // Default constructor for a placeholder box
  Box.placeholder()
      : id = '',
        nummer = '0',
        typeBox = '', // Added field
        status = true,
        lengte = 11,
        breedte = 3.8,
        opmerkingen = '',
        datum = DateTime.now(),
        bootnaam = '',
        bootnaamvlh = '',
        passant = false,
        steiger = '',
        archief = [];

  // Convert the 'Box' object to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'nummer': nummer,
      'typeBox': typeBox, // Added field
      'status': status,
      'lengte': lengte,
      'breedte': breedte,
      'opmerkingen': opmerkingen,
      'datum': Timestamp.now(),
      'bootnaam': bootnaam,
      'bootnaamvlh': bootnaamvlh,
      'passant': passant,
      'steiger': steiger,
    };
  }

  // Create a 'Box' object from Firestore document snapshot
  factory Box.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>;
    return Box(
      id: snapshot.id,
      nummer: data['nummer'],
      typeBox: data['typeBox'], // Added field
      status: data['status'] ,
      lengte: (data['lengte'] as num).toDouble(), // Convert to double
      breedte: (data['breedte'] as num).toDouble(), // Convert to double
      opmerkingen: data['opmerkingen'],
      datum: (data['datum'] as Timestamp).toDate(),
      bootnaam: data['bootnaam'],
      bootnaamvlh: data['bootnaamvlh'],
      passant: data['passant'],
      steiger: data['steiger'],
      archief:  (data['archief'] as List<dynamic>?)
            ?.map((item) => History.fromMap(item as Map<String, dynamic>))
            .toList()

    );
  }
}
