import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? position;

  void changePosition({required Position newPosition}) {
    position = newPosition;
    notifyListeners();
  }
}
