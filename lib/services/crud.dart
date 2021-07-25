import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

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

  static getProfileImfo() async {
    // ignore: await_only_futures

    return await FirebaseFirestore.instance.collection("Users");
  }

  uploadUserInfo(docName, userMap) {
    FirebaseFirestore.instance.collection("Users").doc(docName).set(userMap);
  }

  addUserInfo(userMap) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .set(userMap, SetOptions(merge: true));
  }

  /*Future<List> readInterestedPeople(thisPost) async {
    var ipNow = FirebaseFirestore.instance.collection("Posts").snapshots();
    var nwInterestedPeople;
    //FirebaseFirestore.instance.collection("Posts").doc(thisPost).

    StreamBuilder<QuerySnapshot>(
        stream: ipNow,
        builder: (context, stream) {
          QuerySnapshot? querySnapshot = stream.data;
          var sdocs;
          if (querySnapshot != null) {
            sdocs = querySnapshot.docs;
          }

          // var nwInterestedPeople;
          if (sdocs != null) {
            nwInterestedPeople = sdocs!
                .firstWhere((doc) => doc.id == thisPost, orElse: () => null)
                .data()['interestedPeople'];
          }

          return nwInterestedPeople;
        });

    return await nwInterestedPeople as List;
  }
*/
  addInterestedPeople(eventId, String email) async {
    //List thisList = await readInterestedPeople(eventId);
    //print(thisList);
    //thisList.add("abc");
    //Map<String, List> userMap = {"interestedPeople": thisList};
    /* Map<dynamic, int> map = {
      FieldValue.arrayUnion([email]): 123
    };*/

    //String e = FirebaseAuth.instance.currentUser!.email;
    int i = DateTime.now().millisecondsSinceEpoch;
    String s = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("Posts").doc(eventId).update({
      "interestedPeople.$s": i,
    }).then((_) {
      print("success!");
    });

    /*FirebaseFirestore.instance.collection("Posts").doc(eventId).update({
      "interestedPeopleList": FieldValue.arrayUnion([s]),
    }).then((_) {
      print("success!");
    });*/
    //.set(userMap, SetOptions(merge: true));
  }

  addAcceptedPeople(eventId, id) async {
    int i = DateTime.now().millisecondsSinceEpoch;

    FirebaseFirestore.instance.collection("Posts").doc(eventId).update({
      "acceptedPeople.$id": i,
    }).then((_) {
      print("success!");
    });
  }

  addMatchedPeople(eventId, id) async {
    int i = DateTime.now().millisecondsSinceEpoch;

    FirebaseFirestore.instance.collection("Posts").doc(eventId).update({
      "matchedPeople.$id": i,
    }).then((_) {
      print("success!");
    });
  }

  creatChatroom(String chatRoomId, Map<String, dynamic> chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap);
  }

  addConversationMessages(String chatroomId, Map<String, dynamic> messagesMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatroomId)
        .collection("chats")
        .add(messagesMap);
  }

  getConversationMessages(String chatroomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatroomId)
        .collection("chats")
        .orderBy("Time", descending: false);
  }

  getChatRooms(String userId) async {
    return await FirebaseFirestore.instance.collection("ChatRoom");
  }

  /*isInTheList(eventId, String email) {
    return FirebaseFirestore.instance
        .collection("Posts")
        .doc(eventId)
        .collection("interestedPeople")
        .get()
        .asStream()
        .contains(email);
  }

  bool iisInTheList(eventId, String email) {
    //isInTheList(eventId, email).then((result) => b = result);

    FirebaseFirestore.instance
        .collection("Posts")
        .doc(eventId)
        .get()
        .then((value) {
      List b = value.data()["interestedPeople"];
      print(b);
    });

    List? b;
    // print(b);
    if (b != null) {
      print(b.contains(email));
      return b.contains(email);
    }
    return false;
  }*/
}
