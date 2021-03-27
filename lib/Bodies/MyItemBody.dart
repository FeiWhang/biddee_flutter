import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class MyItemBody extends StatelessWidget {
  const MyItemBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: Text("Create new item".toUpperCase()),
        onPressed: () {
          Get.toNamed('/newitem');
        },
      ),
    );
  }
}
