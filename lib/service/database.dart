import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:schoolar/models/user.dart';

class UserDatabaseService {
  final String uid, email;

  UserDatabaseService({this.uid, this.email});
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future newStudentDetails(
      {String username, String email, String rollno, String role}) {}
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

  Stream<UserData> get userData {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map(_userData);
  }

  UserData _userData(DocumentSnapshot documentSnapshot) {
    return UserData(
      email: documentSnapshot.data()['email'] ?? '',
      uid: uid,
      username: documentSnapshot.data()['username'] ?? '',
    );
  }

  Future updateUserDetails() async {
    return _db.collection("users").doc(uid).set(
        {
          "uid": uid,
          "lastSignIn": DateTime.now(),
        },
        // merge: true
        SetOptions(merge: true));
  }
}