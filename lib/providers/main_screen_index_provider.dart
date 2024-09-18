import 'package:flutter/cupertino.dart';

class MainScreenIndexProvider extends ChangeNotifier {
  int index = 0;

  void changeIndex({required int newIndex}) {
    index = newIndex;
    notifyListeners();
  }
}
