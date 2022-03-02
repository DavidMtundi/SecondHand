import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mustapp/screens/addnewproduct.dart';
import 'package:mustapp/screens/adminlogin.dart';
import 'package:mustapp/screens/home.dart';

import 'package:mustapp/screens/otherhome.dart';

class Uploadpage extends StatefulWidget {
  Uploadpage({Key? key}) : super(key: key);

  @override
  _UploadpageState createState() => _UploadpageState();
}

class _UploadpageState extends State<Uploadpage> {
  bool get wantKeepAlive => true;
  File? file;
  @override
  Widget build(BuildContext context) {
    return //file == null
        //  ?
        displayAdminHomeScreen();
    //  : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
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
        leading: IconButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => Home());
              Navigator.pushReplacement(context, route);
            },
            icon: const Icon(
              Icons.border_color,
              color: Colors.white,
            )),
        actions: [
          TextButton(
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (C) => AdminLoginScreen());
              Navigator.pushReplacement(context, route);
            },
            child: const Text(
              "Log Out",
              style: TextStyle(
                  color: Colors.pink,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink, Colors.lightGreenAccent],
          begin: FractionalOffset(0, 0),
          end: FractionalOffset(1, 0),
          stops: [0, 1],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shop_two,
                color: Colors.white,
                size: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(const Radius.circular(30))),
                  child: TextButton(
                    onPressed: () {
                      // takeImage(context);
                      Route route = MaterialPageRoute(
                          builder: (context) => const Addnewproductpage());
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      "Add New Items",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: TextButton(
                    onPressed: () {
                      Route route = MaterialPageRoute(
                          builder: (context) => const OtherHome());
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      "View All My Products",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  takeImage(context) {
    showDialog(
        context: context,
        builder: (con) {
          return const SimpleDialog(
            title: const Text(
              "Item Image",
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          );
        });
  }
}
