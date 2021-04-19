import 'package:flutter/material.dart';
import 'package:schoolar/service/auth.dart';

class HomeMain extends StatefulWidget {
  final String uid;

  HomeMain({Key key, this.uid}) : super(key: key);
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await auth.signOut();
              })
        ],
      ),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}
