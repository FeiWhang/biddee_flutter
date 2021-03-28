import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MyItemBody extends StatelessWidget {
  const MyItemBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My item",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                TextButton(
                  child: Row(
                    children: [
                      Text(
                        "Create new item".toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 18,
                      )
                    ],
                  ),
                  onPressed: () {
                    Get.toNamed('/newitem');
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            MyItemCard()
          ],
        ),
      ),
    );
  }
}

class MyItemCard extends StatefulWidget {
  @override
  _MyItemCardState createState() => _MyItemCardState();
}

class _MyItemCardState extends State<MyItemCard> {
  final FirebaseDatabase _firebaseDB = FirebaseDatabase.instance;
  final User _user = FirebaseAuth.instance.currentUser;

  List _myItems = [];

  @override
  void initState() {
    super.initState();

    _firebaseDB
        .reference()
        .child('users')
        .child(_user.uid)
        .child('myItems')
        .onValue
        .listen((event) {
      List myItemIDs = event.snapshot.value;
      // item update
      if (_myItems.length >= myItemIDs.length) {
        for (var myItemID in myItemIDs) {
          _firebaseDB
              .reference()
              .child('items')
              .child(myItemID)
              .onValue
              .listen((event) {
            if (mounted) {
              Map itemData = event.snapshot.value;
              String endDate = itemData['endAt'];
              String dd = endDate.substring(8, 10);
              String mm = endDate.substring(5, 7);
              String yy = endDate.substring(0, 4);
              String hrs = endDate.substring(11, 13);
              String min = endDate.substring(14, 16);
              String endAt =
                  dd + "/" + mm + "/" + yy + " at " + hrs + ":" + min;

              DateTime endDT = DateTime.parse(itemData['endAt']);
              DateTime now = DateTime.now();

              Map myItem = {
                'id': myItemID,
                'title': itemData['title'],
                'currentPrice': itemData['currentPrice'],
                'endAt': endAt,
                'status': endDT.isAfter(now),
                'imgDataUrl': itemData['imgDataUrl'].split(',')[1],
              };
              setState(() {
                for (var item in _myItems) {
                  if (item['id'] == myItemID) {
                    item['title'] = myItem['title'];
                    item['description'] = myItem['description'];
                    item['currentPrice'] = myItem['currentPrice'];
                  }
                }
              });
            }
          });
        }
      } else {
        myItemIDs = myItemIDs.sublist(_myItems.length);
        for (var myItemID in myItemIDs) {
          _firebaseDB
              .reference()
              .child('items')
              .child(myItemID)
              .onValue
              .listen((event) {
            if (mounted) {
              Map itemData = event.snapshot.value;
              String endDate = itemData['endAt'];
              String dd = endDate.substring(8, 10);
              String mm = endDate.substring(5, 7);
              String yy = endDate.substring(0, 4);
              String hrs = endDate.substring(11, 13);
              String min = endDate.substring(14, 16);
              String endAt =
                  dd + "/" + mm + "/" + yy + " at " + hrs + ":" + min;

              DateTime endDT = DateTime.parse(itemData['endAt']);
              DateTime now = DateTime.now();

              Map myItem = {
                'id': myItemID,
                'endDT': endDT,
                'title': itemData['title'],
                'currentPrice': itemData['currentPrice'],
                'endAt': endAt,
                'status': endDT.isAfter(now),
                'imgDataUrl': itemData['imgDataUrl'].split(',')[1],
              };
              setState(() {
                _myItems.add(myItem);
              });
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _listTiles = <Widget>[];

    if (mounted && _myItems.length > 1) {
      setState(() {
        _myItems.sort((a, b) => a['endDT'].compareTo(b['endDT']));
      });
    }

    for (var myItem in _myItems) {
      Uint8List imgBytes = base64Decode(myItem['imgDataUrl']);
      String title = myItem['title'].length > 23
          ? myItem['title'].substring(0, 21).trim() + '...'
          : myItem['title'];

      _listTiles.add(
        Card(
          margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.memory(
                      imgBytes,
                      scale: 2.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text("End  " + myItem['endAt']),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              decoration: BoxDecoration(
                                  color: myItem['status']
                                      ? Color(0xFFd9ffde)
                                      : Color(0xFFff9c9c),
                                  borderRadius: BorderRadius.circular(12)),
                              child:
                                  Text(myItem['status'] ? 'active' : 'closed'),
                            ),
                            SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                  myItem['currentPrice'].toString() + " ฿"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox()
            ],
          ),
        ),
      );
    }
    return Column(children: _listTiles);
  }
}
