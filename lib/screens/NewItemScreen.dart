import 'dart:convert';
import 'dart:io';

import 'package:biddee_flutter/Firebase.dart';
import 'package:biddee_flutter/providers/NewItemProvider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image/image.dart' as Img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class NewItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SetImageProvider>(
          create: (BuildContext context) => SetImageProvider(),
        ),
        ChangeNotifierProvider<MinPerBidPicker>(
          create: (BuildContext context) => MinPerBidPicker(),
        ),
        ChangeNotifierProvider<EndDatePicker>(
          create: (BuildContext context) => EndDatePicker(),
        ),
      ],
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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController startingPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    createNewItem() {
      final String title = titleController.text.trim();
      final String description = descriptionController.text.trim();
      final String startingPrice = startingPriceController.text.trim();
      final String minPerBid =
          Provider.of<MinPerBidPicker>(context, listen: false)
              .minPerBid
              .toString();
      final String imgDataUrl =
          Provider.of<SetImageProvider>(context, listen: false).final64;
      final String endAt =
          Provider.of<EndDatePicker>(context, listen: false).dateISO;

      if (title != null &&
          description != null &&
          startingPrice != null &&
          imgDataUrl != null &&
          endAt != null &&
          title != "" &&
          description != "" &&
          startingPrice != "") {
        showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text(
              "Comfirmation",
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("I have reviewed that the information is correct"),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("Cancel",
                    style: TextStyle(color: Theme.of(context).errorColor)),
                onPressed: () => Get.back(),
              ),
              CupertinoDialogAction(
                child: Text("Confirm"),
                onPressed: () {
                  // do firebase process
                  DatabaseService().addMyItem(
                      title: title,
                      description: description,
                      startingPrice: startingPrice,
                      minPerBid: minPerBid,
                      imgDataUrl: imgDataUrl,
                      endAt: endAt);
                  // close dialog
                  Get.back();
                },
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
            title: Text(
              "Cannot create item",
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text("No field can be left blank"),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("OK"),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        );
      }
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageSelector(),
            NewItemForm(
              titleController: titleController,
              startingPriceController: startingPriceController,
              descriptionController: descriptionController,
            ),
            ElevatedButton(
              onPressed: () => createNewItem(),
              child: Text("CREATE ITEM"),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColorDark),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ImageSelector extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  final double imageSize = 275.0;

  @override
  Widget build(BuildContext context) {
    var setImageProvider = Provider.of<SetImageProvider>(context);

    Future _cropImage() async {
      File _croppedFile = await ImageCropper.cropImage(
          sourcePath: setImageProvider.imagePath,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
      if (_croppedFile != null) {
        setImageProvider.croppedFile = _croppedFile;
      }
    }

    Future _pickImage() async {
      // request permissions
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;

      if (permissionStatus.isGranted) {
        // get image
        final _justPicked = await _picker.getImage(source: ImageSource.gallery);
        // to make existing image the same if no new just picked
        if (_justPicked != null) {
          setImageProvider.image = _justPicked;

          // crop image
          await _cropImage();

          if (setImageProvider.croppedFile != null) {
            // resize image
            Img.Image img =
                Img.decodeImage(setImageProvider.croppedFile.readAsBytesSync());
            Img.Image resizedImg = Img.copyResize(img, width: 300, height: 300);
            setImageProvider.resizedImage = resizedImg;
          }

          // convert resized to base64
          if (setImageProvider.isResized) {
            final imgPNG = Img.encodePng(setImageProvider.resizedImage);
            setImageProvider.final64 =
                'data:image/png;base64,${base64Encode(imgPNG)}';
          }
        }
      } else {
        print("permission is not granted: request again");
        await Permission.photos.status;
      }
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          setImageProvider.isResized
              ? Container(
                  margin: const EdgeInsets.only(bottom: 8, top: 16),
                  child: Image.memory(
                    Img.encodePng(setImageProvider.resizedImage),
                    width: imageSize,
                    height: imageSize,
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(bottom: 8, top: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).shadowColor,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFe1e1e1),
                        blurRadius: 2,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: imageSize,
                  height: imageSize,
                  child: Image.asset(
                    'assets/icons/image.png',
                    scale: 1.5,
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

class NewItemForm extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController startingPriceController;
  final TextEditingController descriptionController;

  NewItemForm(
      {this.titleController,
      this.startingPriceController,
      this.descriptionController});

  @override
  _NewItemFormState createState() => _NewItemFormState();
}

class _NewItemFormState extends State<NewItemForm> {
  GlobalKey<FormState> _titleKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _startingPriceKey = new GlobalKey<FormState>();
  GlobalKey<FormState> _descriptionKey = new GlobalKey<FormState>();
  FocusNode focusTitle = FocusNode();
  FocusNode focusStartingPrice = FocusNode();
  FocusNode focusDescription = FocusNode();

  @override
  void initState() {
    super.initState();
    focusTitle.addListener(() => setState(() {}));
    focusStartingPrice.addListener(() => setState(() {}));
    focusDescription.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final minPerBidProvider = Provider.of<MinPerBidPicker>(context);
    final endDateProvider = Provider.of<EndDatePicker>(context);

    _showMinPerBidPicker() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 305,
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: CupertinoPicker(
                      onSelectedItemChanged: (index) {
                        minPerBidProvider.minPerBid =
                            minPerBidProvider.choices[index];
                      },
                      itemExtent: 40.0,
                      children: [
                        Center(
                            child:
                                Text(minPerBidProvider.choices[0].toString())),
                        Center(
                            child:
                                Text(minPerBidProvider.choices[1].toString())),
                        Center(
                            child:
                                Text(minPerBidProvider.choices[2].toString())),
                        Center(
                            child:
                                Text(minPerBidProvider.choices[3].toString())),
                        Center(
                            child:
                                Text(minPerBidProvider.choices[4].toString())),
                        Center(
                            child:
                                Text(minPerBidProvider.choices[5].toString())),
                        Center(
                            child:
                                Text(minPerBidProvider.choices[6].toString())),
                        Center(
                            child:
                                Text(minPerBidProvider.choices[7].toString())),
                        Center(
                            child:
                                Text(minPerBidProvider.choices[8].toString())),
                      ],
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text('OK'),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
            );
          });
    }

    _showEndPicker() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 305,
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: CupertinoDatePicker(
                      initialDateTime: endDateProvider.minDate,
                      minimumDate: endDateProvider.minDate,
                      maximumDate: endDateProvider.maxDate,
                      onDateTimeChanged: (dt) {
                        endDateProvider.endPicked = dt;
                      },
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text('OK'),
                    onPressed: () => Get.back(),
                  )
                ],
              ),
            );
          });
    }

    return Container(
      margin: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "Title",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 8,
                ),
                width: 333,
                decoration: focusTitle.hasFocus
                    ? BoxDecoration(
                        boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                color: Theme.of(context).primaryColor)
                          ],
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(18.0)))
                    : null,
                child: Form(
                  key: _titleKey,
                  child: TextFormField(
                    controller: widget.titleController,
                    focusNode: focusTitle,
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(18.0),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      hintStyle: new TextStyle(color: Colors.grey[500]),
                      hintText: "max 50 characters",
                      fillColor: Color(0xFFf3f3f3),
                      enabledBorder: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(18.0),
                          ),
                          borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Starting price
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 24),
                child: Text(
                  "Starting price",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700]),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 8,
                ),
                width: 333,
                decoration: focusStartingPrice.hasFocus
                    ? BoxDecoration(
                        boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                color: Theme.of(context).primaryColor)
                          ],
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(18.0)))
                    : null,
                child: Form(
                  key: _startingPriceKey,
                  child: TextFormField(
                    controller: widget.startingPriceController,
                    focusNode: focusStartingPrice,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(18.0),
                          ),
                          borderSide: BorderSide.none),
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      hintStyle: new TextStyle(color: Colors.grey[500]),
                      hintText: "at least 0",
                      fillColor: Color(0xFFf3f3f3),
                      enabledBorder: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(18.0),
                          ),
                          borderSide: BorderSide.none),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'THB',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Min per Bid
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "Minimum per bid",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextButton(
                    onPressed: () => _showMinPerBidPicker(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey[800],
                        ),
                        Text(
                          minPerBidProvider.minPerBid != null
                              ? minPerBidProvider.minPerBid.toString()
                              : "",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        Text(
                          'THB',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFf3f3f3)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // End at
          Padding(
            padding:
                const EdgeInsets.only(left: 32, right: 32, top: 12, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "Ending at",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700]),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: TextButton(
                    onPressed: () => _showEndPicker(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.grey[800],
                          size: 16,
                        ),
                        Text(
                          endDateProvider.endPicked != null
                              ? endDateProvider.formatedPicked
                              : "",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFFf3f3f3)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 10, horizontal: 16)),
                    ),
                  ),
                )
              ],
            ),
          ),

          // Description
          Container(
            margin: const EdgeInsets.only(
              top: 20,
            ),
            width: 333,
            decoration: focusDescription.hasFocus
                ? BoxDecoration(
                    boxShadow: [
                        BoxShadow(
                            blurRadius: 2,
                            color: Theme.of(context).primaryColor)
                      ],
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(18.0)))
                : null,
            child: Form(
              key: _descriptionKey,
              child: TextFormField(
                controller: widget.descriptionController,
                focusNode: focusDescription,
                keyboardType: TextInputType.text,
                maxLines: 5,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(18.0),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  hintStyle: new TextStyle(color: Colors.grey[500]),
                  hintText: "Describe this item...",
                  fillColor: Color(0xFFf3f3f3),
                  enabledBorder: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(18.0),
                      ),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
