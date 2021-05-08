import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:schoolar/models/user.dart';
// import 'package:schoolar/config/config.dart';
import 'package:schoolar/service/auth.dart';
import 'package:schoolar/widgets/header.dart';
import 'package:schoolar/widgets/drawer.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<UserData>(context);

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
