import 'dart:convert';
import 'dart:typed_data';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BidBody extends StatelessWidget {
  const BidBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Up for bidding",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 24,
          ),
          BidCard()
        ],
      ),
    );
  }
}

class BidCard extends StatefulWidget {
  @override
  _BidCardState createState() => _BidCardState();
}

class _BidCardState extends State<BidCard> {
  final FirebaseDatabase _firebaseDB = FirebaseDatabase.instance;
  final User _user = FirebaseAuth.instance.currentUser;

  List _bidItems = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _firebaseDB.reference().child('items').onValue.listen((event) {
        var items = event.snapshot.value;
        var bidItems = [];

        items.forEach((id, item) {
          final now = DateTime.now();
          final endDT = DateTime.parse(item['endAt']);

          if (endDT.compareTo(now) >= 0 && item['sellerID'] != _user.uid) {
            var bidItem = {
              'id': id,
              'title': item['title'],
              'description': item['description'],
              'currentPrice': item['currentPrice'],
              'imgDataUrl': item['imgDataUrl'].split(',')[1],
              'minPerBid': item['minPerBid'],
              'endDT': endDT,
            };

            bidItems.add(bidItem);
          }
        });

        bidItems.sort((a, b) => a['endDT'].compareTo(b['endDT']));
        setState(() {
          _bidItems = bidItems;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _cards = <Widget>[];

    for (var bidItem in _bidItems) {
      Uint8List imgBytes = base64Decode(bidItem['imgDataUrl']);
      String title = bidItem['title'].length > 19
          ? bidItem['title'].substring(0, 17).trim() + "..."
          : bidItem['title'];
      String description = bidItem['description'].length > 20
          ? bidItem['description']
                  .substring(0, 18)
                  .trim()
                  .replaceAll('\n', '') +
              "..."
          : bidItem['description'].replaceAll('\n', '');

      _cards.add(
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.memory(
                imgBytes,
                scale: 1.75,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              CountDown(endDT: bidItem['endDT']),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(bidItem['currentPrice'].toString() + " ฿",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 14)),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      decoration: BoxDecoration(
                          color: Color(0xFFd9ffde),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "+ " + bidItem['minPerBid'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 14),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.gavel_rounded, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        childAspectRatio: 0.5,
        crossAxisCount: 2,
        children: _cards);
  }
}

class CountDown extends StatefulWidget {
  CountDown({this.endDT});

  final DateTime endDT;

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  DateTime _countdownDT;

  _startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted)
        setState(() {
          _countdownDT.subtract(Duration(seconds: 1));
        });
    });
  }

  @override
  void initState() {
    super.initState();
    _countdownDT = widget.endDT;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    Duration _timeDiff = _countdownDT.difference(DateTime.now());

    int _dds = _timeDiff.inDays;
    int _hrs = _timeDiff.inHours - (_dds * 24);
    int _min = _timeDiff.inMinutes - (_dds * 24 * 60) - (_hrs * 60);
    int _sec = _timeDiff.inSeconds -
        (_dds * 24 * 60 * 60) -
        (_hrs * 60 * 60) -
        (_min * 60);

    String days = _dds >= 10 ? _dds.toString() : "0" + _dds.toString();
    String hrs = _hrs >= 10 ? _hrs.toString() : "0" + _hrs.toString();
    String mins = _min >= 10 ? _min.toString() : "0" + _min.toString();
    String secs = _sec >= 10 ? _sec.toString() : "0" + _sec.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(children: [
          Text(
            days,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).errorColor,
            ),
          ),
          Text(
            "days",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).errorColor,
            ),
          )
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Text(
                ":",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Theme.of(context).errorColor,
                ),
              ),
              SizedBox(height: 18),
            ],
          ),
        ),
        Column(children: [
          Text(
            hrs,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).errorColor,
            ),
          ),
          Text(
            "hrs",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).errorColor,
            ),
          )
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Text(
                ":",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Theme.of(context).errorColor,
                ),
              ),
              SizedBox(height: 18),
            ],
          ),
        ),
        Column(children: [
          Text(
            mins,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).errorColor,
            ),
          ),
          Text(
            "mins",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).errorColor,
            ),
          )
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              Text(
                ":",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Theme.of(context).errorColor,
                ),
              ),
              SizedBox(height: 18),
            ],
          ),
        ),
        Column(children: [
          Text(
            secs,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).errorColor,
            ),
          ),
          Text(
            "secs",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).errorColor,
            ),
          )
        ]),
      ],
    );
  }
}
