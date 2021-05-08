import 'package:flutter/material.dart';
import 'package:schoolar/service/auth.dart';
import 'package:schoolar/widgets/header.dart';
import 'package:schoolar/widgets/drawer.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      drawer: teacherdrawer(
        context,
        // userData: userData
      ),
      body: Center(
        child: Column(
          children: [
            Text('Home'),
            MaterialButton(
              onPressed: () async {
                await auth.signOut();
              },
              child: Text('signout'),
            )
          ],
        ),
      ),
    );
  }
}
