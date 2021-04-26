import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolar/config/config.dart';
import 'package:schoolar/screens/studentpages/studentClassPage.dart';
import 'package:schoolar/screens/studentpages/studentHomePage.dart';
import 'package:schoolar/screens/studentpages/studentProfilePage.dart';
import 'package:schoolar/screens/studentpages/studentSearchPage.dart';
import 'package:schoolar/screens/studentpages/studentfavPage.dart';
import 'package:schoolar/service/auth.dart';

class StudentPageView extends StatefulWidget {
  final String uid;

  StudentPageView({Key key, this.uid}) : super(key: key);
  @override
  _StudentPageViewState createState() => _StudentPageViewState();
}

class _StudentPageViewState extends State<StudentPageView> {
  AuthService auth = AuthService();
  PageController pageController;
  int getPageIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [
          StudentHomePage(),
          StudentSearchPage(),
          StudentFavPage(),
          StudentClassPage(),
          StudentProfilePage(),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        backgroundColor: primaryColor,
        onTap: onTapChangePage,
        activeColor: secondaryColor,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(icon: Icon(Icons.class__rounded)),
          BottomNavigationBarItem(icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
