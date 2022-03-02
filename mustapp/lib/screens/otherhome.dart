import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/firestoreaccess/firestoreaccess.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/screens/editscreens.dart';
import 'package:mustapp/screens/login.dart';
import 'package:mustapp/screens/shoppingcart.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/progressdialog.dart';
import 'package:mustapp/utils/util.dart';
import 'package:page_transition/page_transition.dart';

class OtherHome extends StatefulWidget {
  const OtherHome({Key? key}) : super(key: key);

  @override
  _OtherHomeState createState() => _OtherHomeState();
}

final allproducts = FirebaseFirestore.instance
    .collection('items')
    .withConverter<Productmodel>(
      fromFirestore: (snapshots, _) => Productmodel.fromJson(snapshots.data()!),
      toFirestore: (product, _) => product.tojson(),
    );

class _OtherHomeState extends State<OtherHome> {
  @override
  void initState() {
    super.initState();
    loadperson();
  }
   String userid = "";
    loadperson()async{
 userid =
       await EcommercApp.preferences!.getString(EcommercApp.userUID).toString();
       setState(() {
         userid=userid;
       });
       print("the first test prints this $userid");
    }
  @override
  Widget build(BuildContext context) {
    setState(() {});
    final progressDialog = ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage('Loading data');
    // CollectionReference
    // findproducts() {}
   

    //FirebaseApp secondaryApp = Firebase.app('eShop1');
    
    return Scaffold(

        // drawer: leftDrawerMenu(),
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
          title: const Text(
            "Swipe left to Delete and Right to Edit",
            style: TextStyle(color: Colors.black, fontSize: 11),
          ),
          centerTitle: true,
          actions: <Widget>[
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                  ),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: ShoppingCart(true),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('items')
              .where("productsellerid", isEqualTo: userid,).where("productstock",isGreaterThan: 0)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {

              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              //   progressDialog.show();
              //show the progress indicator , please wait
              return const Text("Loading Please Wait");
              //return CircularProgressIndicator(semanticsLabel: "Loading");
            }
            // progressDialog.hide();
            //if(snapshot.connectionState == ConnectionState.done){
            return snapshot.data!.docs.length > 0
                ? CustomScrollView(
                    slivers: <Widget>[
                      SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 2,
                          staggeredTileBuilder: (c) =>
                              const StaggeredTile.fit(2),
                          itemBuilder: (context, index) {
                            Productmodel model = Productmodel.fromJson(
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>);
print("the model.id value is ${model.id}");
                            return Dismissible(
                                key: UniqueKey(),
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    final confirmation =
                                        await showConfirmationDialog(context,
                                            "Are you sure to mark this product as sold?");
                                    if (confirmation) {
                                      // for (int i = 0; i < 1; i++) {
                                      //   String path = getPathForProductImage(
                                      //     model.imageurl,
                                      //   );
                                      //   final deletionFuture =
                                      //       deleteFileFromPath(path);
                                      //   await showDialog(
                                      //     context: context,
                                      //     builder: (context) {
                                      //       return FutureProgressDialog(
                                      //         deletionFuture,
                                      //         message: Text(
                                      //             "Deleting Product Images "),
                                      //       );
                                      //     },
                                      //   );
                                      // }

                                      bool productInfoDeleted = false;
                                      String snackbarMessage = "";
                                      try {
                                        print("first test completed");
                                        final deleteProductFuture =
                                            updatetoSold(model.id.toString())
                                                .then((value) {
                                                   ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text("Product deleted Successfully"),
                                          ),
                                        );
                                                });
                                        productInfoDeleted = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return FutureProgressDialog(
                                              deleteProductFuture,
                                              message: Text("Deleting Product"),
                                            );
                                          },
                                        );
                                        if (productInfoDeleted == true) {
                                          snackbarMessage =
                                              "Product deleted successfully";
                                        } else {
                                          throw "Coulnd't delete product, please retry";
                                        }
                                      } on FirebaseException catch (e) {
                                        //  Logger().w("Firebase Exception: $e");
                                        snackbarMessage =
                                            "Something went wrong";
                                      } catch (e) {
                                        //Logger().w("Unknown Exception: $e");
                                        snackbarMessage = e.toString();
                                      } finally {
                                        //Logger().i(snackbarMessage);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(snackbarMessage),
                                          ),
                                        );
                                      }
                                    }
                                    await refreshPage();
                                    return confirmation;
                                  } else if (direction ==
                                      DismissDirection.endToStart) {
                                    final confirmation =
                                        await showConfirmationDialog(context,
                                            "Are you sure to Edit Product?");
                                    if (confirmation) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              edittheproduct(context, model),
                                        ),
                                      );
                                    }
                                    await refreshPage();
                                    return false;
                                  }
                                  return false;
                                },
                                onDismissed: (direction) async {
                                  await refreshPage();
                                },
                                child: sourceInfo(model, context));
                          },
                          itemCount: snapshot.data!.docs.length)
                    ],
                  )
                : Center(
                    child: Column(
                      children: const [
                        Icon(
                          Icons.hourglass_empty,
                          color: Colors.black,
                          size: 20,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("No Items Here"),
                      ],
                    ),
                  );
            // }
          },
        ));
  }

  sighnout() async {
    await EcommercApp.auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  refreshPage() {
    initState();
  }
}

Widget sourceInfo(Productmodel model, BuildContext context,
    {Color? background, removeCartFunction}) {
  return Padding(
    padding: const EdgeInsets.all(6),
    child: Container(
        height: CustomHeight(context, 190),
        width: customdividewidth(context, 1),
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius:
                BorderRadius.all(Radius.circular(CustomWidth(context, 18)))),
        child: Row(
          children: [
            Container(
              height: CustomHeight(context, 150),
              width: CustomWidth(context, 160),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(CustomWidth(context, 20)))),
              child: CachedNetworkImage(
                imageUrl: model.imageurl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                // model.imageurl,
                //width: 150,
                // height: 140,
              ),
            ),
             SizedBox(
              width: CustomWidth(context, 4),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: CustomHeight(context, 15),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          model.title,
                          style: TextStyle(
                              letterSpacing: -1.1,
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: customfont(context, 16)),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: CustomHeight(context, 5)),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          model.highlights,
                          style:  TextStyle(
                              color: Colors.black54, fontSize: customfont(context, 12)),
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: CustomHeight(context, 5)),
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle, color: Colors.pink),
                        alignment: Alignment.topLeft,
                        //  width: 30,
                        // height: 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ((int.parse(model.price) /
                                                  int.parse(
                                                      model.discountprice)) *
                                              100 -
                                          100)
                                      .toString()
                                      .substring(0, 2) +
                                  "%",
                              //   "50%",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "OFF",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: CustomWidth(context, 10),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: CustomWidth(context, 14) > 16
                                ? Row(
                                    children: [
                                      Text(
                                        "Original Price:  ",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 12,
                                            letterSpacing: -1.3,
                                            color: Colors.grey),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Kshs ${model.price.toString()}",
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 12,
                                            letterSpacing: -1.2,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Text(
                                        "Original Price:  ",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: customfont(context, 12),
                                            letterSpacing: -1.3,
                                            color: Colors.grey),
                                      ),
                                       SizedBox(
                                        height: CustomHeight(context, 5),
                                      ),
                                      Text(
                                        "Kshs ${model.price.toString()}",
                                        style:  TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: customfont(context, 12),
                                            letterSpacing: -1.2,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: CustomWidth(context, 14) > 16
                                ? Row(
                                    children: [
                                      const Text(
                                        "New Price:  ",
                                        style: TextStyle(
                                            letterSpacing: -1.2,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black54),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Kshs ${model.discountprice.toString()}",
                                        style: const TextStyle(
                                            letterSpacing: -1.2,
                                            fontSize: 12,
                                            color: Colors.grey),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                       Text(
                                        "New Price:  ",
                                        style: TextStyle(
                                            letterSpacing: -1.2,
                                            fontSize: customfont(context, 13),
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black54),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Kshs ${model.discountprice.toString()}",
                                        style: const TextStyle(
                                            letterSpacing: -1.2,
                                            fontSize: 12,
                                            color: Colors.grey),
                                      )
                                    ],
                                  ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        )),
  );
}

edittheproduct(BuildContext context, Productmodel model) async {
  Route route = MaterialPageRoute(builder: (c) => editproduct(model: model));
  await Navigator.push(context, route);
}

deleteProduct(Productmodel model) async {
  //get the product from the firestore document datbase
  //get the value with the given product picture id from the firebase storage database
  //perform the deletion
  final collection = FirebaseFirestore.instance.collection('items');
  try {
    collection
        .doc(model.id.toString()) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) {
      print('Deleted');
      Fluttertoast.showToast(msg: "Product deleted Successfully");
    }).catchError((error) {
      print('Delete failed: $error');
    });
  } catch (e) {
    print(e.toString());
  }

  //await storage.ref(model.imageurl).delete();
  // Rebuild the UI
}
