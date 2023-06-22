import 'package:admin/screens/Menu/add_item_page.dart';
import 'package:admin/screens/Menu/menu_screen.dart';
import 'package:admin/screens/orders.dart';
import 'package:admin/screens/profile_page.dart';
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
    const Menu(),
    const ItemAdd(isEdit: false),
    const Center(child: Text("Next page")),
    const Center(child: Text("Next page")),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      const Menu(),
      const ItemAdd(isEdit: false),
      Orders(),
      const ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.chart_bar),
        title: ("Menu"),
        activeColorPrimary: const Color.fromARGB(255, 247, 70, 97),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.plus_circle),
        title: ("Add Items"),
        activeColorPrimary: const Color.fromARGB(255, 75, 78, 237),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.cart),
        title: ("Orders"),
        activeColorPrimary: const Color.fromARGB(255, 75, 78, 237),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person),
        title: ("Profile"),
        activeColorPrimary: const Color.fromARGB(255, 6, 80, 60),
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
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
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
