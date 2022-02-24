import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p_interest/page/second_search.dart';
import 'package:p_interest/page/sliver_up.dart';

import 'chat_page.dart';
import 'home_page.dart';

class PageControl extends StatefulWidget {
  const PageControl({Key? key}) : super(key: key);

  static const String id = "page_control";

  @override
  _PageControlState createState() => _PageControlState();
}

class _PageControlState extends State<PageControl> {
  int currentIndex = 0;
  int sellectedIndex = 0;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        sellectedIndex = controller.page!.toInt();
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          HomePage(),
          SecondSearch(),
          ChatPage(),
          SliverPage(),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 60, right: 60),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: const IconThemeData(color: Colors.black),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          selectedLabelStyle: TextStyle(color: Colors.black, fontSize: 13),
          //unselectedFontSize: 10,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: GestureDetector(
                    onTap: () {
                      controller.jumpToPage(0);
                    },
                    child: Icon(CupertinoIcons.home,color: sellectedIndex == 0 ? Colors.black : Colors.grey,)),
                label: "Home"),
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    controller.jumpToPage(1);
                  },
                  child:  Icon(CupertinoIcons.search,color: sellectedIndex == 1 ? Colors.black : Colors.grey,)),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    controller.jumpToPage(2);
                  },
                  child: Icon(CupertinoIcons.chat_bubble,color: sellectedIndex == 2 ? Colors.black : Colors.grey,)),
              label: "chat",
            ),
            BottomNavigationBarItem(
              icon: GestureDetector(
                  onTap: () {
                    controller.jumpToPage(3);
                  },
                  child:  Icon(CupertinoIcons.person_alt,color: sellectedIndex == 3 ? Colors.black : Colors.grey,)),
              label: "Accaunt",
            ),
          ],
        ),
      ),
    );
  }
}
