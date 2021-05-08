import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String uid, email, number, role, school, clas, rollno, photourl;
  MyUser(
      {this.email,
      this.uid,
      this.number,
      this.role,
      this.clas,
      this.rollno,
      this.school,
      this.photourl});
}

class UserData {
  String uid;
  String name;
  String email;
  String rollno;
  String clas;
  String school;
  String photourl;
  String role;
  UserData(
      {this.uid,
      this.name,
      this.email,
      this.clas,
      this.rollno,
      this.school,
      this.photourl,
      this.role});
  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
        uid: doc.data()['id'],
        name: doc.data()['name'],
        email: doc.data()['email'],
        clas: doc.data()['class'],
        school: doc.data()['school'],
        photourl: doc.data()['photourl'],
        role: doc.data()['role']);
  }
}
