import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mustapp/utils/navigator.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sighn in anonymously
  Future signinAnon() async {
    try {
      // AuthResult result = await _auth.signInAnonymously();
      // FirebaseUser user = result.user;
      // return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  //phone number authentication related thing

  Future<void> verifyPhoneNumber(
      BuildContext context, String phoneNumber, Function setData) async {
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    // ignore: prefer_function_declarations_over_variables
    PhoneVerificationFailed verificationFailed = (Exception exception) {
      showSnackBar(context, exception.toString());
    };
    // ignore: prefer_function_declarations_over_variables
    void Function(String verificationId, [int? foreceResendingToken]) codeSent =
        (String verificationId, [int? forceResendingToken]) {
      showSnackBar(context, "verification code sent on the phone number");
      setData(verificationId);
    };
    // ignore: prefer_function_declarations_over_variables
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      showSnackBar(context, "timeout");
    };
    //try {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    //} catch (e) {
    //  showSnackBar(context, e.toString());
    //}
  }

  Future signinEmailPass(String email, String password) async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> signinwithphoneNumber(String countrycode, String phone,
      String verificationId, String smscode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smscode);
      UserCredential user = await _auth.signInWithCredential(credential);
      // setState(() {
      // pr.hide();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        //     );
        //}
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Validating the User");
    }
  }
  late User firebaseuser;

  Future readData(User firebaseuser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseuser.uid)
        .get()
        .then((datasnapshot) async {
      await EcommercApp.preferences!.setString(
          EcommercApp.userphone, datasnapshot.data()![EcommercApp.userphone]);
      await EcommercApp.preferences!.setString(
          EcommercApp.userUID, datasnapshot.data()![EcommercApp.userUID]);
      await EcommercApp.preferences!.setString(
          EcommercApp.userEmail, datasnapshot.data()![EcommercApp.userEmail]);
      await EcommercApp.preferences!.setString(
          EcommercApp.userName, datasnapshot.data()![EcommercApp.userName]);

      List<String> cartList =
          await datasnapshot.data()![EcommercApp.usercartList].cast<String>();
      await datasnapshot.data()![EcommercApp.usercartList] != null
          ? await EcommercApp.preferences!
              .setStringList(EcommercApp.usercartList, cartList)
          : await EcommercApp.preferences!
              .setStringList(EcommercApp.usercartList, []);
    });
  }

String errortext="";
 Future<void> anonymousLogin(BuildContext context) async {
      try {
        await _auth
            .signInAnonymously(
               )
            .then((authUser) {
          firebaseuser  = authUser.user!;
          readData(firebaseuser).then((value) {
            Nav.route(context, Home());
          }).catchError((error) {
        
               errortext = error.message!;
            
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Incorrect Credentials")));
          });
        }).catchError((error) {
          
            errortext = error.message!;
        
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("NetWork Error, Please Check Your Network")));
        });
      } on FirebaseAuthException catch (e) {
        //progressDialog.hide();

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Incorrect Credentials")));
      }
    }
  //sign in with email and password

    Future<void> allowLogin(BuildContext context,String email,String password) async {
      try {
        await _auth
            .signInWithEmailAndPassword(
                email: email,
                password: password)
            .then((authUser) {
          firebaseuser = authUser.user!;
          readData(firebaseuser).then((value) {
            Route route = MaterialPageRoute(builder: (context) => Home());

            Navigator.pushReplacement(context, route);
          }).catchError((error) {
         
              errortext = error.message!;
          
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Incorrect Credentials")));
          });
        }).catchError((error) {
         
            errortext = error.message!;
       
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Incorrect Credentials")));
        });
      } on FirebaseAuthException catch (e) {

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Incorrect Credentials")));
      }
    }

}
