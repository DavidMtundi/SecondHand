import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/itemscreeens/Resetpassword.dart';
import 'package:mustapp/pages/uploadpage.dart';
import 'package:mustapp/screens/adminregister.dart';
import 'package:mustapp/screens/login.dart';
import 'package:mustapp/screens/register.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/navigator.dart';
//import 'package:mustapp/Authentication/authenticationservice.dart';
import 'package:mustapp/utils/util.dart';
import 'package:mustapp/widgets/edittext.dart';
import 'package:mustapp/widgets/submitbutton.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isloading = false;

  final TextEditingController _controllerusername = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controllerpassword = TextEditingController();
  // final AuthentificationService _authservice = AuthentificationService();
  bool emailvalid = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String errortext = "";

  Future readAdminData(User firebaseuser) async {
    FirebaseFirestore.instance
        .collection("admins")
        .doc(firebaseuser.uid)
        .get()
        .then((datasnapshot) async {
      // await EcommercApp.preferences!.setString(EcommercApp.isuser, '2');
//print()
      await EcommercApp.preferences!.setString(
          EcommercApp.userUID, datasnapshot.data()!["id"]);
          print("The ecommerceapp saved is ${EcommercApp.preferences!.getString(EcommercApp.userUID)}");
      await EcommercApp.preferences!.setString(
          EcommercApp.userphone, datasnapshot.data()![EcommercApp.userphone]);
      await EcommercApp.preferences!.setString(
          EcommercApp.userEmail, datasnapshot.data()![EcommercApp.userEmail]);
      await EcommercApp.preferences!.setString(
          EcommercApp.userName, datasnapshot.data()![EcommercApp.userName]);

      List<String> cartList =
          datasnapshot.data()![EcommercApp.usercartList].cast<String>();
      await EcommercApp.preferences!
          .setStringList(EcommercApp.usercartList, cartList);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    late User user;
    Future<bool> validateAdmin(String userid, String checkemail) async {
      try {
        // Get reference to Firestore collection
        var collectionRef = FirebaseFirestore.instance.collection('admins');

        var doc = await collectionRef.doc(userid).get();
        emailvalid = doc.exists;
        return doc.exists;
      } catch (e) {
        emailvalid = false;
        setState(() {
          isloading = false;
          errortext =
              "Incorrect username and Password, if the problem persists, try logging in as a user";
        });
        // throw e;
        return false;
      }
    }

    Future<void> allowadminlogin(String email, String password) async {
      try {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((authUser) {
          user = authUser.user!;
        }).then((value) =>
                validateAdmin(user.uid, _controllerusername.value.text.trim()));
      } on FirebaseAuthException catch (error) {
        setState(() {
          isloading = false;
          errortext = error.message!;
        });
        errortext = error.message!;
      }

      if (emailvalid) {
        readAdminData(user).then((value) {
          isloading = false;
          Nav.route(context, Uploadpage());
        });
      } else {
        setState(() {
          isloading =false;
          errortext = "if the problem Persists, try logging in as user";
        });
        errortext = "if the problem Persists, try logging in as user";
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
        title: Text("Seller Login Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(children: <Widget>[
              Text("Welcome Dear Seller",
                  style: Theme.of(context).textTheme.headline5),
              SizedBox(
                height: CustomHeight(context, 60),
                child: Divider(
                  thickness: 4,
                  color: Colors.greenAccent,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: CustomHeight(context, 16)),
                child: Text(" Login to your account",
                    style: customfont(context, 14) > 13
                        ? Theme.of(context).textTheme.subtitle1
                        : Theme.of(context).textTheme.subtitle2),
              ),
              errortext != ""
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: CustomWidth(context, 10),
                          bottom: CustomHeight(context, 20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: CustomWidth(context, 10),
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
              Column(
                children: [
                  EditText(
                    title: "email address",
                    formvalidator: validateemail,
                    inputType: TextInputType.emailAddress,
                    textEditingController: _controllerusername,
                  ),
                  EditText(
                    title: "Password",
                    isPassword: true,
                    textEditingController: _controllerpassword,
                  ),
                ],
              ),
         isloading?CustomLoadingWidget(text: "Authenticating Seller"):      SubmitButton(
                title: "Seller Login",
                act: () async {
                  await Connectivity().checkConnectivity();

                  setState(() {
                    errortext = "";
                  });
                  if (_formkey.currentState!.validate()) {
setState(() {
  isloading =true;
});                    //check to find if the user is in the database and log in
                    // ignore: await_only_futures
                    await allowadminlogin(_controllerusername.value.text.trim(),
                        _controllerpassword.value.text.trim());
                  setState(() {
                    isloading = false;
                  });
                  }
                },
              ),
        isloading?SizedBox.shrink():      Padding(
                padding: EdgeInsets.all(CustomWidth(context, 32)),
                child: InkWell(
                    onTap: () async {
                      var result = await Connectivity().checkConnectivity();
                      if (result == ConnectivityResult.none) {
                        await showconnectivitysnackbar(context, result);
                      }
                       Nav.route(context, ResetPassword());
                    },
                    child: Text("Forgot your password?")),
              ),
        isloading?SizedBox.shrink():         Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Don't have an account?  ",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var result = await Connectivity().checkConnectivity();
                      if (result == ConnectivityResult.none) {
                        await showconnectivitysnackbar(context, result);
                      }
                     Nav.route(context, AdminRegisterscreen());
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: customfont(context, 17)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: CustomHeight(context, 30),
              ),
       isloading?SizedBox.shrink():          const Center(
                child: Text("Or"),
              ),
              SizedBox(
                height: CustomHeight(context, 60),
                child: Divider(
                  thickness: 4,
                  color: Colors.greenAccent,
                ),
              ),
        isloading?SizedBox.shrink():         SubmitButton(
                title: "I am a Buyer?",
                colorprovided: Colors.green,
                act: () async {
                  await Connectivity().checkConnectivity();

                   Nav.route(context, LoginScreen());
                },
              )
            ]),
          ),
        ),
      ),
    );
  }
}
