import 'dart:io';
import 'package:image/image.dart' as Img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class EndDatePicker with ChangeNotifier {
  final _now = DateTime.now();
  DateTime _endPicked;

  get endPicked => _endPicked;
  set endPicked(DateTime picked) {
    _endPicked = picked;
    notifyListeners();
  }

  get minDate => _now.add(const Duration(hours: 1));
  get maxDate => _now.add(const Duration(days: 365));

  get formatedPicked {
    final dtString = _endPicked.toString();
    final date = dtString.substring(0, 10).split("-");
    final yy = date[0];
    final mm = date[1];
    final dd = date[2];

    final time = dtString.substring(11, 16);

    return dd + "/" + mm + "/" + yy + " at " + time;
  }

  get dateISO => _endPicked != null ? _endPicked.toIso8601String() : null;
}

class MinPerBidPicker with ChangeNotifier {
  final List<int> _choices = [1, 5, 10, 20, 50, 100, 300, 500, 1000];
  int _minPerBid = 1;

  get choices => _choices;

  get minPerBid => _minPerBid;
  set minPerBid(int newMin) {
    _minPerBid = newMin;
    notifyListeners();
  }
}

class SetImageProvider with ChangeNotifier {
  PickedFile _image;
  File _croppedFile;
  Img.Image _resizedImage;
  String _final64;

  get imagePath => _image.path;
  get isResized => _resizedImage == null ? false : true;

  get image => _image;
  set image(PickedFile image) {
    _image = image;
    notifyListeners();
  }

  get croppedFile => _croppedFile;
  set croppedFile(File cropped) {
    _croppedFile = cropped;
    notifyListeners();
  }

  get resizedImage => _resizedImage;
  set resizedImage(Img.Image resizedImg) {
    _resizedImage = resizedImg;
    notifyListeners();
  }

  get final64 => _final64;
  set final64(String base64) {
    _final64 = base64;
    notifyListeners();
  }
}
