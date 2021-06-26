import 'package:cloud_firestore/cloud_firestore.dart';

class CrudMethods {
  Future<void> addData(postData) async {
    FirebaseFirestore.instance
        .collection("Posts")
        .add(postData)
        .catchError((e) {
      print(e);
    });
  }

  static getData() async {
    // ignore: await_only_futures

    return await FirebaseFirestore.instance.collection("Posts");
  }
}
