import 'dart:async';

import 'package:flutter/material.dart';

class CountDown extends StatefulWidget {
  CountDown({@required this.endDT, @required this.isBig});

  final DateTime endDT;
  final bool isBig;

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
              fontSize: widget.isBig ? 18 : 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).errorColor,
            ),
          ),
          Text(
            "days",
            style: TextStyle(
              fontSize: widget.isBig ? 16 : 12,
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
                  fontSize: widget.isBig ? 19 : 15,
                  color: Theme.of(context).errorColor,
                ),
              ),
              SizedBox(
                height: widget.isBig ? 24 : 18,
              ),
            ],
          ),
        ),
        Column(children: [
          Text(
            hrs,
            style: TextStyle(
              fontSize: widget.isBig ? 18 : 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).errorColor,
            ),
          ),
          Text(
            "hrs",
            style: TextStyle(
              fontSize: widget.isBig ? 16 : 12,
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
                  fontSize: widget.isBig ? 19 : 15,
                  color: Theme.of(context).errorColor,
                ),
              ),
              SizedBox(
                height: widget.isBig ? 24 : 18,
              ),
            ],
          ),
        ),
        Column(children: [
          Text(
            mins,
            style: TextStyle(
              fontSize: widget.isBig ? 18 : 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).errorColor,
            ),
          ),
          Text(
            "mins",
            style: TextStyle(
              fontSize: widget.isBig ? 16 : 12,
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
                  fontSize: widget.isBig ? 19 : 15,
                  color: Theme.of(context).errorColor,
                ),
              ),
              SizedBox(
                height: widget.isBig ? 24 : 18,
              ),
            ],
          ),
        ),
        Column(children: [
          Text(
            secs,
            style: TextStyle(
              fontSize: widget.isBig ? 18 : 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).errorColor,
            ),
          ),
          Text(
            "secs",
            style: TextStyle(
              fontSize: widget.isBig ? 16 : 12,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).errorColor,
            ),
          )
        ]),
      ],
    );
  }
}
