import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/itemscreeens/Resetpassword.dart';
import 'package:mustapp/screens/home.dart';
import 'package:mustapp/screens/login.dart';
import 'package:mustapp/widgets/edittext.dart';
import 'package:mustapp/widgets/submitbutton.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String errortext = "";
  bool isloading = false;

    final FirebaseAuth _auth = FirebaseAuth.instance;
    TextEditingController _controllername = TextEditingController();
    TextEditingController _controllerphone = TextEditingController();

    TextEditingController _controlleremail = TextEditingController();

    TextEditingController _controllerpassword = TextEditingController();

    TextEditingController _controllerconfirmpassword = TextEditingController();
  @override
  Widget build(BuildContext context) {

  
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    Future saveUserInfotoFirestore(User fuser) async {
      FirebaseFirestore.instance.collection("users").doc(fuser.uid).set({
        "uid": fuser.uid,
        "email": fuser.email,
        EcommercApp.userPhotoUrl: "",
        EcommercApp.usercartList: [""],
        EcommercApp.userphone: _controllerphone.value.text.trim(),
        "name": _controllername.value.text.trim(),
      });
      await EcommercApp.preferences!.setString(EcommercApp.userUID, fuser.uid);
      //  await EcommercApp.preferences!.setString(EcommercApp.isuser, "1");

      await EcommercApp.preferences!
          .setString(EcommercApp.userEmail, fuser.email!);
      await EcommercApp.preferences!
          .setString(EcommercApp.userName, _controllername.text.trim());
      await EcommercApp.preferences!.setString(EcommercApp.userPhotoUrl, "");
      await EcommercApp.preferences!
          .setString(EcommercApp.userphone, _controllerphone.value.text.trim());
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
          isloading=false;
          errortext = "Password Mismatch!";
        });
        //tell the user to please enter the correct passwrods, passwords that are same

      } else {
        setState(() {
          isloading = true;
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
          setState(() {
                      isloading = false;

          });
          saveUserInfotoFirestore(user!).then((value) {
            Navigator.pop(context);
            Route route = MaterialPageRoute(builder: (c) => Home());
            Navigator.pushReplacement(context, route);
            // Route route = MaterialPageRoute(
            //     builder: (_) => VerifyScreeen(
            //           screen: 2,
            //           phoneNumber: _controllerphone.text.trim(),
            //         ));
            //Navigator.pushReplacement(context, route);
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
        title: const Text("User Register Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
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
                  const SizedBox(
                    height: 40,
                    child: Divider(
                      thickness: 4,
                      color: Colors.greenAccent,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      "Register account",
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
                              const SizedBox(
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
                    title: "User Name",
                    textEditingController: _controllername,
                  ),
                  EditText(
                    inputType: TextInputType.number,
                    title: "phone",
                    formvalidator: validatephone,
                    textEditingController: _controllerphone,
                  ),
                  EditText(
                    title: "Email",
                    inputType: TextInputType.emailAddress,
                    textEditingController: _controlleremail,
                    formvalidator: validateemail,
                  ),
                  EditText(
                    title: "Password",
                    isPassword: true,
                    formvalidator: validatepassword,
                    textEditingController: _controllerpassword,
                  ),
                  EditText(
                    title: "Confirm Password",
                    isPassword: true,
                    textEditingController: _controllerconfirmpassword,
                  ),
                isloading? CustomLoadingWidget(text: "Registering"):  SubmitButton(
                    title: "Register as User",
                    act: () async {
                      await Connectivity().checkConnectivity();

                      // await _registeruser();
                      if (_formkey.currentState!.validate()) {
                        try {
                          setState(() {
                            isloading = true;
                          });
                          await _registeruser();
                          setState(() {
                            isloading = false;
                          });
                        } catch (e) {
                          setState(() {
                            isloading = false;
                          });
                          print(e.toString());
                        }
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
              isloading?SizedBox.shrink():    Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 17),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17),
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

String? validateemail(String? email) {
  if ((email == null) || (email == "")) return "E-mail Address is required";
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  if (!emailValid) return "Invalid email Format";

  return null;
}

String? validatepassword(String? password) {
  if ((password == null) || (password == "")) return "Password is required";

  if (password.length < 6) return "Password Length Must be >6";

  return null;
}

String? validatephone(String? phone) {
  if ((phone == null) || (phone == "")) return "Phone is required";

  if (phone.length < 10) return "Phone Length Must be >9";

  return null;
}
