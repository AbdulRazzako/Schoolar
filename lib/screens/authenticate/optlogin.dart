import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolar/config/config.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:schoolar/service/auth.dart';

class OTPLogin extends StatefulWidget {
  OTPLogin({Key key}) : super(key: key);

  @override
  _OTPLoginState createState() => _OTPLoginState();
}

class _OTPLoginState extends State<OTPLogin> {
  String _pass;

  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final _focusNode = FocusNode();

  void _submit() async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    if (_validate()) {
      await auth.verifyPhone(context, _pass).whenComplete(() {
        // setState(() {
        //   isLoading = false;
        // });
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  bool _validate() {
    final form = _formkey.currentState;
    if (form.validate()) {
      setState(() {
        isLoading = true;
      });
      form.save();
      return true;
    }
    setState(() {
      isLoading = false;
    });
    return false;
  }

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D44A3),
      // appBar: AppBar(
      //   backgroundColor: Colors.white24,
      //   elevation: 0,
      // ),
      // decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //               begin: Alignment.topRight,
      //               end: Alignment.bottomLeft,
      //               colors: [Color(0x001D44A3), Color(0x000FD7D4)]))
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF1D44A3), Color(0xFF0FD7D4)])),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  // Container(
                  //     width: MediaQuery.of(context).size.width - 100,
                  //     height: 120,
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.rectangle,
                  //       borderRadius: BorderRadius.circular(20),
                  //       image: DecorationImage(
                  //           image: AssetImage('assets/LogoText.png'),
                  //           fit: BoxFit.fitWidth),
                  //     )),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10,
                    margin: EdgeInsets.all(30),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Text(
                              "Enter your mobile number",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              "We need to text you the OTP to authenticate your account",
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black45),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 04, vertical: 22),
                            child: IntlPhoneField(
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: secondaryColor,
                                  ),
                                ),
                              ),
                              initialCountryCode: 'IN',
                              validator: (value) {
                                return value.isEmpty || value.length < 10
                                    ? 'Enter valid phone number'
                                    : null;
                              },
                              focusNode: _focusNode,
                              // onChanged: (value) {

                              // },
                              onSaved: (phone) => _pass = phone.completeNumber,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "By continuing, you accept the Privacy Policy and Terms of Service. An SMS may be sent to you with the OTP to verify your number. SMS and data may apply.",
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          isLoading == true
                              ? Column(
                                  children: [
                                    CircularProgressIndicator(),
                                  ],
                                )
                              : InkWell(
                                  onTap: () {
                                    CircularProgressIndicator();
                                    // setState(() {
                                    //   isLoading = true;
                                    // });
                                    _submit();
                                    // setState(() {
                                    //   isLoading = false;
                                    // });
                                  },
                                  child: button(context, "Send OTP")),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
