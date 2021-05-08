import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:schoolar/models/user.dart';
import 'package:schoolar/widgets/header.dart';
import 'package:schoolar/widgets/drawer.dart';

class StudentClassPage extends StatefulWidget {
  StudentClassPage({Key key}) : super(key: key);

  @override
  _StudentClassPageState createState() => _StudentClassPageState();
}

class _StudentClassPageState extends State<StudentClassPage> {
  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<UserData>(context);

    return Scaffold(
      appBar: header(context, isAppTitle: false, strTitle: 'CLASSES'),
      drawer: teacherdrawer(
        context,
      ),
      body: Center(
        child: Text('class'),
      ),
    );
  }
}
