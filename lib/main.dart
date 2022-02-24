import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:p_interest/page/chat_page.dart';
import 'package:p_interest/page/home_page.dart';
import 'package:p_interest/page/in_picture_page.dart';
import 'package:p_interest/page/pagecontrol.dart';
import 'package:p_interest/page/search_page.dart';
import 'package:p_interest/page/second_search.dart';
import 'package:p_interest/page/sliver_up.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
    //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  const PageControl(),
      builder: EasyLoading.init(),
      routes: {
        HomePage.id: (context) => HomePage(),
      //  SearchPage.id: (context) => SearchPage(),
        ChatPage.id: (context) => ChatPage(),
        SliverPage.id: (context) => SliverPage(),
        SecondSearch.id: (context) => SecondSearch(),
        PageControl.id: (context) => PageControl(),
      },
    );
  }
}

