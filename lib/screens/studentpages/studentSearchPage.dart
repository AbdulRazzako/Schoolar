import 'package:flutter/material.dart';
import 'package:schoolar/widgets/header.dart';

class StudentSearchPage extends StatefulWidget {
  @override
  _StudentSearchPageState createState() => _StudentSearchPageState();
}

class _StudentSearchPageState extends State<StudentSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: false, strTitle: 'SEARCH'),
      body: Center(
        child: Text('Search'),
      ),
    );
  }
}
