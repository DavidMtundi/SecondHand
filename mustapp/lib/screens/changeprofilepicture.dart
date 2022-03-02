import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class changeprofilepic extends StatefulWidget {
  const changeprofilepic({Key? key}) : super(key: key);

  @override
  State<changeprofilepic> createState() => _changeprofilepicState();
}

class _changeprofilepicState extends State<changeprofilepic> {
  @override
  Widget build(BuildContext context) {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _imagefile; //= XFile("/root");
    //function to pick an image and add it to the cart
    String imageFileName = "";

    String productimageurl = "";

    void requestpermissions() async {
      //final Perm _permission = PermissionHandler();
      //check if the camera ad the gallery are given permission
      //var status = await Permission.camera;
      // Map<Permission, PermissionStatus> status =
      await [Permission.storage, Permission.camera].request();
    }

    Future<void> _selectandpickImage() async {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        requestpermissions();
      } else {
        XFile fileselected =
            (await _imagePicker.pickImage(source: ImageSource.gallery))!;

        setState(() {
          _imagefile = fileselected;
        });
      }
    }

    Future<void> _selectandtakepicture() async {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        requestpermissions();
      } else {
        XFile fileselected =
            (await _imagePicker.pickImage(source: ImageSource.camera))!;

        setState(() {
          _imagefile = fileselected;
        });
      }
    }

    Future<void> _uploadandSaveimage() async {
      // requestpermissions();

      if (_imagefile == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Unable to pick the File please Try again")));
      } else {
        //get a very unique string
        imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
        //push it to the firebase storage and save it there

        FirebaseStorage storage = FirebaseStorage.instance;

        Reference storagereference = storage.ref().child(imageFileName);
        //File file = File(_imagefile.path)
        UploadTask uploadTask =
            storagereference.putFile(File(_imagefile!.path));
//var downloadurl = await(await uploadTask.)
        await (await uploadTask).ref.getDownloadURL().then((url) {
          setState(() {
            productimageurl = url;
            print(url.toString());
          });
          return url;
        });
      }
    }

    //final
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Change the account Picture",
            style: TextStyle(
                fontSize: 18, color: Colors.black87, letterSpacing: -1.2),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 70,
            ),
            CircleAvatar(
              backgroundColor: Colors.black12,
              //   backgroundImage: ,
              child: _imagefile != null
                  ? ClipOval(
                      child: Image.file(
                        File(_imagefile!.path),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Center(
                      child:
                          Icon(Icons.camera_alt_rounded, color: Colors.black12),
                    ),
              radius: 110,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      _selectandpickImage();
                    },
                    child: const Text(
                      "Choose Picture from Gallery",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      _selectandtakepicture();
                    },
                    child: const Text(
                      "Pick Picture From Camera",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Remove Picture",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
