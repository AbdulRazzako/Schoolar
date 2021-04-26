import 'package:cloud_firestore/cloud_firestore.dart';

class Teacher {
  final String uid, name, school, classes, email, photourl;

  Teacher(
      {this.name,
      this.school,
      this.classes,
      this.uid,
      this.email,
      this.photourl});

  factory Teacher.fromDocument(DocumentSnapshot doc) {
    return Teacher(
        uid: doc.data()['id'],
        name: doc.data()['name'],
        email: doc.data()['email'],
        classes: doc.data()['classes'],
        school: doc.data()['school'],
        photourl: doc.data()['photourl']);
  }
}
