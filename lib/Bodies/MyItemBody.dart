import 'dart:convert';
import 'dart:typed_data';

import 'package:biddee_flutter/Firebase.dart';
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
  List _myItems = [];

  @override
  void initState() {
    super.initState();

    DatabaseService().fetchMyItems().then((value) => {
          if (mounted)
            setState(() {
              _myItems = value;
            })
        });
  }

  @override
  Widget build(BuildContext context) {
    var _listTiles = <Widget>[];

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
