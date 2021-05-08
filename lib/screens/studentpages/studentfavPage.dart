import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:schoolar/models/user.dart';
import 'package:schoolar/widgets/header.dart';
import 'package:schoolar/widgets/drawer.dart';

class StudentFavPage extends StatefulWidget {
  @override
  _StudentFavPageState createState() => _StudentFavPageState();
}

class _StudentFavPageState extends State<StudentFavPage> {
  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<UserData>(context);

    return Scaffold(
      appBar: header(context, isAppTitle: false, strTitle: 'SAVED'),
      drawer: teacherdrawer(
        context,
        //  userData: userData
      ),
      body: Center(
        child: Text('Saved'),
      ),
    );
  }
}
