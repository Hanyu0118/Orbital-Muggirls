//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/home/homePage.dart';
import 'package:my_app/services/crud.dart';

import 'conversationPage.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationState createState() => new _NotificationState();
}

class _NotificationState extends State<Notifications> {
  Query? postsStream;
  Query? thispostsStream;

  var enable = true;

  CrudMethods crudMethods = new CrudMethods();

  get listL => null;

  @override
  void initState() {
    super.initState();
    CrudMethods.getProfileImfo().then((result) {
      setState(() {
        postsStream = result;
      });
    });
    CrudMethods.getData().then((result) {
      setState(() {
        thispostsStream = result!.where("interestedPeople",
            //(result) =>
            // result.containsKey(FirebaseAuth.instance.currentUser!.uid
            isNotEqualTo: Map());

        // .get("FirebaseAuth.instance.currentUser!.uid");
      });
    });

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  Widget askForPermissionList() {
    var s;
    if (thispostsStream != null) {
      s = thispostsStream!.snapshots();
    }
    return Column(children: <Widget>[
      if (postsStream != null)
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: s,
                builder: (context, stream) {
                  QuerySnapshot? querySnapshot = stream.data;
                  Iterable<QueryDocumentSnapshot>? l;
                  if (querySnapshot != null) {
                    l = querySnapshot.docs.where((element) =>
                        element["email"] ==
                        FirebaseAuth.instance.currentUser!.email);
                  }
                  Iterable<QueryDocumentSnapshot>? ll;
                  if (querySnapshot != null) {
                    ll = querySnapshot.docs.where((element) =>
                        element["acceptedPeople"]
                            .keys
                            .toString()
                            .contains(FirebaseAuth.instance.currentUser!.uid));
                  }
                  //print(ll);
                  //print(l);
                  var ic;
                  if (l != null && ll != null) {
                    ic = l.length + ll.length;
                  }
                  //print(ic);
                  return ListView.builder(
                      //physics: const NeverScrollableScrollPhysics(),
                      itemCount: ic,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var docsIndex;
                        List? listL;
                        if (l != null && ll != null) {
                          listL = l.toList();
                          listL.addAll(ll.toList());
                        }

                        if (listL != null) {
                          docsIndex = listL[index];
                          //print(l);

                          return oneOfTheEventLists(
                              docsIndex.data()["email"],
                              docsIndex.data()["interestedPeople"].length,
                              docsIndex.data()["interestedPeople"],
                              docsIndex.data()["Event_Name"],
                              docsIndex.data()['Event_Time'],
                              docsIndex.data()['Event_Date'],
                              docsIndex.id,
                              docsIndex.data()["acceptedPeople"],

                              // docsIndex.data()["acceptedPeople"].length,
                              docsIndex.data()["userId"],
                              docsIndex.data()["matchedPeople"]);
                        }
                        return Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator());
                      });
                }))
      else
        Container(
            alignment: Alignment.center, child: CircularProgressIndicator()),
      /*if (postsStream != null)
        Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: s,
                builder: (context, stream) {
                  QuerySnapshot? querySnapshot = stream.data;
                  Iterable<QueryDocumentSnapshot>? ll;
                  if (querySnapshot != null) {
                    ll = querySnapshot.docs.where((element) =>
                        element["acceptedPeople"]
                            .keys
                            .toString()
                            .contains(FirebaseAuth.instance.currentUser!.uid));
                  }
                  var ic;
                  if (ll != null) {
                    ic = ll.length;
                  }
                  return ListView.builder(
                      //physics: const NeverScrollableScrollPhysics(),
                      itemCount: ic,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var docsIndex;
                        if (ll != null) {
                          docsIndex = ll.toList()[index];

                          return oneOfTheList2(
                            //docsIndex.data()["acceptedPeople"].length,
                            docsIndex.data()["userId"],
                            docsIndex.data()["Event_Name"],
                            docsIndex.data()['Event_Time'],
                            docsIndex.data()['Event_Date'],
                            docsIndex.id,
                            docsIndex.data()["acceptedPeople"],
                          );
                        }
                        return Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator());
                      });
                }))
      else
        Container(
            alignment: Alignment.center, child: CircularProgressIndicator()),*/
    ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Notifications"),
            ],
          ),
        ),
        backgroundColor: Colors.amber[100],
        body: askForPermissionList());
  }

  oneOfTheEventLists(
      String email,
      int numOfInterestedPeople,
      Map interstedPeople,
      String eventName,
      String eventTime,
      String eventDate,
      String eventId,
      Map acceptedPeople,
      String userId,
      Map matchedPeopleMap) {
    List interestedPeopleIds = interstedPeople.keys.toList();
    List accpetedPeopleIds = acceptedPeople.keys.toList();
    interestedPeopleIds
        .retainWhere((element) => !accpetedPeopleIds.contains(element));

    if (email == FirebaseAuth.instance.currentUser!.email) {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: interestedPeopleIds.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            //var docsIndex;
            if (interstedPeople != null) {
              // docsIndex = querySnapshot.docs[index];

              return oneOfTheRows(
                  interestedPeopleIds[index],
                  eventName,
                  eventTime,
                  interstedPeople[interestedPeopleIds[index]],
                  eventDate,
                  eventId);
            }
            return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator());
          });
    } else {
      return oneOfTheList2(userId, eventName, eventTime, eventDate, eventId,
          acceptedPeople, matchedPeopleMap);
    }
  }

  oneOfTheRows(String Id, String eventName, String eventTime, int requestTime,
      String eventDate, String eventId) {
    var date = DateTime.fromMillisecondsSinceEpoch(requestTime);
    String name = "No name";
    var ss;
    if (postsStream != null) {
      ss = postsStream!.snapshots();
    }
    return Container(
        decoration: new BoxDecoration(
          border: new Border.all(width: 1, color: Colors.amber),
        ),
        height: 166,
        child: Column(
          children: [
            Row(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: ss,
                    builder: (context, stream) {
                      QuerySnapshot? querySnapshot = stream.data;
                      Iterable<QueryDocumentSnapshot>? l;
                      if (querySnapshot != null) {
                        l = querySnapshot.docs
                            .where((element) => element["UserId"] == Id);
                      }

                      var nwImage;
                      if (l != null) {
                        nwImage = l.toList()[0].data()["Image"];
                      }

                      if (l != null) {
                        name = l.toList()[0].data()["Name"];
                      }

                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: RaisedButton(
                              shape: CircleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              //height: 55,
                              // minWidth: 50,
                              onPressed: () {},
                              child: Container(
                                  margin: EdgeInsets.only(),
                                  width: 59,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(nwImage != null
                                              ? nwImage
                                              : 'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                                          fit: BoxFit.contain))),
                            ),
                          ),
                          Container(
                            width: 320,
                            child: Text(
                              name + " sent you an event request.",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 4,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          )
                        ],
                      );
                    }),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Event Name: " + eventName),
                  Text("Event Time: " + eventTime + " " + eventDate)
                ],
              ),
            ),
            RaisedButton(
                //height: 40,
                color: Colors.amber,
                highlightColor: Colors.amber[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text("   Accept!   ",
                    style: new TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    )),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {
                  CrudMethods cm = new CrudMethods();
                  cm.addAcceptedPeople(eventId, Id);
                  createChatroomAndStartConversation(
                      Id, FirebaseAuth.instance.currentUser!.uid);

                  Fluttertoast.showToast(
                      msg: 'You can start to chat with ' + name + " now!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.amber,
                      textColor: Colors.white);
                }),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                "$date",
                style: TextStyle(fontSize: 12),
              ),
            ])
          ],
        ));
  }

  oneOfTheList2(userId, eventName, eventTime, eventDate, eventId,
      acceptedPeopleMap, matchedPeopleMap) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        acceptedPeopleMap[FirebaseAuth.instance.currentUser!.uid]);
    List acceptedPeopleIds = acceptedPeopleMap.keys.toList();
    List matchedPeopleIds = [];

    if (matchedPeopleMap != null) {
      matchedPeopleIds = matchedPeopleMap.keys.toList();
      // return;
    }
    if (matchedPeopleIds.contains(FirebaseAuth.instance.currentUser!.uid)) {
      return;
    }

    String name = "No name";
    var ss;
    if (postsStream != null) {
      ss = postsStream!.snapshots();
    }
    return Container(
        decoration: new BoxDecoration(
          border: new Border.all(width: 1, color: Colors.amber),
        ),
        height: 166,
        child: Column(
          children: [
            Row(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: ss,
                    builder: (context, stream) {
                      QuerySnapshot? querySnapshot = stream.data;
                      Iterable<QueryDocumentSnapshot>? l;
                      if (querySnapshot != null) {
                        l = querySnapshot.docs
                            .where((element) => element["UserId"] == userId);
                      }

                      var nwImage;
                      if (l != null) {
                        nwImage = l.toList()[0].data()["Image"];
                      }

                      if (l != null) {
                        name = l.toList()[0].data()["Name"];
                      }

                      return Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            child: RaisedButton(
                              shape: CircleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              //height: 55,
                              // minWidth: 50,
                              onPressed: () {},
                              child: Container(
                                  margin: EdgeInsets.only(),
                                  width: 59,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(nwImage != null
                                              ? nwImage
                                              : 'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                                          fit: BoxFit.contain))),
                            ),
                          ),
                          Container(
                            width: 320,
                            child: Text(
                              name + " permitted your request.",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 4,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          )
                        ],
                      );
                    }),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Event Name: " + eventName),
                  Text("Event Time: " + eventTime + " " + eventDate)
                ],
              ),
            ),
            RaisedButton(
                //height: 40,
                color: Colors.amber,
                highlightColor: Colors.amber[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text("   OK!   ",
                    style: new TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    )),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {
                  CrudMethods cm = new CrudMethods();
                  cm.addMatchedPeople(
                      eventId, FirebaseAuth.instance.currentUser!.uid);

                  Fluttertoast.showToast(
                      msg: 'You can start to chat with ' + name + " now!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.amber,
                      textColor: Colors.white);
                }),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                "$date",
                style: TextStyle(fontSize: 12),
              ),
            ])
          ],
        ));
  }

  //docsIndex.data()["acceptedPeople"].length,

  createChatroomAndStartConversation(String id, String postOwnerId) {
    List<String> users = [postOwnerId, id];
    String chatRoomId = getChatRoomId(id, postOwnerId);
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId
    };
    crudMethods.creatChatroom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationPage(chatRoomId, id)));
    //Navigator.push(context, MaterialPageRoute(builder: (context)=> conversationScreen()));
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}
