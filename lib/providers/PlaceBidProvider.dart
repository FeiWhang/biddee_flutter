import 'package:flutter/material.dart';

class PlaceBidIDProvider extends ChangeNotifier {
  String _itemID;

  get itemID => _itemID;
  set itemID(String newID) {
    _itemID = newID;
    notifyListeners();
  }
}
