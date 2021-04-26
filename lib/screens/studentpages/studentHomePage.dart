import 'package:flutter/material.dart';
// import 'package:schoolar/config/config.dart';
import 'package:schoolar/service/auth.dart';
import 'package:schoolar/widgets/header.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
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
