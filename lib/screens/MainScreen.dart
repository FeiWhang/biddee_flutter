import 'package:biddee_flutter/Bodies/BidBody.dart';
import 'package:biddee_flutter/Bodies/MyItemBody.dart';
import 'package:biddee_flutter/Bodies/ProfileBody.dart';
import 'package:biddee_flutter/providers/MainScreenProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  final screens = [
    BidBody(),
    MyItemBody(),
    ProfileBody(),
  ];

  @override
  Widget build(BuildContext context) {
    var mainScreenProvider = Provider.of<MainScreenProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Biddee",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        brightness: Brightness.dark,
      ),
      body: screens[mainScreenProvider.currentIndex],
      bottomNavigationBar: _bottomNavigationBar(context, mainScreenProvider),
    );
  }
}

BottomNavigationBar _bottomNavigationBar(context, mainScreenProvider) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: mainScreenProvider.currentIndex,
    onTap: (index) {
      mainScreenProvider.currentIndex = index;
    },
    selectedFontSize: 14,
    unselectedFontSize: 14,
    selectedItemColor: Theme.of(context).primaryColorDark,
    unselectedItemColor: Theme.of(context).primaryColor,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    backgroundColor: Colors.grey[50],
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        label: "Bid",
        icon: Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 12),
          child: Image.asset(
            "assets/icons/auction.png",
            scale: 3.6,
          ),
        ),
      ),
      BottomNavigationBarItem(
        label: "My Item",
        icon: Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 12),
          child: Image.asset(
            "assets/icons/store.png",
            scale: 3.8,
          ),
        ),
      ),
      BottomNavigationBarItem(
        label: "Profile",
        icon: Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 12),
          child: Image.asset(
            "assets/icons/person.png",
            scale: 3.8,
          ),
        ),
      )
    ],
  );
}
