import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mustapp/pages/uploadpage.dart';
import 'package:mustapp/services/auth.dart';

import 'package:mustapp/utils/codeinput.dart';
import 'package:mustapp/utils/constant.dart';

class VerificationScreen extends StatefulWidget {
  final String phone;
  final String countryCode;
  final int screen;
  const VerificationScreen(
      {Key? key,
      required this.phone,
      required this.screen,
      required this.countryCode})
      : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String verificationid = "";
  String smscode = "";
  String verificationcode = "";
  AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.verifyPhoneNumber(
        context, widget.countryCode + widget.phone, setData);

    // verifyPhone();
    // startTimer();
  }

  verifyPhone() async {
    print("phone sent");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.countryCode + widget.phone,
        verificationCompleted: (credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            if (value.user != null) {
              //   pr.show();

              //save the person to the database
              Future.delayed(const Duration(milliseconds: 1500), () {
                // if (widget.screen.toInt() == 1) {
                Route route = MaterialPageRoute(builder: (c) => Uploadpage());
                Navigator.pushReplacement(context, route);
                //  } else {
                // Route route = MaterialPageRoute(builder: (c) => Home());
                // Navigator.pushReplacement(context, route);
                //  }
                //  setState(() {
                //  pr.hide();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => Home()),
                // );
                //   });
              });
            }
          });
        },
        verificationFailed: (Exception e) {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //  content: Text(e.toString()),
          //  duration: const Duration(seconds: 3),
          // ));
          Fluttertoast.showToast(msg: "Verification Failed Please try again");
          Navigator.pop(context);
        },
        codeSent: (String vID, int? value) {
          setState(() {
            verificationcode = vID;
          });
          startTimer();
        },
        codeAutoRetrievalTimeout: (String vID) {
          setState(() {
            verificationcode = vID;
            verificationid = vID;
          });
        },
        timeout: const Duration(seconds: 60));
  }

  int start = 30;
  void startTimer() {
  }

  void setData(verificationidFinal) {
    setState(() {
      verificationid = verificationidFinal;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: CustomHeight(context, 96.0)),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(CustomWidth(context, 32.0)),
                  child: Text("Phone Verification",
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: EdgeInsets.all(CustomWidth(context, 32.0)),
                  child: Text("To Number  +254${widget.phone.toString()}",
                      style: Theme.of(context).textTheme.headline6),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: CustomWidth(context, 16.0),
                      right: CustomWidth(context, 16.0),
                      bottom: CustomHeight(context, 48.0)),
                  child: Text(
                    "Enter your code here",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: CustomHeight(context, 64.0)),
                  child: CodeInput(
                    inputFormatters: [],
                    focusNode: FocusNode(),
                    onChanged: onchanged,
                    length: 6,
                    keyboardType: TextInputType.number,
                    builder: CodeInputBuilders.darkCircle(
                        totalRadius: customfont(context, 30),
                        emptyRadius: customfont(context, 20),
                        filledRadius: customfont(context, 26)),
                    onFilled: (value) async {
                      print('Your input is $value.');
                      setState(() {
                        smscode = value;
                      });
                      try {
                        authService.signinwithphoneNumber(widget.countryCode,
                            widget.phone, verificationid, smscode, context);
                      } catch (e) {
                        // CodeInput.
                      }
/*
                      //verify the value
                      try {
                        await FirebaseAuth.instance
                            .signInWithCredential(
                                PhoneAuthProvider.getCredential(
                                    verificationId: verificationcode,
                                    smsCode: value))
                            .then((value) {
                          if (value.user != null) {
                            pr.show();

                            //save the person to the database
                           
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Invalid OTP"),
                          duration: Duration(seconds: 3),
                        ));
                      }*/
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: CustomHeight(context, 16.0)),
                  child: Text("Fill the OTP in $start seconds",
                      style: Theme.of(context).textTheme.subtitle2),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: CustomHeight(context, 16.0)),
                  child: Text(
                    "Didn't  receive any code?",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.pop(context)
                    // authService.verifyPhoneNumber(
                    //     context, widget.countryCode + widget.phone, setData)
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "Resend new code",
                      style: TextStyle(
                        fontSize: customfont(context, 19),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onchanged(String value) {}
}
