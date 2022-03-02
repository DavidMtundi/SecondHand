import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mustapp/screens/home.dart';
import 'package:mustapp/screens/login.dart';
import 'package:mustapp/services/auth.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/navigator.dart';
import 'package:mustapp/utils/progressdialog.dart';
class defaultscreen extends StatefulWidget{
  @override
  State<defaultscreen> createState() => _defaultscreenState();
}

class _defaultscreenState extends State<defaultscreen> {
    String errortext = "";
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final progressDialog = ProgressDialog(context, ProgressDialogType.Normal);
//isloading =false;
    progressDialog.setMessage('Logging in...');
    FirebaseAuth _auth = FirebaseAuth.instance;
AuthService authService = AuthService();

   

    return Scaffold(

body: Container(
  color: Colors.white10,
child: Column(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Container(height: CustomHeight(context, 300),child: Image.asset("assets/images/admin.png",fit: BoxFit.fitHeight,),),
    GestureDetector(
      onTap: ()async{
        setState(() {
           isloading = !isloading;
         });
      await  authService.anonymousLogin(context);
       setState(() {
           isloading = !isloading;
         });
//create a loading widget while the anonymous login is running
      },
      child:isloading?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.black87,semanticsLabel: "Please Wait",),
       const SizedBox(width: 24,),
       Text("Please Wait"),
        ],
      )
      
      : Container(
       // color: Colors.redAccent,
        decoration: BoxDecoration(color: Colors.red[300],borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 20,),
            Flexible(child: Text("Continue Without Register/Login (Limited Features)",style: TextStyle(fontSize: 16,color: Colors.black87,fontWeight: FontWeight.bold),),),
           // Spacer(),
            IconButton(onPressed: ()async{
           
            }, icon: Icon(Icons.navigate_next),iconSize: 40,),
          ],
        ),
      ),
    ),
    SizedBox(height: CustomHeight(context, 20),child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Or"),
      ],
    ),),


     GestureDetector(
       onTap: (){
        setState(() {
                        isloading = false;

            });

         Nav.route(context, LoginScreen());
         
  
       },
       child:  Container(
                 decoration: BoxDecoration(color: Colors.red[300],borderRadius: BorderRadius.circular(20)),

         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 20,),
            Flexible(child: Text(
              "Already have account  / Create a new Account (Get Access to all Features)",style: TextStyle(fontSize: 16,color: isloading?Colors.white12: Colors.black87,fontWeight: FontWeight.bold),)),
           // Spacer(),
            IconButton(onPressed: (){
            
            }, icon: Icon(Icons.skip_next_sharp),color: isloading?Colors.white12:Colors.black87,iconSize: 40,),
          ],
           ),
       ),
     )
  ],
),
),

    );
  }
}