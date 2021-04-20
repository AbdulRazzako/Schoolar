import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schoolar/models/user.dart';

import 'package:bot_toast/bot_toast.dart';
import 'package:schoolar/service/database.dart';

import '../home.dart';

import 'package:otp_text_field/otp_field.dart';

const String student = 'student';
const String teacher = 'teacher';

abstract class AuthBase {
  Stream<MyUser> get user;
  Future<MyUser> verifyPhone(BuildContext context, String phone);
  Future<void> signOut();
}

class AuthService extends AuthBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String role;
  AuthService({this.role});
  String errorMsg;
  String phoneNo, smssent, verificationID, sms;
  MyUser _userFromFirebase(User user) {
    return user != null
        ? MyUser(uid: user.uid, number: phoneNo, role: role)
        : null;
  }

  // Google Sign In

  Future<User> signInWithGoogle({@required BuildContext context}) async {
    User user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        user = userCredential.user;

        await UserDatabaseService(uid: user.uid).googleUser(
            name: user.displayName, email: user.email, role: student);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          BotToast.showText(
              text: '${e.message}',
              textStyle: TextStyle(color: Colors.white, fontSize: 16),
              duration: Duration(seconds: 10),
              animationDuration: Duration(seconds: 2),
              clickClose: true);
        } else if (e.code == 'invalid-credential') {
          // handle the error here
          BotToast.showText(
              text: '${e.message}',
              textStyle: TextStyle(color: Colors.white, fontSize: 16),
              duration: Duration(seconds: 10),
              animationDuration: Duration(seconds: 2),
              clickClose: true);
        }
      } catch (e) {
        // handle the error here
        BotToast.showText(
            text: '${e.message}',
            textStyle: TextStyle(color: Colors.white, fontSize: 16),
            duration: Duration(seconds: 10),
            animationDuration: Duration(seconds: 2),
            clickClose: true);
      }
    }

    return user;
  }

  //end google sign in

  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future<MyUser> verifyPhone(BuildContext context, String phone) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Home()), (route) => false);
      BotToast.showText(
          text: 'OTP Verified Successfully',
          duration: Duration(seconds: 2),
          align: Alignment.center);

      print(authResult);

      return AuthService(role: student)
          ._userFromFirebase(otpSignIn(authResult, phone));
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
      BotToast.showText(
          text: '${authException.message}',
          textStyle: TextStyle(color: Colors.white, fontSize: 16),
          duration: Duration(seconds: 10),
          animationDuration: Duration(seconds: 2),
          clickClose: true);
    };
    final PhoneCodeSent smsSent = (String verID, [int forceSend]) {
      this.verificationID = verID;
      smsCodeDialoge(context, phone);
    };
    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verID) {
      this.verificationID = verID;
    };
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  otpSignIn(AuthCredential authCreds, String phoneNo) async {
    try {
      UserCredential result = await _auth.signInWithCredential(authCreds);
      User user = result.user;

      await UserDatabaseService(uid: user.uid).phoneLogin(phoneNo);
      return _userFromFirebase(user);
    } catch (e) {
      print(e);
      BotToast.showText(
          text: '${e.message}',
          textStyle: TextStyle(color: Colors.white, fontSize: 16),
          duration: Duration(seconds: 10),
          animationDuration: Duration(seconds: 2),
          clickClose: true);
    }
  }

  signInWithOtp(smsCode, verId, phoneNo) {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    return otpSignIn(authCredential, phoneNo);
  }

  Future<bool> smsCodeDialoge(BuildContext context, phone) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter OTP'),
            content: OTPTextField(
              length: 6,
              width: MediaQuery.of(context).size.width - 80,
              style: TextStyle(
                fontSize: 16,
              ),
              onCompleted: (pin) {
                this.sms = pin;
              },
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () async {
                    signInWithOtp(sms, verificationID, phone);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                        (route) => false);
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.purple),
                  )),
            ],
          );
        });
  }

  Future registerStudentWithEmailPass(
      username, email, password, rollno, _scafKey) async {
    const String role = student;
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await UserDatabaseService(uid: user.uid).newStudentDetails(
          username: username, email: email, rollno: rollno, role: student);
      return AuthService(role: role)._userFromFirebase(user);
    } catch (error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          {
            errorMsg = "This email is already in use.";
            // _showErrorSnack(errorMsg, _scafKey);
            BotToast.showText(
                text: '$errorMsg',
                textStyle: TextStyle(color: Colors.white, fontSize: 16),
                duration: Duration(seconds: 10),
                animationDuration: Duration(seconds: 2),
                clickClose: true);
          }
          break;
        case "ERROR_INVALID_EMAIL":
          {
            errorMsg = "The email address is badly formatted";
            BotToast.showText(
                text: '$errorMsg',
                textStyle: TextStyle(color: Colors.white, fontSize: 16),
                duration: Duration(seconds: 10),
                animationDuration: Duration(seconds: 2),
                clickClose: true);
          }
          break;
        case "ERROR_WEAK_PASSWORD":
          {
            errorMsg = "The password must be 6 characters long or more.";
            BotToast.showText(
                text: '$errorMsg',
                textStyle: TextStyle(color: Colors.white, fontSize: 16),
                duration: Duration(seconds: 10),
                animationDuration: Duration(seconds: 2),
                clickClose: true);
          }
          break;
        default:
          {
            errorMsg = "";
          }
      }
      print(error.toString());
      return null;
    }
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      BotToast.showText(
          text: error.toString(),
          textStyle: TextStyle(color: Colors.white, fontSize: 16),
          duration: Duration(seconds: 10),
          animationDuration: Duration(seconds: 2),
          clickClose: true);
    }
  }

  Future loginWithEmailPass(email, password, _scafKey) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      dynamic role = await UserDatabaseService(uid: user.uid).getRole();
      print(role);
      await UserDatabaseService(uid: user.uid).updateUserDetails();
      return AuthService(role: role)._userFromFirebase(user);
    } catch (error) {
      switch (error.code) {
        case "ERROR_USER_NOT_FOUND":
          {
            errorMsg = "No User found";
            BotToast.showText(
                text: '$errorMsg',
                textStyle: TextStyle(color: Colors.white, fontSize: 16),
                duration: Duration(seconds: 10),
                animationDuration: Duration(seconds: 2),
                clickClose: true);
          }
          break;
        case "ERROR_INVALID_EMAIL":
          {
            errorMsg = "The email address is badly formatted";
            BotToast.showText(
                text: '$errorMsg',
                textStyle: TextStyle(color: Colors.white, fontSize: 16),
                duration: Duration(seconds: 10),
                animationDuration: Duration(seconds: 2),
                clickClose: true);
          }
          break;
        case "wrong-password":
          {
            errorMsg = "Password doesn\'t match your email.";
            // _showErrorSnack(errorMsg, _scafKey);
            BotToast.showText(
                text: '$errorMsg',
                textStyle: TextStyle(color: Colors.white, fontSize: 16),
                duration: Duration(seconds: 10),
                animationDuration: Duration(seconds: 2),
                clickClose: true);
          }

          break;
        case "too-many-requests":
          {
            errorMsg = "Too Many Requests";
            BotToast.showText(
                text: '$errorMsg',
                textStyle: TextStyle(color: Colors.white, fontSize: 16),
                duration: Duration(seconds: 10),
                animationDuration: Duration(seconds: 2),
                clickClose: true);
          }
          break;
        default:
          {
            errorMsg = "";
          }
      }
      BotToast.showText(
          text: error.toString(),
          textStyle: TextStyle(color: Colors.white, fontSize: 16),
          duration: Duration(seconds: 10),
          animationDuration: Duration(seconds: 2),
          clickClose: true);
      print(error.code);
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());

      return null;
    }
  }
}
