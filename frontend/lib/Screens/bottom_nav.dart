import 'package:flutter/material.dart';
import 'package:frontend/Screens/home_screen.dart';
import 'package:frontend/constant.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    List<PersistentBottomNavBarItem> navList = [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.person,
          color: primaryColor,
          size: 30,
        ),
        inactiveIcon: const Icon(
          Icons.person,
          color: Colors.black,
        ),
        title: "Profile",
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home,
          color: primaryColor,
          size: 30,
        ),
        inactiveIcon: const Icon(
          Icons.home,
          color: Colors.black,
        ),
        title: "Menu",
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.black,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.history,
          color: primaryColor,
          size: 30,
        ),
        inactiveIcon: const Icon(
          Icons.history,
          color: Colors.black,
        ),
        title: "History",
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: Colors.black,
      ),
      
    ];
    List<Widget> screens = const [
      Scaffold(
        body: Center(
          child: Text("Demo Page 1"),
        ),
      ),
      HomeScreen(),
      Scaffold(
        body: Center(
          child: Text("Demo Page 2"),
        ),
      ),
    ];
    PersistentTabController controller =
        PersistentTabController(initialIndex: 1);
    return Scaffold(
        body: PersistentTabView(
      context,
      controller: controller,
      screens: screens,
      items: navList,
      navBarHeight: 60,
      navBarStyle: NavBarStyle.style1,
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(6),
        colorBehindNavBar: Colors.white,
      ),
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
    ));
  }
}
