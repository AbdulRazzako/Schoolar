// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:schoolar/config/config.dart';
import 'package:schoolar/screens/authenticate/sign_in.dart';
import 'package:schoolar/service/auth.dart';

import '../../home.dart';

class SignUpTeacherScreen extends StatefulWidget {
  @override
  _SignUpTeacherScreenState createState() => _SignUpTeacherScreenState();
}

class _SignUpTeacherScreenState extends State<SignUpTeacherScreen> {
  // String _pass;
  //
  List<String> classno = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  var schoolSelected, classSelected;
  final _formKey = GlobalKey<FormState>();
  final _scafKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String _email, _password, _username;
  //String _rollno;

  bool isSubmitting = false, _obscure = true;
  // final _focusNode = FocusNode();

  AuthService _auth = AuthService();
  void _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _register();
    } else {
      print("Invalid");
    }
  }

  void _register() async {
    setState(() {
      isSubmitting = true;
    });
    try {
      dynamic result = await _auth.registerTeacherWithEmailPass(
          username: _username,
          email: _email,
          password: _password,
          school: schoolSelected,
          classno: classSelected);
      if (result == null) {
        print('error signing in');
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
    } catch (error) {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'SIGN UP',
          style: TextStyle(color: secondaryColor),
        ),
      ),
      key: _scafKey,
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),

                  TextFormField(
                    onSaved: (val) => _username = val,
                    validator: (value) =>
                        value.length < 1 ? "Invalid Name" : null,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onSaved: (val) => _email = val,
                    validator: (value) =>
                        !value.contains('@') ? "Invalid Email" : null,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: secondaryColor, width: 10)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  //dropdown for class
                  //
                  //

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('schools')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('loading');
                      } else {
                        List<DropdownMenuItem> schoolitem = [];
                        for (int i = 0; i < snapshot.data.docs.length; i++) {
                          DocumentSnapshot snap = snapshot.data.docs[i];
                          schoolitem.add(DropdownMenuItem(
                            child: Text(snap.id),
                            value: snap.id,
                          ));
                        }
                        return DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),
                            filled: true,
                          ),
                          items: schoolitem,
                          hint: Text(
                            "School(optional)",
                          ),
                          onChanged: (selecetedvalue) {
                            setState(() {
                              schoolSelected = selecetedvalue;
                            });
                          },
                          value: schoolSelected,
                        );
                      }
                    },
                  ),

                  // End of school
                  SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        filled: true,
                      ),
                      items: classno.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "Class",
                      ),
                      onChanged: (selecetedvalue) {
                        setState(() {
                          classSelected = selecetedvalue;
                        });
                      },
                      value: classSelected),
                  // TextFormField(
                  //   keyboardType: TextInputType.number,
                  //   onSaved: (val) => _rollno = val,
                  //   decoration: InputDecoration(
                  //     labelText: 'Class',
                  //     labelStyle: TextStyle(
                  //         fontWeight: FontWeight.bold, color: Colors.grey),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),

                  // TextFormField(
                  //   keyboardType: TextInputType.number,
                  //   onSaved: (val) => _rollno = val,
                  //   decoration: InputDecoration(
                  //     labelText: 'Roll Number',
                  //     labelStyle: TextStyle(
                  //         fontWeight: FontWeight.bold, color: Colors.grey),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  isSubmitting == true
                      ? Column(
                          children: [CircularProgressIndicator()],
                        )
                      : InkWell(
                          onTap: () {
                            _submit();
                          },
                          child: button(context, 'Sign Up')),
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
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => SignInScreen()),
                          );
                        },
                        child: new Text(
                          'SIGN IN',
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
