import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/POSTDATA/postquestions.dart';
import 'package:flutter_app/UI/chatscreen.dart';
import 'package:flutter_app/UI/mainpage.dart';
import 'package:flutter_app/UI/trendpost.dart';
import 'package:flutter_app/UI/setting.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  PersistentTabController _controller=PersistentTabController(initialIndex: 0);


  List<Widget> _buildScreens() {
    return [
      MainScreen(),
      TrendPost(),

      PostQuestion(),
      Setting(),



    ];
  }


  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        activeContentColor: Colors.white,
        icon: Icon(CupertinoIcons.home,size: 25,),
        title: ("Home"),
        titleFontSize: 14,
        activeColor: CupertinoColors.activeGreen,
        inactiveColor: CupertinoColors.white,
      ),

      PersistentBottomNavBarItem(
        activeContentColor: Colors.white,

        icon: Icon(CupertinoIcons.news,size: 25),
        title: ("TrendPost"),
        titleFontSize: 14,
        activeColor: CupertinoColors.activeGreen,
        inactiveColor: CupertinoColors.white,
      ),


      PersistentBottomNavBarItem(
        activeContentColor: Colors.white,

        titleFontSize: 14,
        icon: Icon(CupertinoIcons.add_circled,size: 25),
        title: ("Post"),
        activeColor: CupertinoColors.activeGreen,
        inactiveColor: CupertinoColors.white,
      ),


      PersistentBottomNavBarItem(
        activeContentColor: Colors.white,

        titleFontSize: 14,
        icon: Icon(CupertinoIcons.settings,size: 25),
        title: ("Settings"),
        activeColor: CupertinoColors.activeGreen,
        inactiveColor: CupertinoColors.white,
      ),







    ];
  }

  @override
  Widget build(BuildContext context) {

    return PersistentTabView(
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Color(0xFF000000),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears.
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.

      popAllScreensOnTapOfSelectedTab: true,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
    );
  }
}
