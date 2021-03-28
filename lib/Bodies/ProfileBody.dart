import 'package:biddee_flutter/Firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({Key key}) : super(key: key);

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  String firstName = '';
  int numBids = 0;
  int numItems = 0;
  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(FirebaseAuth.instance.currentUser.uid)
        .once()
        .then((snapshot) {
      if (mounted) {
        Map user = snapshot.value;
        setState(() {
          firstName = user['firstName'];
          numItems = user.containsKey('myItems') ? user['myItems'].length : 0;
          numBids = user.containsKey('myBids') ? user['myBids'].length : 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Hi, " + firstName + " !",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 48),
          Text(
            "You have bidded over " + numBids.toString() + " times",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),
          Text(
            "You have created " + numItems.toString() + " items",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 64),
          ElevatedButton(
            onPressed: () {
              final res = AuthenticationService().logOut();

              res.then((value) {
                if (value == "loggedout") {
                  Get.offAllNamed('/login');
                } else {
                  Get.dialog(CupertinoAlertDialog(
                    title: Text('Failed to log out'),
                    content: Text(value),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ));
                }
              });
            },
            child: Text("Log out"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).errorColor),
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
