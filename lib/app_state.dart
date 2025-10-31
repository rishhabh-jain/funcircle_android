import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _tutorial = prefs.getBool('ff_tutorial') ?? _tutorial;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<TicketsaddtocartStruct> _ticketsaddtocart = [];
  List<TicketsaddtocartStruct> get ticketsaddtocart => _ticketsaddtocart;
  set ticketsaddtocart(List<TicketsaddtocartStruct> value) {
    _ticketsaddtocart = value;
  }

  void addToTicketsaddtocart(TicketsaddtocartStruct value) {
    ticketsaddtocart.add(value);
  }

  void removeFromTicketsaddtocart(TicketsaddtocartStruct value) {
    ticketsaddtocart.remove(value);
  }

  void removeAtIndexFromTicketsaddtocart(int index) {
    ticketsaddtocart.removeAt(index);
  }

  void updateTicketsaddtocartAtIndex(
    int index,
    TicketsaddtocartStruct Function(TicketsaddtocartStruct) updateFn,
  ) {
    ticketsaddtocart[index] = updateFn(_ticketsaddtocart[index]);
  }

  void insertAtIndexInTicketsaddtocart(
      int index, TicketsaddtocartStruct value) {
    ticketsaddtocart.insert(index, value);
  }

  bool _tutorial = false;
  bool get tutorial => _tutorial;
  set tutorial(bool value) {
    _tutorial = value;
    prefs.setBool('ff_tutorial', value);
  }

  String _pageHeight = '5\'7';
  String get pageHeight => _pageHeight;
  set pageHeight(String value) {
    _pageHeight = value;
  }

  String _PhoneNumber = '';
  String get PhoneNumber => _PhoneNumber;
  set PhoneNumber(String value) {
    _PhoneNumber = value;
  }

  String _tempImagePath = '';
  String get tempImagePath => _tempImagePath;
  set tempImagePath(String value) {
    _tempImagePath = value;
  }

  String _webviewCommand = '\'\'';
  String get webviewCommand => _webviewCommand;
  set webviewCommand(String value) {
    _webviewCommand = value;
  }

  LatLng? _userLocation;
  LatLng? get userLocation => _userLocation;
  set userLocation(LatLng? value) {
    _userLocation = value;
  }

  double _userLatitude = 0.0;
  double get userLatitude => _userLatitude;
  set userLatitude(double value) {
    _userLatitude = value;
  }

  double _userLongitude = 0.0;
  double get userLongitude => _userLongitude;
  set userLongitude(double value) {
    _userLongitude = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
