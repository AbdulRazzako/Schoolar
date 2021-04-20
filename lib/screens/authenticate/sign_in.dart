import 'package:flutter/material.dart';
import 'package:schoolar/config/config.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:schoolar/screens/authenticate/forgetpass.dart';
import 'package:schoolar/screens/authenticate/optlogin.dart';
import 'package:schoolar/screens/authenticate/sign_up.dart';
import 'package:schoolar/service/auth.dart';

import '../../home.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // String _pass;

  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  final _scafKey = GlobalKey<ScaffoldState>();
  String _email, _password;
  bool _obscure = true;
  final AuthService _auth = AuthService();
  void _submit() async {
    setState(() {
      isSubmitting = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      dynamic result =
          await _auth.loginWithEmailPass(_email, _password, _scafKey);
      if (result == null) {
        print('error signing in');
        setState(() {
          isSubmitting = false;
        });
      } else {
        print('signed in');
        setState(() {
          isSubmitting = false;
        });
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => Home()), (route) => false);
      }
      setState(() {
        isSubmitting = false;
      });
    } else {
      print("Invalid");
    }
  }

  // final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Text(
                      "LOGIN",
                      style: TextStyle(
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onSaved: (val) => _email = val,
                    validator: (value) =>
                        !value.contains('@') ? "Invalid Email" : null,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: secondaryColor, width: 10)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    obscureText: _obscure,
                    onSaved: (val) => _password = val,
                    validator: (value) =>
                        value.length < 6 ? 'Password too short' : null,
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        child: _obscure == true
                            ? Icon(Icons.visibility, color: secondaryColor)
                            : Icon(Icons.visibility_off, color: secondaryColor),
                        onTap: () {
                          setState(() {
                            _obscure = !_obscure;
                          });
                        },
                      ),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: secondaryColor, width: 10)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ForgotPass()),
                        );
                      },
                      child: new Text(
                        'Forgot Password',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  isSubmitting == true
                      ? Column(
                          children: [CircularProgressIndicator()],
                        )
                      : InkWell(
                          onTap: () {
                            _submit();
                          },
                          child: button(context, 'Sign In'),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Or',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Sign in with',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      dynamic result =
                          await _auth.signInWithGoogle(context: context);
                      if (result == null) {
                        print('error signing in');
                        setState(() {
                          isSubmitting = false;
                        });
                      } else {
                        print('signed in');
                        setState(() {
                          isSubmitting = false;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => Home()),
                            (route) => false);
                      }
                      setState(() {
                        isSubmitting = false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(5),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    height: 50,
                    elevation: 0,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => OTPLogin()),
                      );
                    },
                    child: Text(
                      'Logii with OTP',
                      style: TextStyle(color: Color(0xFF00CD7C)),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30),
                        side: BorderSide(color: Color(0xFF00CD7C))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => SignUpScreen()),
                          );
                        },
                        child: new Text(
                          'SIGN UP',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
