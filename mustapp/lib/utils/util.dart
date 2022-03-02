import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:overlay_support/overlay_support.dart';

class Utils {
  
  static void ShowSnackBar(BuildContext context, String message, Color color) =>
      showSimpleNotification(
          Text(
            "Internet Connection Update",
            style: TextStyle(fontSize: customfont(context, 13)),
          ),
          duration: Duration(seconds: 10),
          subtitle: Text(
            message,
            style: TextStyle(fontSize: customfont(context, 11)),
          ),
          background: color);
}

checkinternetconnectivity(BuildContext context) async {
  final result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    await showconnectivitysnackbar(context, result);
  }
}

showconnectivitysnackbar(BuildContext context, ConnectivityResult result) {
  final hasinternet = result != ConnectivityResult.none;
  final message = hasinternet
      ? "Connection Ok"
      : "NOTE:  Some features may fail to work, To solve this Please check Your Internet Connection";
  final color = hasinternet ? Colors.green : Colors.red;
  Utils.ShowSnackBar(context, message, color);
}

enum ProductType { Electronics, Dressing, Home, Furniture, Services }

Future<List> searchInProducts(String query) async {
  Query queryRef;
  //if (productType == null) {
  queryRef = await FirebaseFirestore.instance.collection("items");
  // }

  List<Productmodel> productsId = [];
  final querySearchInTags =
      await queryRef.where("producttitle", arrayContains: query).get();
  for (final doc in querySearchInTags.docs) {
    final product = Productmodel.fromMap(doc.data() as Map<String, dynamic>);

    productsId.add(product);
  }
  final queryRefDocs = await queryRef.get();
  for (final doc in queryRefDocs.docs) {
    final product = Productmodel.fromMap(doc.data() as Map<String, dynamic>);
    if (product.title.toString().toLowerCase().contains(query) ||
        product.description.toString().toLowerCase().contains(query) ||
        //   product.highlights.toString().toLowerCase().contains(query) ||
        product.variant.toString().toLowerCase().contains(query) ||
        product.seller.toString().toLowerCase().contains(query)) {
      productsId.add(product);
    }
  }
  return await productsId.toList();
}
  bool searching = false;


Future<bool> showConfirmationDialog(
  BuildContext context,
  String messege, {
  String positiveResponse = "Yes",
  String negativeResponse = "No",
}) async {
  var result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(messege),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          FlatButton(
            child: Text(
              positiveResponse,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          FlatButton(
            child: Text(
              negativeResponse,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    },
  );
  if (result == null) result = false;
  return result;
}
