import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/itemscreeens/Resetpassword.dart';
import 'package:mustapp/screens/adminlogin.dart';
import 'package:mustapp/screens/register.dart';
import 'package:mustapp/screens/verifynumber.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/navigator.dart';
import 'package:mustapp/widgets/edittext.dart';
import 'package:mustapp/widgets/submitbutton.dart';

class AdminRegisterscreen extends StatefulWidget {
  @override
  State<AdminRegisterscreen> createState() => _AdminRegisterscreenState();
}

class _AdminRegisterscreenState extends State<AdminRegisterscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
bool isloading = false;
  String errortext = "";
  final GlobalKey<FormState> formk = GlobalKey<FormState>();
  TextEditingController _controllername = TextEditingController();
  TextEditingController _controllerphone = TextEditingController();

  TextEditingController _controlleremail = TextEditingController();

  TextEditingController _controllerpassword = TextEditingController();

  TextEditingController _controllerconfirmpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
  
    Future saveUserInfotoFirestore(User fuser) async {
      FirebaseFirestore.instance.collection("admins").doc(fuser.uid).set({
        "id": fuser.uid,
        "email": fuser.email,
        EcommercApp.userPhotoUrl: "",
        EcommercApp.usercartList: [""],
        "name": _controllername.value.text.trim(),
        "phone": _controllerphone.value.text.trim(),
      });
      //  await EcommercApp.preferences!.setString(EcommercApp.isuser, "2");

      await EcommercApp.preferences!.setString(EcommercApp.userUID, fuser.uid);
      await EcommercApp.preferences!
          .setString(EcommercApp.userphone, _controllerphone.value.text.trim());

      await EcommercApp.preferences!
          .setString(EcommercApp.userEmail, fuser.email!);
      await EcommercApp.preferences!
          .setString(EcommercApp.userName, _controllername.text.trim());
      await EcommercApp.preferences!.setString(EcommercApp.userPhotoUrl, "");

      await EcommercApp.preferences!
          .setStringList(EcommercApp.usercartList, ["garbageValue"]);
      await EcommercApp.preferences!
          .setStringList(EcommercApp.usercartList, [""]);
    }

    Future<void> _registeruser() async {
      String email = _controlleremail.value.text.trim();
      String password = _controllerpassword.value.text.trim();
      String confirmpassword = _controllerconfirmpassword.text.trim();

      if (password != confirmpassword) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Password Mismatch")));
        setState(() {
          errortext = "Password Mismatch!";
          isloading =false;
        });
        //tell the user to please enter the correct passwrods, passwords that are same

      } else {
        setState(() {
          isloading =true;
          errortext = "";
        });
        User? user;
        try {
          await _auth
              .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
              .then((auth) {
            user = _auth.currentUser!;
          });
          //user = _auth.currentUser;
        } on FirebaseAuthException catch (error) {
          setState(() {
            isloading = false;
            errortext = error.message!;
          });
          errortext = error.message!;
        }
        //

        if (user != null) {
          saveUserInfotoFirestore(user!).then((value) {
            isloading =false;
            //  Navigator.pop(context);

            Nav.route(context, VerifyScreeen(
                      screen: 1,
                      phoneNumber: _controllerphone.text.trim(),
                    ));
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: FractionalOffset(0, 0),
              end: FractionalOffset(1, 0),
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text("Seller Register Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formk,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Welcome",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Divider(
                      thickness: 4,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      "Register Seller account",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  errortext != ""
                      ? Padding(
                          padding:
                              const EdgeInsets.only(left: 20, bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  errortext,
                                  style: TextStyle(
                                      color: Theme.of(context).errorColor),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                  EditText(
                    title: "Name",
                    textEditingController: _controllername,
                  ),
                  EditText(
                    formvalidator: validatephone,
                    inputType: TextInputType.number,
                    title: "phone",
                    textEditingController: _controllerphone,
                  ),
                  EditText(
                    formvalidator: validateemail,
                    title: "Email",
                    inputType: TextInputType.emailAddress,
                    textEditingController: _controlleremail,
                  ),
                  EditText(
                    title: "Password",
                    formvalidator: validatepassword,
                    isPassword: true,
                    textEditingController: _controllerpassword,
                  ),
                  EditText(
                    title: "Confirm Password",
                    isPassword: true,
                    textEditingController: _controllerconfirmpassword,
                  ),
               isloading?CustomLoadingWidget(text: "Registering Seller"):      SubmitButton(
                    title: "Seller Register",
                    act: () async {
                      await Connectivity().checkConnectivity();
                      if (formk.currentState!.validate())
                      setState(() {
                        isloading =false;
                      });
                        try {
                          await _registeruser();
                          setState(() {
                            isloading =false;
                          });
                        } catch (e) {
                          setState(() {
                            isloading =false;
                          });
                          print(e.toString());
                        }
                    },
                  ),
                  const SizedBox(
                    height: 60,
                    child: Divider(
                      thickness: 4,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have a Seller account? ",
                          style: TextStyle(fontSize: customfont(context, 17)),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Connectivity().checkConnectivity();

                           Nav.route(context, AdminLoginScreen());
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: customfont(context, 17)),
                          ),
                        ),
                      ],
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

  // }
}
