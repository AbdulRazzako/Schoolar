import 'package:flutter/material.dart';
import 'package:schoolar/widgets/header.dart';

class StudentClassPage extends StatefulWidget {
  StudentClassPage({Key key}) : super(key: key);

  @override
  _StudentClassPageState createState() => _StudentClassPageState();
}

class _StudentClassPageState extends State<StudentClassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: false, strTitle: 'CLASSES'),
      body: Center(
        child: Text('class'),
      ),
    );
  }
}
