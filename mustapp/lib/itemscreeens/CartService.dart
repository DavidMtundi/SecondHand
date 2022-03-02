import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/models/productmodel.dart';

List<Stream<Productmodel>> allproductsfound = [];

class CartService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<Productmodel> getproduct(String productid) {
    Stream<Productmodel> pd = firestore
        .collection('items')
        .where("productid", isEqualTo: productid.toString())
        .snapshots()
        .map((doc) => Productmodel.fromJson(doc.docs[0].data()));
    allproductsfound.add(pd);
    return pd;
  }

  
  loadallthedata() {
    List<String>? tempcartList =
        EcommercApp.preferences!.getStringList(EcommercApp.usercartList);
    for (var item in tempcartList!) {
      //print("One of the Items are:: " + item.toString());
      //listofdocids.add(item.toString());
      getproduct(item.toString());
    }
    //tempcartList!.add(shortinfoasid);
  }
}
