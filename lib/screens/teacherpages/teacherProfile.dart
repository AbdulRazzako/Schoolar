import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolar/config/config.dart';
import 'package:schoolar/models/teacher.dart';
import 'package:schoolar/models/user.dart';
import 'package:schoolar/widgets/drawer.dart';
import 'package:schoolar/widgets/header.dart';

class TeacherProfilePage extends StatefulWidget {
  @override
  _TeacherProfilePageState createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserData userData = Provider.of<UserData>(context);

    return Scaffold(
      appBar: header(context, isAppTitle: false, strTitle: 'PROFILE'),
      drawer: teacherdrawer(context),
      body: ListView(
        children: [
          userData == null
              ? CircularProgressIndicator()
              : creatProfileTopView(userData),
        ],
      ),
    );
  }

  Widget creatProfileTopView(UserData userData) {
    final userReference = FirebaseFirestore.instance.collection('teacher');
    return FutureBuilder(
        future: userReference.doc(userData.uid).get(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData || userData == null) {
            return CircularProgressIndicator();
          }
          // Teacher teacher = Teacher.fromDocument(dataSnapshot.data);
          return Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.pink,
                backgroundImage: userData.photourl == null
                    ? AssetImage('assets/user.png')
                    : CachedNetworkImageProvider(userData.photourl),
              ),
              Column(
                children: [
                  Container(
                    width: 200,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        userData.name == null ? 'add name' : userData.name,
                        style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        userData.clas == null
                            ? 'add class in profile'
                            : '${userData.clas} standard ',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        userData.school == null
                            ? 'add school in profile'
                            : userData.school,
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 50,
                  // ),
                  // InkWell(
                  //   onTap: () {},
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: secondaryColor,
                  //         borderRadius: BorderRadius.circular(22),
                  //         border: Border.all(color: primaryColor)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: 2, horizontal: 8),
                  //       child: Text(
                  //         'profile',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //             fontSize: 16, color: Colors.white),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          );
        });
  }
}
