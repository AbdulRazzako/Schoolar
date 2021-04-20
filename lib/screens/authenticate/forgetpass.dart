import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:schoolar/config/config.dart';
import 'package:schoolar/screens/authenticate/sign_in.dart';
import 'package:schoolar/screens/authenticate/sign_up.dart';
import 'package:schoolar/service/auth.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key key}) : super(key: key);

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  final _scafKey = GlobalKey<ScaffoldState>();
  String _email;
  final AuthService _auth = AuthService();
  void _submit() async {
    setState(() {
      isSubmitting = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await _auth.sendPasswordResetEmail(_email);
      BotToast.showText(
          text: "Link has been Sent to your Email",
          textStyle: TextStyle(color: Colors.white, fontSize: 16),
          duration: Duration(seconds: 10),
          clickClose: true);
      print('link sent');
      setState(() {
        isSubmitting = false;
      });
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => SignInScreen()), (route) => false);

      setState(() {
        isSubmitting = false;
      });
    } else {
      print("Invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scafKey,
        backgroundColor: primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(),
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Text(
                            "Password Reset",
                            style: TextStyle(
                                color: secondaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            onSaved: (val) => _email = val,
                            validator: (value) =>
                                !value.contains('@') ? "Invalid Email" : null,
                            decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: secondaryColor,
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          isSubmitting == true
                              ? Column(
                                  children: [CircularProgressIndicator()],
                                )
                              : InkWell(
                                  onTap: () {
                                    _submit();
                                  },
                                  child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width -
                                          80,
                                      child: Center(
                                          child: button(
                                              context, 'Reset Password'))),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignInScreen()));
                                  },
                                  child: Text(
                                    'Sign in here!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: secondaryColor,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpScreen()));
                                  },
                                  child: Text(
                                    'Register here',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: secondaryColor,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
