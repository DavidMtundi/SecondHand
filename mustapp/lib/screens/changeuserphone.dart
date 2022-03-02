import 'package:flutter/material.dart';
import 'package:mustapp/widgets/edittext.dart';
import 'package:mustapp/widgets/submitbutton.dart';

class Changeuserdetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controllersurname = TextEditingController();

    TextEditingController _controlleremail = TextEditingController();

    TextEditingController _controllerpassword = TextEditingController();

    TextEditingController _controllername = TextEditingController();
    return Scaffold(    
      appBar: AppBar(
        title: Text(
          "Edit Account Details",
          style: TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Text(
                    "Edit account details",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                EditText(
                  title: "Name",
                  textEditingController: _controllername,
                ),
                EditText(
                  title: "Surname",
                  textEditingController: _controllersurname,
                ),
                EditText(
                  title: "Email",
                  textEditingController: _controlleremail,
                ),
                EditText(
                  title: "Password",
                  textEditingController: _controllerpassword,
                ),
                SubmitButton(
                  title: "Update Details",
                  act: () {
             
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
