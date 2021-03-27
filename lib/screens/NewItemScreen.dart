import 'dart:convert';
import 'dart:io';

import 'package:biddee_flutter/providers/SetImageProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class NewItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SetImageProvider(),
      child: Scaffold(
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
      ),
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

class ImageSelector extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var setImageProvider = Provider.of<SetImageProvider>(context);

    Future _pickImage() async {
      // request permissions
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;

      if (permissionStatus.isGranted) {
        // get image
        setImageProvider.image =
            await _picker.getImage(source: ImageSource.gallery);
        if (setImageProvider.image != null) {
          final imageBytes =
              File(setImageProvider.image.path).readAsBytesSync();
          setImageProvider.image64 = base64Encode(imageBytes);
        }
      } else {
        // request permissions again
        print("permission is not granted: request again");
        await Permission.photos.request();
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          setImageProvider.isPicked
              ? Image.file(
                  File(setImageProvider.imagePath),
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
            onPressed: () {
              _pickImage();
            },
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
