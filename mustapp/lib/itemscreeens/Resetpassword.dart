import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'package:mustapp/Authentication/authenticationservice.dart';
import 'package:mustapp/screens/register.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/progressdialog.dart';
import 'package:mustapp/widgets/edittext.dart';
import 'package:mustapp/widgets/submitbutton.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ResetPassword> {
  String errortext = "";
  bool isloading =false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController _controllerusername = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String buttontext = "Reset Password";
  final TextEditingController _controllerpassword = TextEditingController();
  // final AuthentificationService _authservice = AuthentificationService();
  @override
  Widget build(BuildContext context) {
    final progressDialog = ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage('Resetting ...');
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
        title: const Text("Reset Password Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text("Welcome", style: Theme.of(context).textTheme.headline5),
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
                child: Text("Reset Email Password",
                    style: customfont(context, 14) > 13
                        ? Theme.of(context).textTheme.subtitle1
                        : Theme.of(context).textTheme.subtitle2),
              ),
              errortext != ""
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.red,
                          ),
                          Flexible(
                            child: Text(errortext,
                                style: TextStyle(
                                    color: Theme.of(context).errorColor)),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              Form(
                key: _formkey,
                child: EditText(
                  title: "Enter your Email",
                  formvalidator: validateemail,
                  inputType: TextInputType.emailAddress,
                  textEditingController: _controllerusername,
                ),
              ),
                   isloading? CustomLoadingWidget(text: 'Sending Password Reset Email Link',):  SubmitButton(
                title: buttontext,
                act: () async {
                //  progressDialog.show();
                  if (_formkey.currentState!.validate()) {
                    try {
                      setState(() {
                        errortext = "";
                        isloading = true;
                      });
                      await _auth
                          .sendPasswordResetEmail(
                              email: _controllerusername.value.text.trim())
                          .then((value) {
                        Fluttertoast.showToast(
                            msg:
                                "PassWord Reset Request Sent to your Email Address");
                        progressDialog.hide();
                        Navigator.pop(context);
                      });
                    } on FirebaseException catch (e) {
                      setState(() {
                        progressDialog.hide();
                        isloading=false;
                        errortext = e.message.toString();
                      });
                    }
                  }
                },
              ),
              Column(
                children: [
                  SizedBox(
                    height: CustomHeight(context, 30),
                  ),
                  SizedBox(
                    height: CustomHeight(context, 60),
                    child: Divider(
                      thickness: 4,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({
    Key? key,
     this.text="...",
    this.isitem =false
  }) : super(key: key);
 final String text;
 final bool isitem;

  @override
  Widget build(BuildContext context) {
    return isitem?Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.black87,strokeWidth: 2,semanticsLabel: "Please Wait",),
       //const SizedBox(width: 24,),
       Flexible(child: Text("$text,",style: TextStyle(fontSize: 12),)),
        ],
      ): Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.black87,semanticsLabel: "Please Wait",),
       const SizedBox(width: 24,),
       Flexible(child: Text("$text, Please Wait")),
        ],
      ),
    );
  }
}
