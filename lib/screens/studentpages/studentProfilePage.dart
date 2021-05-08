import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:schoolar/models/user.dart';
import 'package:schoolar/widgets/header.dart';
import 'package:schoolar/widgets/drawer.dart';

class StudentProfilePage extends StatefulWidget {
  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<UserData>(context);

    return Scaffold(
      appBar: header(context, isAppTitle: false, strTitle: 'PROFILE'),
      drawer: teacherdrawer(
        context,
        // userData: userData
      ),
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}
