import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolar/config/config.dart';
import 'package:schoolar/home.dart';
// import 'package:schoolar/screens/inroduction/introduction.dart';
import 'package:schoolar/service/auth.dart';
import 'package:bot_toast/bot_toast.dart';
import 'screens/authenticate/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Schoolar',
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: ThemeData(
          fontFamily: 'Product Sans',
          primaryColor: secondaryColor,
        ),
        home: Home(),
      ),
    );
  }
}
