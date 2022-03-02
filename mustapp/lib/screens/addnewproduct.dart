// ignore_for_file: unnecessary_const

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/itemscreeens/Resetpassword.dart';
import 'package:mustapp/pages/uploadpage.dart';
import 'package:mustapp/utils/navigator.dart';

import 'package:mustapp/widgets/edittext.dart';
import 'package:mustapp/widgets/submitbutton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class Addnewproductpage extends StatefulWidget {
  const Addnewproductpage({Key? key}) : super(key: key);

  @override
  State<Addnewproductpage> createState() => _AddnewproductpageState();
}

class _AddnewproductpageState extends State<Addnewproductpage> {
  String selectedvalue = "Electronics";
  List<Asset> images = <Asset>[];
  List<Asset> resultList = <Asset>[];

  bool isClicked = false;
  final TextEditingController _controllertitle = TextEditingController();

  final TextEditingController _controllervariant = TextEditingController();
  final TextEditingController _controllerstock = TextEditingController();

  final TextEditingController _controllercolors = TextEditingController();
  final TextEditingController _controlleroriginalprice =
      TextEditingController();

  final TextEditingController _controllerdiscountprice =
      TextEditingController();

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
  bool isloading = false;

  String productimageurl = "";

  void requestpermissions() async {
    await [Permission.storage, Permission.camera].request();
  }

  Future<void> initializeControllers() async {
    _controllercolors.text = "";
    _controllerdescription.text = "";
    _controllerdiscountprice.text = "";
    _controllerhiglights.text = "";
    _controlleroriginalprice.text = "";
    _controllersearchtag.text = "";
    //sellerid,
    sellerid = "";
    username = "";
    //  await EcommercApp.userUID,
    ///  await EcommercApp.userName.toString(),
    // _controllersellername.text="";
    _controllerstock.text = "";
    _controllertitle.text = "";
    _controllervariant.text = "";
  }

  Future<void> loadAssets() async {
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Pick Photos",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      //  _error = error;
    });
  }

  Future<void> _selectandpickImage() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      requestpermissions();
    } else {
      try {
        XFile fileselected =
            (await _imagePicker.pickImage(source: ImageSource.gallery))!;

        setState(() {
          _imagefile = fileselected;
        });
      } catch (Exception) {
        print(Exception.toString());
      }
    }
  }

  Future<String> uploadImageandSaveItemInfo() async {
    late XFile image; //= _imagefile!;
    if (_imagefile != null) {
      image = _imagefile!;
    }
    productimageurl = await _uploadandSaveimage(File(image.path));

    print("the image download url is  $productimageurl");
    return productimageurl;
  }

  Future uploadAllImages() async {
    List<String> downloadedUrls = [];

//get all the images and save them
    if (images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        downloadedUrls[i] = await _uploadandSaveimage(images[i]);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please select atleast one image to continue");
    }
    return downloadedUrls;
  }

  Future<String> _uploadandSaveimage(mFileImage) async {
    // requestpermissions();
    String downloadurlvalue = "";
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
              Container(
                height: 30,
                color: Colors.black38,
                child: TextButton(
                  onPressed: () async {
                    // _uploadandSaveimage();
                    await loadAssets();
                  },
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              images.length > 0
                  ? Container(
                      height: 100,
                      child: Expanded(
                        child: buildGridView(),
                      ),
                    )
                  : SizedBox.shrink(),
              const Text(
                "Choose the Product Type(Category)",
                style: TextStyle(fontSize: 14),
              ),
              DropdownButton(
                  //style: TextStyle(fontSize: 13),
                  items: dropdownItems,
                  onChanged: onchanged,
                  value: selectedvalue),

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
              isloading
                  ? CustomLoadingWidget(text: "Adding Product")
                  : SubmitButton(
                      title: "Add Product",
                      act: () async {
                        if (_imagefile == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: const Text(
                                      "Please pick the File please Try again")));
                        } else {
                          setState(() {
                            isloading = true;
                          });
                          // uploadImageandSaveItemInfo();
                          try {
                            await saveproduct(
                                sellerphone,
                                // await uploadImageandSaveItemInfo(),
                                // productimageurl,
                                await uploadAllImages(),
                                selectedvalue,
                                _controllercolors.value.text.trim().toString(),
                                _controllerdescription.value.text
                                    .trim()
                                    .toString(),
                                _controllerdiscountprice.value.text
                                    .trim()
                                    .toString(),
                                _controllerhiglights.value.text
                                    .trim()
                                    .toString(),
                                _controlleroriginalprice.value.text
                                    .trim()
                                    .toString(),
                                _controllersearchtag.value.text
                                    .trim()
                                    .toString(),
                                //sellerid,
                                sellerid,
                                username,
                                //  await EcommercApp.userUID,
                                ///  await EcommercApp.userName.toString(),
                                // _controllersellername.value.text.trim().toString(),
                                int.parse(_controllerstock.value.text
                                    .trim()
                                    .toString()),
                                _controllertitle.value.text.trim().toString(),
                                _controllervariant.text.trim().toString());
                          } catch (ex) {
                            setState(() {
                              isloading = false;
                            });
                          }
                          Future.delayed(const Duration(milliseconds: 1500),
                              () async {
                            ///after saving the data is complete, print that the data is saved successfully
                            setState(() {
                              isloading = false;
                              isClicked = !isClicked;
                            });
                            await _alert(context);
                            setState(() {});
                          });
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

  ///build GridView
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 80,
          height: 80,
        );
      }),
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
          onPressed: () {},
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
      int pstock,
      String ptitle,
      String pvariant) async {
    try {
      final itemsRef = FirebaseFirestore.instance.collection("items");
      itemsRef.doc(Productid).set({
        "sellerphone": sellerphone,
        "productid": Productid,
        "productimageurl": [filepath],
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
    } catch (ex) {
      setState(() {
        isloading = false;
      });
    }
    setState(() {
      isloading = false;
      initializeControllers();
    });
  }
}
