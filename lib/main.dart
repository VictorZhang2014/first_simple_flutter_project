/*
 * Building a Cupertino app with Flutter: 
 * https://codelabs.developers.google.com/codelabs/flutter-cupertino#0
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saysth/utility/PublicColors.dart';

import 'package:saysth/home/SSHomePhotoPage.dart';
import 'package:saysth/Photo/SSPostCreatePage.dart';

import 'package:saysth/message/SSMessagePage.dart';
import 'package:saysth/profile/SSProfilePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit orientations to portrait up and down.
    // 设置App的仅竖屏模式
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // 设置顶部状态栏的颜色
    // SystemChrome.setSystemUIOverlayStyle(
    // SystemUiOverlayStyle(statusBarColor: Colors.white));
    return CupertinoApp(
        debugShowCheckedModeBanner: false, // 首页右上角的debug显示
        title: 'SaySth',
        //theme: const CupertinoThemeData(brightness: Brightness.light),
        home: MyHomePage(),
        routes: {
          '/homephoto': (_) => SSHomePhotoPage(),
          '/postcreate': (_) => SSPostCreatePage(),
          '/message': (_) => SSMessagePage(),
          '/profile': (_) => SSProfilePage(),
        });
  }
}

// Main Screen
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _pages = [
    SSHomePhotoPage(),
    SSMessagePage(),
    SSProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // navigationBar: CupertinoNavigationBar(
      //   middle: Text('底部三个tab共用一个顶部导航栏'),
      // ),
      child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            // backgroundColor: PublicColors.mainPurple,
            // activeColor: PublicColors.mainGreen,
            // inactiveColor: PublicColors.mainGreen.withOpacity(.60),
            backgroundColor: PublicColors.pureWhite,
            activeColor: PublicColors.mainGreen,
            inactiveColor: PublicColors.mainGreen.withOpacity(.50),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.travel_explore),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.textsms),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
              )
            ],
          ),
          tabBuilder: (BuildContext context, index) {
            return _pages[index];
          }),
    );
  }
}
