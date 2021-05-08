import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolar/config/config.dart';
import 'package:schoolar/screens/teacherpages/TeacherHomePage.dart';
import 'package:schoolar/screens/teacherpages/teacherClassPage.dart';
import 'package:schoolar/screens/teacherpages/teacherProfile.dart';
import 'package:schoolar/screens/teacherpages/teacherSearchPage.dart';
import 'package:schoolar/screens/teacherpages/teacherUpload.dart';
import 'package:schoolar/service/auth.dart';

class TeacherPageView extends StatefulWidget {
  final String uid;

  TeacherPageView({Key key, this.uid}) : super(key: key);
  @override
  _TeacherPageViewState createState() => _TeacherPageViewState();
}

class _TeacherPageViewState extends State<TeacherPageView> {
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
          TeacherHomePage(),
          TeacherSearchPage(),
          TeacherUploadPage(),
          TeacherClassPage(),
          TeacherProfilePage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined)),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined)),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined)),
          BottomNavigationBarItem(icon: Icon(Icons.class__outlined)),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline)),
        ],
      ),
    );
  }
}
