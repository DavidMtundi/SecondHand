// ignore_for_file: unnecessary_const

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/pages/uploadpage.dart';
import 'package:mustapp/utils/navigator.dart';

import 'package:mustapp/utils/progressdialog.dart';
import 'package:mustapp/widgets/edittext.dart';
import 'package:mustapp/widgets/submitbutton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class editproduct extends StatefulWidget {
  editproduct({Key? key, required this.model}) : super(key: key);
  Productmodel model;

  @override
  State<editproduct> createState() => _AddnewproductpageState();
}

class _AddnewproductpageState extends State<editproduct> {
  String selectedvalue = "Electronics";

  bool isClicked = false;
  final TextEditingController _controllertitle = TextEditingController();

  final TextEditingController _controllervariant = TextEditingController();
  final TextEditingController _controllerstock = TextEditingController();

  final TextEditingController _controllercolors = TextEditingController();
  final TextEditingController _controlleroriginalprice =
      TextEditingController();

  final TextEditingController _controllerdiscountprice =
      TextEditingController();
  final TextEditingController _controllersellername = TextEditingController();

  final TextEditingController _controllerdescription = TextEditingController();

  final TextEditingController _controllerhiglights = TextEditingController();

  final TextEditingController _controllersearchtag = TextEditingController();
  String sellerphone =
      EcommercApp.preferences!.getString(EcommercApp.userphone).toString();
  String sellerid =
      EcommercApp.preferences!.getString(EcommercApp.userUID).toString();
  String username =
      EcommercApp.preferences!.getString(EcommercApp.userName).toString();
  String Productid = DateTime.now().millisecondsSinceEpoch.toString();
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

  Future<void> _selectandtakevideo() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      requestpermissions();
    } else {
      XFile selectedfile =
          (await _imagePicker.pickVideo(source: ImageSource.camera))!;

      setState(() {
        _imagefile = selectedfile;
      });
    }
  }

  Future<void> _selectandpickvideo() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      requestpermissions();
    } else {
      setState(() async {
        _imagefile =
            (await _imagePicker.pickVideo(source: ImageSource.gallery))!;
      });
    }
  }

  Future<String> uploadImageandSaveItemInfo() async {
    late XFile image; //= _imagefile!;
    if (_imagefile != null) {
      image = _imagefile!;
    }
    productimageurl = await _uploadandSaveimage(File(image.path));
    //  setState(() {
    //    productimageurl = productimageurl;
    //  productimageurl = imageDownloadurl;
    //  });
    print("the image download url is  $productimageurl");
    return productimageurl;
  }

  Future<String> _uploadandSaveimage(mFileImage) async {
    // requestpermissions();
    String downloadurlvalue = "";
    var downloadurl = "";
    if (_imagefile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: const Text("Unable to pick the File please Try again")));
    } else {
      imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

      final Reference storagereference =
          FirebaseStorage.instance.ref().child("items");

      UploadTask uploadTask =
          storagereference.child("product_$Productid.jpg").putFile(mFileImage);

      downloadurlvalue = await (await uploadTask).ref.getDownloadURL();
    }
    return downloadurlvalue;
  }

  Future<void> pickmultipleimages() async {
    await _imagePicker.pickMultiImage();
  }

  @override
  Widget build(BuildContext context) {
    //final ProgressDialog progressDialog = ProgressDialog(context,ProgressDialogType.Download);
    final progressDialog = ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage('updating product....');
    _controllercolors.text = widget.model.colors;
    _controllerdiscountprice.text = widget.model.discountprice;
    _controlleroriginalprice.text = widget.model.price;
    _controllerhiglights.text = widget.model.highlights;
    _controllersearchtag.text = widget.model.searchtag;
    _controllersellername.text = widget.model.seller;
    _controllertitle.text = widget.model.title;
    _controllerstock.text = widget.model.stock.toString();
    _controllervariant.text = widget.model.variant;
    selectedvalue = widget.model.category;
    FirebaseStorage.instance.refFromURL(widget.model.imageurl).delete();

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
        title: Text("Add Items Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Text(
                  "Fill Product Details",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              ExpansionTile(
                title: const Text("Basic Details",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
                leading: const Icon(
                  Icons.details_sharp,
                  color: Colors.redAccent,
                ),
                children: [
                  EditText(
                    title: "Product title eg. Sufuria",
                    textEditingController: _controllertitle,
                  ),
                  EditText(
                    title: "Variant eg. Green",
                    textEditingController: _controllervariant,
                  ),
                  EditText(
                    title: "Original Price in Kshs. eg. 1000",
                    textEditingController: _controlleroriginalprice,
                    inputType: TextInputType.number,
                  ),
                  EditText(
                    title: "Discount Price in Kshs. eg. 200",
                    textEditingController: _controllerdiscountprice,
                    inputType: TextInputType.number,
                  ),
                  // EditText(
                  //   title: "Seller eg. High End Sellers",
                  //   textEditingController: _controllersellername,
                  // ),
                  EditText(
                    title: "Stock i.e(total items) i.e 8",
                    textEditingController: _controllerstock,
                    inputType: TextInputType.number,
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text(
                  "Describe Product",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                leading: const Icon(
                  Icons.document_scanner_outlined,
                  color: Colors.redAccent,
                ),
                children: [
                  EditText(
                    title: "Highlights eg. Aluminium Type",
                    textEditingController: _controllerhiglights,
                  ),
                  EditText(
                    title:
                        "Description eg. This is a new Sufuria used for less 2 months",
                    textEditingController: _controllerdescription,
                  ),
                  EditText(
                    title: "Colors eg. silver,black",
                    textEditingController: _controllercolors,
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text(
                  "Upload Images",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                leading: const Icon(
                  Icons.photo_album,
                  color: Colors.redAccent,
                ),
                children: [
                  _imagefile != null
                      ? SizedBox(
                          // child: const Spacer(),
                          // ignore: unnecessary_null_comparison
                          child: Image.file(
                          File(_imagefile!.path),
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                          // const SizedBox.shrink();
                          )
                      : const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () async {
                          // _uploadandSaveimage();
                          await _selectandtakepicture();
                        },
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          // _uploadandSaveimage();
                          await _selectandpickImage();
                        },
                        child: const Icon(
                          Icons.sd_storage,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Choose the Product Type(Category)",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButton(
                      //style: TextStyle(fontSize: 13),
                      items: dropdownItems,
                      onChanged: onchanged,
                      value: selectedvalue)
                ],
              ),
              ExpansionTile(
                title: const Text(
                  "Search Tags",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                leading: const Icon(
                  Icons.airplane_ticket_rounded,
                  color: Colors.redAccent,
                ),
                children: [
                  const Text(
                    "Your product will be searched by this words",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  EditText(
                    title: "Search tag eg. Sufuria,utensils,kitchen",
                    textEditingController: _controllersearchtag,
                  ),
                ],
              ),
              const SizedBox(
                height: 60,
                child: Divider(
                  thickness: 4,
                  color: Colors.greenAccent,
                ),
              ),
              //EditText(title: "Password"),
              SubmitButton(
                title: "Update Product",
                act: () async {
                  if (_imagefile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: const Text(
                            "Please pick the File please Try again")));
                  } else {
                    progressDialog.show();
                    // uploadImageandSaveItemInfo();
                    await saveproduct(
                        sellerphone,
                        await uploadImageandSaveItemInfo(),
                        // productimageurl,

                        selectedvalue,
                        _controllercolors.value.text.trim().toString(),
                        _controllerdescription.value.text.trim().toString(),
                        _controllerdiscountprice.value.text.trim().toString(),
                        _controllerhiglights.value.text.trim().toString(),
                        _controlleroriginalprice.value.text.trim().toString(),
                        _controllersearchtag.value.text.trim().toString(),
                        //sellerid,
                        sellerid,
                        username,
                        //  await EcommercApp.userUID,
                        ///  await EcommercApp.userName.toString(),
                        // _controllersellername.value.text.trim().toString(),
                        _controllerstock.value.text.trim().toString(),
                        _controllertitle.value.text.trim().toString(),
                        _controllervariant.text.trim().toString());
                    Future.delayed(const Duration(milliseconds: 1500),
                        () async {
                      ///after saving the data is complete, print that the data is saved successfully
                      setState(() {
                        progressDialog.hide();

                        isClicked = !isClicked;
                      });
                      await _alert(context);
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) => myproducts()));
                    });
                    // progressDialog.hide();
                  }

                  //save the product to the database
                },
              ),
              const SizedBox(
                height: 60,
                child: Divider(
                  thickness: 4,
                  color: Colors.greenAccent,
                ),
              ),
              SubmitButton(
                  title: "Back",
                  colorprovided: Colors.green,
                  act: () {
                    Nav.route(context, Uploadpage());
                  })
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("PRODUCTS Cart"),
      content: const Text("Your product has been added to the database."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _alert(BuildContext context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.shrink,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: const TextStyle(
        color: Color.fromRGBO(0, 179, 134, 1.0),
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: "PRODUCTS Cart",
      desc: "Your product has been added to the database.",
      buttons: [
        DialogButton(
          child: const Text(
            "BACK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: const Text(
            "VIEW PRODUCTS",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
      
          },
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        child: Text("Dressing"),
        value: "Dressing",
      ),
      const DropdownMenuItem(
        child: Text("Electronics"),
        value: "Electronics",
      ),
      const DropdownMenuItem(
        child: Text("Home"),
        value: "Home",
      ),
      const DropdownMenuItem(
        child: Text("Furniture"),
        value: "Furniture",
      ),
      const DropdownMenuItem(
        child: Text("Services"),
        value: "Services",
      ),
    ];
    return menuItems;
  }

  void onchanged(value) {
    setState(() {
      selectedvalue = value;
    });
  }

  Future<void> saveproduct(
      String sellerphone,
      String filepath,
      String category,
      String colors,
      String descrip,
      String dispric,
      String highli,
      String originalp,
      String searchtag,
      String sellerid,
      String seller,
      String pstock,
      String ptitle,
      String pvariant) async {
    final itemsRef = FirebaseFirestore.instance.collection("items");
    itemsRef.doc(widget.model.id).update({
      "sellerphone": sellerphone,
      "productid": DateTime.now().millisecondsSinceEpoch.toString(),
      "productimageurl": filepath,
      "productcategory": category,
      "productcolors": colors,
      "productdescription": descrip,
      "productdiscountprice": dispric,
      "producthighlights": highli,
      "productoriginalprice": originalp,
      "productsearchtags": searchtag,
      "productsellerid": sellerid,
      "productseller": seller,
      "productstock": pstock,
      "producttitle": ptitle,
      "productvariant": pvariant
    });
  }
}
