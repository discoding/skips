import 'package:flutter/foundation.dart';
import 'package:skipsmaritiem/assets/constants.dart';

class FilterProvider extends ChangeNotifier {
  String? _selectedStatus = Constanten.status[0];
  String? _bezetDoor = Constanten.bezet[0];
  String? _verhuurd = Constanten.huurstatus[0];
  bool? _isFilterd;
  int? _selectedSteiger = 0; // New property


  // Additional boolean properties
  bool _bezetDoorBool = false;
  bool _statusBool = false;
  bool _verhuurdBool = false;

  String? _searchQuery = '';
  String? _filtertekst='';
  int? get selectedSteiger => _selectedSteiger;

  String? get selectedStatus => _selectedStatus;
  String? get bezetDoor => _bezetDoor;
  String? get verhuurd => _verhuurd;
  bool? get isFiltered =>
      (_selectedStatus != Constanten.status[0]) ||
      (_bezetDoor != Constanten.bezet[0]) ||
      (_verhuurd != Constanten.huurstatus[0]) ||
      _searchQuery!.isNotEmpty;

  // Additional boolean getters
  bool? get bezetDoorBool => _bezetDoorBool;
  bool? get statusBool => _statusBool;
  bool? get verhuurdBool => _verhuurdBool;
  String get FilterTekst {
    String _filtertekst = '';

    if (selectedStatus != Constanten.status[0]) {
      _filtertekst += 'Bezet of vrij : ' + selectedStatus! + '\n';
    }

    if (verhuurd != Constanten.huurstatus[0]) {
      _filtertekst += 'Verhuurd of vrij : ' + verhuurd! + '\n';
    }

    if (bezetDoor != Constanten.bezet[0]) {
      _filtertekst += 'Bezet door passant of vlh : ' + bezetDoor! + '\n';
    }

    if (searchQuery != '') {
      _filtertekst += 'Zoekopdracht : ' + searchQuery! + '\n';
    }

    // Add more filters here

    return _filtertekst;
  }
  String? get searchQuery => _searchQuery;

  set selectedSteiger(int? steiger) {
    _selectedSteiger = steiger;
    notifyListeners();
  }

  set searchQuery(String? query) {
    _searchQuery = query;
    notifyListeners(); // Notify listeners about the changes
  }

  set selectedStatus(String? status) {
    _selectedStatus = status;
    _statusBool = status == Constanten.status[1];
    _isFilterd = (_selectedStatus != Constanten.status[0]) ||
        (_bezetDoor != Constanten.bezet[0]) ||
        (_verhuurd != Constanten.huurstatus[0]) ||
        _searchQuery!.isNotEmpty;

    notifyListeners(); // Notify listeners about the changes
  }

  set isFiltered(bool? filter) {
    _isFilterd = filter;
    notifyListeners();
  }

  set bezetDoor(String? bezet) {
    _bezetDoor = bezet;
    // Update boolean properties based on the condition
    _bezetDoorBool = _bezetDoor == Constanten.bezet[1];

    isFiltered = (_selectedStatus != Constanten.status[0]) ||
        (_bezetDoor != Constanten.bezet[0]) ||
        (_verhuurd != Constanten.huurstatus[0]) ||
        _searchQuery!.isNotEmpty;

    notifyListeners(); // Notify listeners about the changes
  }

  set verhuurd(String? verhuur) {
    _verhuurd = verhuur;
    // Update boolean properties based on the condition
    _verhuurdBool = _verhuurd == Constanten.huurstatus[1];

    isFiltered = (_selectedStatus != Constanten.status[0]) ||
        (_bezetDoor != Constanten.bezet[0]) ||
        (_verhuurd != Constanten.huurstatus[0]) ||
        _searchQuery!.isNotEmpty;

    notifyListeners(); // Notify listeners about the changes
  }

  // Method to clear all filters
  void clearFilters() {
    _selectedStatus = Constanten.status[0];
    _bezetDoor = Constanten.bezet[0];
    _verhuurd = Constanten.huurstatus[0];
    _bezetDoorBool = false;
    _statusBool = false;
    _verhuurdBool = false;
    _searchQuery = '';
    notifyListeners(); // Notify listeners about the changes
  }
}
