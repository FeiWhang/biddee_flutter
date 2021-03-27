import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SetImageProvider with ChangeNotifier {
  PickedFile _image;
  String _image64;

  get imagePath => _image.path;
  get isPicked => _image == null ? false : true;

  get image => _image;
  set image(PickedFile image) {
    _image = image;
    notifyListeners();
  }

  get image64 => _image64;
  set image64(String base64) {
    _image64 = base64;
    notifyListeners();
  }
}
