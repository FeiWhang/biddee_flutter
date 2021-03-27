import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';

class NewItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Create new item",
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        brightness: Brightness.dark,
      ),
      body: NewItemBody(),
    );
  }
}

class NewItemBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ImageSelector(),
      ],
    );
  }
}

class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final ImagePicker _picker = ImagePicker();

  PickedFile _imageFile;

  Future _pickImage() async {
    final pickedImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _imageFile != null
              ? Image.file(
                  File(_imageFile.path),
                  width: 300,
                  height: 300,
                )
              : Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFe1e1e1),
                        blurRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    'assets/icons/image.png',
                    scale: 1.2,
                  ),
                ),
          ElevatedButton(
            child: Text(
              "Set Image".toUpperCase(),
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => _pickImage(),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xFFf3f3f3)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
