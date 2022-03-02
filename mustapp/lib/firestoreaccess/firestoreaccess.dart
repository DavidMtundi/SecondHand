import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<bool> deleteFileFromPath(String path) async {
  final Reference firestorageRef = FirebaseStorage.instance.ref();
  await firestorageRef.child(path).delete();
  //should delete the firestorageref then delete the item itself. or it should mark the item as sold
  return true;
}
Future<bool>updatetoSold(String productId)async{
                                          print("second test completed");

  await FirebaseFirestore.instance.collection('items').doc(productId).update({'productstock': FieldValue.increment(-1)});
                                        print("third test completed");

return true;
}

Future<bool> deleteUserProduct(String productId) async {
  final productsCollectionReference =
      FirebaseFirestore.instance.collection("users");
  await productsCollectionReference.doc(productId).delete();
  return true;
}

String getPathForProductImage(String testdata) {
  //  String testdata =
  //   "https://firebasestorage.googleapis.com/v0/b/eshop1-5c342.appspot.com/o/items%2Fproduct_1638861153570.jpg?alt=media&token=077defb8-f116-4c4a-a28e-fd4e77a78393";

  String answer = testdata.substring(79);
  String completeanswer = "";
  String valuefound = "";
  for (int i = 0; i < answer.length; i++) {
    if (answer[i] != "?") {
      completeanswer = completeanswer + answer[i];
    } else {
      valuefound = completeanswer;
    }
  }
  print(valuefound.toString());

  String path = "items/$valuefound";
  return path;
}

String testdata =
    "https://firebasestorage.googleapis.com/v0/b/eshop1-5c342.appspot.com/o/items%2Fproduct_1638861153570.jpg?alt=media&token=077defb8-f116-4c4a-a28e-fd4e77a78393";

final regex = RegExp(r'^product:$jpg');
