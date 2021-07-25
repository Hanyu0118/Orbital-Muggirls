import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_app/services/crud.dart';

class DetailedEvent extends StatefulWidget {
  String eventDate,
      eventImage,
      eventLocation,
      eventName,
      eventTime,
      email,
      name,
      eventId;
  int time;
  DetailedEvent(
      {Key? key,
      required this.title,
      required this.eventDate,
      required this.eventImage,
      required this.eventLocation,
      required this.eventName,
      required this.eventTime,
      required this.email,
      required this.name,
      required this.time,
      required this.eventId})
      : super(key: key);
  final String title;

  @override
  _DetailedEventState createState() => new _DetailedEventState();
}

class _DetailedEventState extends State<DetailedEvent> {
  Query? postsStream;
  var enable = true;

  CrudMethods crudMethods = new CrudMethods();

  @override
  void initState() {
    super.initState();

    CrudMethods.getProfileImfo().then((result) {
      if (!mounted) {
        return;
      }
      setState(() {
        postsStream = result;
      });
    });
  }

  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(widget.time);
    var ss;
    if (postsStream != null) {
      ss = postsStream!.snapshots();
    }
    if (widget.email == FirebaseAuth.instance.currentUser!.email) {
      return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("My Event"),
              ],
            ),
          ),
          backgroundColor: Colors.amber[100],
          body: new ListView(children: [
            Container(
              color: Colors.white,
              child: new Image.network(
                widget.eventImage,
                height: 300.0,
                fit: BoxFit.contain,
              ),
              height: 300,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                "$date",
                style: TextStyle(
                  fontSize: 13.0,
                ),
              )
            ]),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // ignore: deprecated_member_use

              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 200, 10),
                child: FlatButton(
                  shape: RoundedRectangleBorder(),

                  onPressed: () {
                    print("profile按钮被点击了");
                  },
                  // minWidth: 150,
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      postsStream != null
                          ? Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: ss,
                                  builder: (context, stream) {
                                    QuerySnapshot? querySnapshot = stream.data;
                                    var sdocs;
                                    if (querySnapshot != null) {
                                      sdocs = querySnapshot.docs;
                                    }
                                    var cuEmail;
                                    if (FirebaseAuth.instance.currentUser !=
                                        null) {
                                      cuEmail = FirebaseAuth
                                          .instance.currentUser!.email;
                                    }
                                    var nwImage;
                                    if (sdocs != null) {
                                      nwImage = sdocs!
                                          .firstWhere(
                                              (doc) => doc.id == widget.email,
                                              orElse: () => null)
                                          .data()['Image'];
                                    }

                                    return Container(
                                        // width: 80,

                                        height: 60,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(nwImage !=
                                                        null
                                                    ? nwImage
                                                    : 'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                                                fit: BoxFit.contain)));
                                  }),
                            )
                          : Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator()),
                      Container(
                        width: 90,
                        //margin: EdgeInsetsDirectional.only(start: 0),
                        child: Text(
                          widget.name,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text("Event Name: " + widget.eventName,
                      softWrap: true,
                      style: new TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                      "Event Time: " +
                          widget.eventDate +
                          "  " +
                          widget.eventTime,
                      softWrap: true,
                      style: new TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text("Location: " + widget.eventLocation,
                      softWrap: true,
                      style: new TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ))),
            ])
          ]));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Details"),
              ],
            ),
          ),
          backgroundColor: Colors.amber[100],
          body: new ListView(children: [
            Container(
              color: Colors.white,
              child: new Image.network(
                widget.eventImage,
                height: 300.0,
                fit: BoxFit.contain,
              ),
              height: 300,
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(270, 10, 0, 0),
                child: Text(
                  "$date",
                  style: TextStyle(
                    fontSize: 11.0,
                  ),
                )),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // ignore: deprecated_member_use

              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 200, 10),
                child: FlatButton(
                  shape: RoundedRectangleBorder(),

                  onPressed: () {
                    print("profile按钮被点击了");
                  },
                  // minWidth: 150,
                  height: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      postsStream != null
                          ? Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: ss,
                                  builder: (context, stream) {
                                    QuerySnapshot? querySnapshot = stream.data;
                                    var sdocs;
                                    if (querySnapshot != null) {
                                      sdocs = querySnapshot.docs;
                                    }
                                    var cuEmail;
                                    if (FirebaseAuth.instance.currentUser !=
                                        null) {
                                      cuEmail = FirebaseAuth
                                          .instance.currentUser!.email;
                                    }
                                    var nwImage;
                                    if (sdocs != null) {
                                      nwImage = sdocs!
                                          .firstWhere(
                                              (doc) => doc.id == widget.email,
                                              orElse: () => null)
                                          .data()['Image'];
                                    }

                                    return Container(
                                        // width: 80,

                                        height: 60,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(nwImage !=
                                                        null
                                                    ? nwImage
                                                    : 'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                                                fit: BoxFit.contain)));
                                  }),
                            )
                          : Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator()),
                      Container(
                        width: 90,
                        //margin: EdgeInsetsDirectional.only(start: 0),
                        child: Text(
                          widget.name,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text("Event Name: " + widget.eventName,
                      softWrap: true,
                      style: new TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text(
                      "Event Time: " +
                          widget.eventDate +
                          "  " +
                          widget.eventTime,
                      softWrap: true,
                      style: new TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ))),
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Text("Location: " + widget.eventLocation,
                      softWrap: true,
                      style: new TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ))),
              Padding(
                  padding: EdgeInsets.fromLTRB(120, 10, 130, 10),
                  child: FlatButton(
                      height: 50,
                      color: Colors.amber,
                      highlightColor: Colors.amber[700],
                      colorBrightness: Brightness.dark,
                      splashColor: Colors.grey,
                      child: Text("   Let me join!   ",
                          style: new TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          )),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      onPressed: Button._pressButton(widget.eventId))),
            ])
          ]));
    }
  }

  /*_pressButton() {
    Fluttertoast.showToast(
        msg: 'This is toast notification',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.yellow);
    CrudMethods cm = new CrudMethods();
    //if (cm.iisInTheList(
    //widget.eventId, FirebaseAuth.instance.currentUser!.email)) {
    /*if (cm.iisInTheList(
        widget.eventId, FirebaseAuth.instance.currentUser!.email)) {
      return null;
    }*/
    return () {
      cm.addInterestedPeople(
        widget.eventId,
        FirebaseAuth.instance.currentUser!.email,
      );
      //print(widget.eventId);
    };
  }*/
}

class Button {
  static _pressButton(eventId) {
    CrudMethods cm = new CrudMethods();
    //if (cm.iisInTheList(
    //widget.eventId, FirebaseAuth.instance.currentUser!.email)) {
    /*if (cm.iisInTheList(
        widget.eventId, FirebaseAuth.instance.currentUser!.email)) {
      return null;
    }*/
    return () {
      cm.addInterestedPeople(
        eventId,
        FirebaseAuth.instance.currentUser!.email,
      );
      Fluttertoast.showToast(
          msg: 'Your request has been sent to the event holder successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.amber,
          textColor: Colors.white);

      //print(widget.eventId);
    };
  }
}
