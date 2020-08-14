import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:beirut/Screens/edit_profile.dart';
import 'package:beirut/Screens/profile.dart';
import 'package:beirut/Screens/profile_page.dart';
import 'package:beirut/Screens/search_users.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Bar extends StatefulWidget {
  static const id = '/bar';
  @override
  _BarState createState() => _BarState();
}

class _BarState extends State<Bar> with SingleTickerProviderStateMixin {
  var _bottomNavIndex = 0; //default index of first screen

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.supervised_user_circle,
    Icons.search,
    Icons.account_circle,
  ];
  var screensList = [Profile(), SearchUserPage(), ProfilePage()];
  @override
  void initState() {
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: HexColor('#21201e'),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NavigationScreen(
        screensList[_bottomNavIndex],
      ),
      floatingActionButton: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          heroTag: "bt-2",
          isExtended: true,
          elevation: 8,
          backgroundColor: HexColor('#FFA400'),
          child: Icon(
            Icons.add,
            color: HexColor('#373A36'),
          ),
          shape: CircleBorder(),
          onPressed: () {
            Navigator.pushNamed(context, EditProfile.id);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        backgroundColor: HexColor('#21201e'),
        activeIndex: _bottomNavIndex,
        activeColor: HexColor('#FFA400'),
        splashColor: HexColor('#FFA400'),
        inactiveColor: Colors.white,
        notchAndCornersAnimation: animation,
        splashSpeedInMilliseconds: 200,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.end,
        leftCornerRadius: 30,
        rightCornerRadius: 0,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  Widget _child;

  NavigationScreen(this._child) : super();

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget._child != widget._child) {
      _startAnimation();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: CircularRevealAnimation(
          animation: animation,
          centerOffset: Offset(80, 80),
          maxRadius: MediaQuery.of(context).size.longestSide * 1.1,
          child: widget._child,
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
