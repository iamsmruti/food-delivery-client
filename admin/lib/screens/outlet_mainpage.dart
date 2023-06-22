// ignore_for_file: prefer_const_constructors

import 'package:admin/screens/add_item_page.dart';
import 'package:admin/screens/new_outlet.dart';
import 'package:admin/screens/menu_screen.dart';
import 'package:admin/screens/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class OutletMainPage extends StatefulWidget {
  const OutletMainPage({super.key});

  @override
  State<OutletMainPage> createState() => _OutletMainPageState();
}

class _OutletMainPageState extends State<OutletMainPage> {
  late PersistentTabController _controller;
  List pages = [
    Menu(),
    ItemAdd(isEdit: false),
    Center(child: Text("Next page")),
  ];

  void ontapNavigation(int index) {
    setState(() {});
  }

  checkMerchatData() {
    FirebaseFirestore.instance
        .collection("Merchants")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
      if (value.data() == null) {
        PersistentNavBarNavigator.pushNewScreen(context, screen: NewOutlet());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    checkMerchatData();
  }

  List<Widget> _buildScreens() {
    return [
      Menu(),
      ItemAdd(isEdit: false),
      // Center(
      //     child: ElevatedButton(
      //   onPressed: () {
      //     FirebaseAuth.instance.signOut().then((value) =>
      //         Navigator.pushAndRemoveUntil(
      //             context,
      //             MaterialPageRoute(builder: (context) => LoginScreen()),
      //             (route) => false));
      //   },
      //   child: Text("Logout"),
      // )),
      ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.chart_bar),
        title: ("Menu"),
        activeColorPrimary: Color.fromARGB(255, 247, 70, 97),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.plus_circle),
        title: ("Add Items"),
        activeColorPrimary: Color.fromARGB(255, 75, 78, 237),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("Profile"),
        activeColorPrimary: Color.fromARGB(255, 6, 80, 60),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style11, // Choose the nav bar style with this property.
    );
  }
}
