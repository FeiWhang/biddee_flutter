import 'dart:convert';
import 'dart:typed_data';

import 'package:biddee_flutter/Firebase.dart';
import 'package:biddee_flutter/components/CountDown.dart';
import 'package:biddee_flutter/providers/PlaceBidProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class PlaceBidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _placeBidIDProvider = Provider.of<PlaceBidIDProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Get.back()),
        title: Text("Place a bid"),
        backgroundColor: Theme.of(context).primaryColorDark,
        brightness: Brightness.dark,
      ),
      body: PlaceBidBody(placeBidIDProvider: _placeBidIDProvider),
    );
  }
}

class PlaceBidBody extends StatefulWidget {
  const PlaceBidBody({@required this.placeBidIDProvider});
  final placeBidIDProvider;

  @override
  _PlaceBidBodyState createState() => _PlaceBidBodyState();
}

class _PlaceBidBodyState extends State<PlaceBidBody> {
  final TextEditingController customBidController = TextEditingController();

  final FirebaseDatabase _firebaseDB = FirebaseDatabase.instance;

  String seller;
  String itemID;
  Map itemData;

  @override
  void initState() {
    super.initState();

    itemID = widget.placeBidIDProvider.itemID;

    _firebaseDB
        .reference()
        .child('items')
        .child(itemID)
        .onValue
        .listen((event) {
      final item = event.snapshot.value;

      _firebaseDB
          .reference()
          .child('users')
          .child(item['sellerID'])
          .child('firstName')
          .once()
          .then((snapshot) {
        if (mounted)
          setState(() {
            seller = snapshot.value;
          });
      });
      if (mounted)
        setState(() {
          itemData = {
            'title': item['title'],
            'description': item['description'],
            'currentPrice': item['currentPrice'],
            'minBid': item['currentPrice'] + item['minPerBid'],
            'imgDataUrl': item['imgDataUrl'].split(',')[1],
            'endDT': DateTime.parse(item['endAt']),
          };
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    Uint8List imgBytes =
        itemData != null ? base64Decode(itemData['imgDataUrl']) : null;

    return itemData != null && seller != null
        ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 275.0,
                          height: 275.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(
                                imgBytes,
                              ),
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                        SizedBox(height: 12),
                        CountDown(endDT: itemData['endDT'], isBig: true)
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Current Price:',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      SizedBox(width: 12),
                      Container(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).shadowColor,
                              borderRadius: BorderRadius.circular(24)),
                          child: Text(
                            itemData['currentPrice'].toString() + " ฿",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          )),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                              title: Text(
                                "Quick Bid",
                              ),
                              content: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text("Confirm bid at " +
                                    itemData['minBid'].toString() +
                                    " THB?"),
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  child: Text("Cancel",
                                      style: TextStyle(
                                          color: Theme.of(context).errorColor)),
                                  onPressed: () => Get.back(),
                                ),
                                CupertinoDialogAction(
                                  child: Text("Confirm"),
                                  onPressed: () {
                                    // do firebase process
                                    DatabaseService()
                                        .placeBid(itemID, itemData['minBid']);
                                    // close dialog
                                    Get.back();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              itemData['minBid'].toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.gavel_rounded,
                              color: Colors.grey[800],
                              size: 16,
                            ),
                          ],
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFd9ffde)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 12)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Bid:',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      SizedBox(width: 12),
                      PlaceBidForm(
                        customBidController: customBidController,
                        minBid: itemData['minBid'],
                      ),
                      SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          String err = "";

                          if (customBidController.value.text == "") {
                            err = "Bid cannot be empty";
                          } else {
                            if (int.parse(customBidController.value.text) <
                                itemData['minBid']) {
                              err = "Bid cannot be less than " +
                                  itemData['minBid'].toString();
                            }
                          }

                          err == ""
                              ? showDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                    title: Text(
                                      "Place Bid",
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text("Confirm bid at " +
                                          customBidController.value.text +
                                          " THB?"),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text("Cancel",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor)),
                                        onPressed: () => Get.back(),
                                      ),
                                      CupertinoDialogAction(
                                        child: Text("Confirm"),
                                        onPressed: () {
                                          // do firebase process
                                          DatabaseService().placeBid(
                                              itemID,
                                              int.parse(customBidController
                                                  .value.text));
                                          // close dialog
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : showDialog(
                                  context: context,
                                  builder: (_) => CupertinoAlertDialog(
                                    title: Text(
                                      "Failed to place bid",
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(err),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: Text("OK"),
                                        onPressed: () {
                                          // close dialog
                                          Get.back();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                        },
                        child: Row(
                          children: [
                            Text(
                              'PLACE BID',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.gavel_rounded,
                              color: Colors.grey[800],
                              size: 16,
                            ),
                          ],
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFd9ffde)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 12)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemData['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 18),
                        ),
                        Text(
                          "by " + seller,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 13),
                        ),
                        SizedBox(height: 12),
                        Text(
                          itemData['description'],
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 120)
                ],
              ),
            ),
          )
        : SizedBox();
  }
}

class PlaceBidForm extends StatefulWidget {
  final TextEditingController customBidController;
  final int minBid;
  PlaceBidForm({this.customBidController, this.minBid});

  @override
  _PlaceBidFormState createState() => _PlaceBidFormState();
}

class _PlaceBidFormState extends State<PlaceBidForm> {
  GlobalKey<FormState> _customBidKey = new GlobalKey<FormState>();
  FocusNode focusCustomBid = FocusNode();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      focusCustomBid.addListener(() => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: focusCustomBid.hasFocus
          ? BoxDecoration(
              boxShadow: [
                  BoxShadow(
                      blurRadius: 2, color: Theme.of(context).primaryColor)
                ],
              borderRadius: const BorderRadius.all(const Radius.circular(18.0)))
          : null,
      child: Form(
        key: _customBidKey,
        child: TextFormField(
          controller: widget.customBidController,
          focusNode: focusCustomBid,
          keyboardType: TextInputType.number,
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(18.0),
                ),
                borderSide: BorderSide.none),
            filled: true,
            contentPadding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            hintStyle: new TextStyle(color: Colors.grey[500]),
            hintText: "at least " + widget.minBid.toString(),
            fillColor: Color(0xFFf3f3f3),
            enabledBorder: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(18.0),
                ),
                borderSide: BorderSide.none),
          ),
        ),
      ),
    );
  }
}
