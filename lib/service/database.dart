// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolar/models/user.dart';

class UserDatabaseService {
  final String uid, email;

  UserDatabaseService({this.uid, this.email});
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future newStudentDetails(
      {String username,
      String email,
      String school,
      String classno,
      String rollno,
      String role,
      String photourl}) async {
    return _db.collection("student").doc(uid).set({
      "uid": uid,
      "lastSignIn": DateTime.now(),
      "name": username,
      "email": email,
      "school": school,
      "class": classno,
      "rollNo": rollno,
      "role": role,
      "photourl": photourl,
    }, SetOptions(merge: true));
  }

  //new teacher entry
  Future newTeacherDetails(
      {String username,
      String email,
      String school,
      String classno,
      String rollno,
      String role,
      String photourl}) async {
    return _db.collection("teacher").doc(uid).set({
      "uid": uid,
      "lastSignIn": DateTime.now(),
      "name": username,
      "email": email,
      "school": school,
      "class": classno,
      "role": role,
      "photourl": photourl
    }, SetOptions(merge: true));
  }

  Future googleUser(
      {String name,
      String email,
      String role,
      String photoUrl,
      String phoneno}) async {
    return _db.collection("student").doc(uid).set({
      "uid": uid,
      "lastSignIn": DateTime.now(),
      "name": name,
      "email": email,
      "role": role,
      "photourl": photoUrl,
      "phoneNo": phoneno,
    }, SetOptions(merge: true));
  }

  Future phoneLogin(String phoneNo) async {
    return _db.collection("student").doc(uid).set({
      "uid": uid,
      "lastSignIn": DateTime.now(),
      "phoneNo": phoneNo,
    }, SetOptions(merge: true));
  }

  Future<String> getRole() async {
    print(uid);
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('teacher').doc(uid).get();
    if (snapshot.exists) {
      String role = snapshot['role'];
      return role;
    } else {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('customerService')
          .doc(uid)
          .get();
      if (snapshot.exists) {
        String role = 'cs';
        return role;
      } else {
        return 'student';
      }
    }
  }

  Stream<UserData> get studentData {
    return FirebaseFirestore.instance
        .collection('student')
        .doc(uid)
        .snapshots()
        .map(_userData);
  }

  Stream<UserData> get teacherData {
    return FirebaseFirestore.instance
        .collection('teacher')
        .doc(uid)
        .snapshots()
        .map(_userData);
  }

  UserData _userData(DocumentSnapshot documentSnapshot) {
    return UserData(
      email: documentSnapshot.data()['email'] ?? '',
      uid: uid,
      name: documentSnapshot.data()['name'] ?? '',
      school: documentSnapshot.data()['school'],
      clas: documentSnapshot.data()['class'],
      rollno: documentSnapshot.data()['rollno'],
      photourl: documentSnapshot.data()['photourl'],
    );
  }

  Future updateStudentDetails() async {
    return _db.collection("student").doc(uid).set(
        {
          "uid": uid,
          "lastSignIn": DateTime.now(),
        },
        // merge: true
        SetOptions(merge: true));
  }

  Future updateTeacherDetails() async {
    return _db.collection("teacher").doc(uid).set(
        {
          "uid": uid,
          "lastSignIn": DateTime.now(),
        },
        // merge: true
        SetOptions(merge: true));
  }

  Future savePostInfoToFireStore(
      {String uid,
      String url,
      String description,
      String postid,
      String username}) async {
    _db.collection('teacherposts').doc(postid).set({
      "post Id": postid,
      "ownerId": uid,
      'timestamp': Timestamp.now(),
      'likes': {},
      'username': username,
      'url': url,
      'description': description,
    });
  }
}
