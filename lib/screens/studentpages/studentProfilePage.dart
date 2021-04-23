import 'package:flutter/material.dart';
import 'package:schoolar/widgets/header.dart';

class StudentProfilePage extends StatefulWidget {
  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: false, strTitle: 'PROFILE'),
      body: Center(
        child: Text('Profile'),
      ),
    );
  }
}
