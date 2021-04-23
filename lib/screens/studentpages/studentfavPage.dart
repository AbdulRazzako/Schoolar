import 'package:flutter/material.dart';
import 'package:schoolar/widgets/header.dart';

class StudentFavPage extends StatefulWidget {
  @override
  _StudentFavPageState createState() => _StudentFavPageState();
}

class _StudentFavPageState extends State<StudentFavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: false, strTitle: 'SAVED'),
      body: Center(
        child: Text('Saved'),
      ),
    );
  }
}
