
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mustapp/itemscreeens/Resetpassword.dart';
import 'package:mustapp/screens/adminlogin.dart';
//import 'package:mustapp/Authentication/authenticationservice.dart';
import 'package:mustapp/screens/register.dart';
import 'package:mustapp/services/auth.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/navigator.dart';
import 'package:mustapp/utils/util.dart';
import 'package:mustapp/widgets/edittext.dart';
import 'package:mustapp/widgets/submitbutton.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isloading = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController _controllerusername = TextEditingController();
  AuthService authService = AuthService();

  final TextEditingController _controllerpassword = TextEditingController();

  // final AuthentificationService _authservice = AuthentificationService();
  @override
  Widget build(BuildContext context) {
   



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
        title: Text("Login Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Text("Welcome ....",
                    style: customfont(context, 14) > 13
                        ? Theme.of(context).textTheme.headline5
                        : Theme.of(context).textTheme.headline6),
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
                  child: Text("Login to your account",
                      style: customfont(context, 14) > 13
                          ? Theme.of(context).textTheme.subtitle1
                          : Theme.of(context).textTheme.subtitle2),
                ),
                authService.errortext != ""
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
                                authService.errortext,
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
                      title: "Email",
                      inputType: TextInputType.emailAddress,
                      formvalidator: validateemail,
                      textEditingController: _controllerusername,
                    ),
                    EditText(
                      title: "Password",
                      isPassword: true,
                      textEditingController: _controllerpassword,
                    ),
                  ],
                ),
              isloading? CustomLoadingWidget(text: "Validating User"):  SubmitButton(
                  title: "Login",
                  act: () async {
                  
                    await Connectivity().checkConnectivity();

                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        isloading =true;
                      });
                   
                      try {
                                              await authService.allowLogin(context,_controllerusername.value.text.trim(),_controllerpassword.value.text.trim());

setState(() {
                      isloading=false;

});
                      } catch (e) {
                       setState(() {
                          isloading =false;
                       });
                 
                      }
  setState(() {
                          isloading =false;
                       });                     
                      // ignore: await_only_futures
                    }
                  },
                ),
             isloading?SizedBox.shrink():   Padding(
                  padding: EdgeInsets.all(CustomWidth(context, 32)),
                  child: InkWell(
                      onTap: () async {
                        var result = await Connectivity().checkConnectivity();
                        if (result == ConnectivityResult.none) {
                          await showconnectivitysnackbar(context, result);
                        }
                        Nav.route(context,  ResetPassword());
                      },
                      child: Text("Forgot your password?",
                          style: customfont(context, 14) > 13
                              ? Theme.of(context).textTheme.subtitle2
                              : TextStyle(
                                  fontSize: 12,
                                ))),
                ),
              isloading?SizedBox.shrink():    Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account?  ",
                      style: customfont(context, 14) > 13
                          ? Theme.of(context).textTheme.subtitle2
                          : TextStyle(fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () async {
                        var result = await Connectivity().checkConnectivity();
                        if (result == ConnectivityResult.none) {
                          await showconnectivitysnackbar(context, result);
                        }
                      Nav.route(context, RegisterScreen());
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
          isloading?SizedBox.shrink():        const Center(
                  child: Text("Or"),
                ),
          isloading?SizedBox.shrink():        SizedBox(
                  height: CustomHeight(context, 60),
                  child: Divider(
                    thickness: CustomHeight(context, 4),
                    color: Colors.greenAccent,
                  ),
                ),
         isloading?SizedBox.shrink():         SubmitButton(
                  title: "i am Seller?",
                  colorprovided: Colors.green,
                  act: () async {
                    await Connectivity().checkConnectivity();

                    Nav.route(context, AdminLoginScreen());
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateForm() {
    bool isvalid = false;
    isvalid = _controllerusername.text.isNotEmpty &&
        _controllerpassword.text.isNotEmpty;
    return isvalid;
  }
}
  