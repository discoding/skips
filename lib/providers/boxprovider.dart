import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/boxmodel.dart'; // Import your Box model

class BoxProvider extends ChangeNotifier {
  Box _box = Box.placeholder(); // Initialize with a placeholder box

  // Getters for individual box fields
  String get nummer => _box.nummer ?? '0';
  bool get status => _box.status ?? true;
  bool get passant => _box.passant ?? false;
  double get lengte => _box.lengte ?? 0;
  double get breedte => _box.breedte ?? 0;
  String get opmerkingen => _box.opmerkingen ?? '';
  DateTime get datum => _box.datum ?? DateTime.now();
  String get bootnaam => _box.bootnaam ?? '';
  String get bootnaamvlh => _box.bootnaamvlh ?? '';
  String get steiger => _box.steiger ?? '';

  // Setters for individual box fields
  set nummer(String value) {
    _box.nummer = value;
    notifyListeners();
  }

  set status(bool value) {
    _box.status = value;
    notifyListeners();
  }

  set passant(bool value) {
    _box.passant = value;
    notifyListeners();
  }

  set lengte(double value) {
    _box.lengte = value;
    notifyListeners();
  }

  set breedte(double value) {
    _box.breedte = value;
    notifyListeners();
  }

  set opmerkingen(String value) {
    _box.opmerkingen = value;
    notifyListeners();
  }

  set datum(DateTime value) {
    _box.datum = value;
    notifyListeners();
  }

  set bootnaam(String value) {
    _box.bootnaam = value;
    notifyListeners();
  }

  set bootnaamvlh(String value) {
    _box.bootnaamvlh = value;
    notifyListeners();
  }

  set steiger(String value) {
    _box.steiger = value;
    notifyListeners();
  }

  // Getter for the complete box instance
  Box get box => _box;

  // Setter for the complete box instance
  set box(Box value) {

    _box = value;
    notifyListeners();
  }
  Future<void> updateFirestoreStatus(Box box, bool newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('boxes').doc(box.id).update({
        'status': newStatus,
      });
    } catch (e) {
      print('Error updating occupied status: $e');
    }

}
}

