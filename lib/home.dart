import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolar/models/user.dart';
import 'package:schoolar/screens/homepage.dart';
import 'package:schoolar/service/auth.dart';
import 'package:schoolar/service/database.dart';
import 'package:schoolar/widgets/loader.dart';

import 'screens/authenticate/sign_in.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Scaffold(
      body: StreamBuilder(
        stream: auth.user,
        builder: (context, snapshot) {
          MyUser user = snapshot.data;
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loader();
            } else if (user == null) {
              return Provider<MyUser>.value(value: user, child: SignInScreen());
            } else if (user != null) {
              return FutureBuilder<String>(
                future: UserDatabaseService(uid: user.uid).getRole(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Loader();
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Loader();
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Error: Connection Error. Please make sure you are connected with Internet and retry again.',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: MaterialButton(
                                  child: Text(
                                    'Retry',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.blueAccent,
                                  onPressed: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => Home())),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        if (snapshot.data == 'student') {
                          return MultiProvider(
                            providers: [
                              StreamProvider<UserData>.value(
                                value:
                                    UserDatabaseService(uid: user.uid).userData,
                                initialData: null,
                              ),
                            ],
                            child: MaterialApp(
                                debugShowCheckedModeBanner: false,
                                home: HomeMain(
                                  uid: user.uid,
                                )),
                          );
                        }
                      }
                  }
                  return Home();
                },
              );
            }
          }
          return Loader();
        },
      ),
    );
  }
}
