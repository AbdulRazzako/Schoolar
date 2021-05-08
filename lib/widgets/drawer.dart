import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolar/config/config.dart';
import 'package:provider/provider.dart';
import 'package:schoolar/models/teacher.dart';
import 'package:schoolar/models/user.dart';

Drawer teacherdrawer(
  context,
) {
  UserData userData = Provider.of<UserData>(context);
  final userReference = FirebaseFirestore.instance.collection('teacher');

  // userData.role == 'teacher'
  //     ? FirebaseFirestore.instance.collection('teacher')
  //     : FirebaseFirestore.instance.collection('student');

  creatProfileTopView() {
    return FutureBuilder(
      // initialData: CircularProgressIndicator,
      future: userReference.doc(userData.uid).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData || userData == null) {
          return CircularProgressIndicator();
        }

        // Teacher teacher = Teacher.fromDocument(dataSnapshot.data);
        return Container(
          color: secondaryColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 40, 8, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ),
          ),
        );
      },
    );
  }

  return Drawer(
    child: SafeArea(
      child: ListView(
        children: [
          userData == null ? LinearProgressIndicator() : creatProfileTopView(),
          // userData == null
          //     ? LinearProgressIndicator()
          //     : Container(
          //         color: secondaryColor,
          //         child: Padding(
          //           padding: const EdgeInsets.fromLTRB(8, 40, 8, 40),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               CircleAvatar(
          //                 radius: 40,
          //                 backgroundColor: Colors.pink,
          //                 backgroundImage: userData.photourl == null
          //                     ? AssetImage('assets/user.png')
          //                     : CachedNetworkImageProvider(userData.photourl),
          //               ),
          //               Column(
          //                 children: [
          //                   Container(
          //                     width: 200,
          //                     child: FittedBox(
          //                       fit: BoxFit.scaleDown,
          //                       child: Text(
          //                         userData.name == null
          //                             ? 'add name'
          //                             : userData.name,
          //                         style: TextStyle(
          //                             color: primaryColor,
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 20),
          //                       ),
          //                     ),
          //                   ),
          //                   Container(
          //                     width: 200,
          //                     child: FittedBox(
          //                       fit: BoxFit.scaleDown,
          //                       child: Text(
          //                         userData.clas == null
          //                             ? 'add class in profile'
          //                             : '${userData.clas} standard ',
          //                         style: TextStyle(color: primaryColor),
          //                       ),
          //                     ),
          //                   ),
          //                   Container(
          //                     width: 200,
          //                     child: FittedBox(
          //                       fit: BoxFit.scaleDown,
          //                       child: Text(
          //                         userData.school == null
          //                             ? 'add school in profile'
          //                             : userData.school,
          //                         style: TextStyle(color: primaryColor),
          //                       ),
          //                     ),
          //                   ),
          //                   // SizedBox(
          //                   //   height: 50,
          //                   // ),
          //                   // InkWell(
          //                   //   onTap: () {},
          //                   //   child: Container(
          //                   //     decoration: BoxDecoration(
          //                   //         color: secondaryColor,
          //                   //         borderRadius: BorderRadius.circular(22),
          //                   //         border: Border.all(color: primaryColor)),
          //                   //     child: Padding(
          //                   //       padding: const EdgeInsets.symmetric(
          //                   //           vertical: 2, horizontal: 8),
          //                   //       child: Text(
          //                   //         'profile',
          //                   //         textAlign: TextAlign.center,
          //                   //         style: TextStyle(
          //                   //             fontSize: 16, color: Colors.white),
          //                   //       ),
          //                   //     ),
          //                   //   ),
          //                   // ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          studentDrawerButton(Icons.person_add, 'Tell a friend'),
          studentDrawerButton(Icons.privacy_tip, 'Privacy Policy'),
          studentDrawerButton(Icons.info_rounded, 'About Us'),
          studentDrawerButton(Icons.support, 'Support Us')
        ],
      ),
    ),
  );
}

Padding studentDrawerButton(IconData icon, String btnstring) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: InkWell(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: secondaryColor,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  btnstring,
                  style: TextStyle(color: secondaryColor, fontSize: 20),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: secondaryColor,
            )
          ],
        ),
      ),
    ),
  );
}
