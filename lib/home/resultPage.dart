import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/home/postCreatePage.dart';
import 'package:my_app/services/crud.dart';

import 'DetailedEvent.dart';
import 'filterPage.dart';

class ResultPage extends StatefulWidget {
  late String eventName, eventLocation, eventTime, eventDate;
  ResultPage(
      this.eventName, this.eventLocation, this.eventTime, this.eventDate);
  @override
  _ResultPageState createState() => new _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  CrudMethods crudMethods = new CrudMethods();
  get mainAxisAlignment => null;

  Query? postsStream;

  @override
  void initState() {
    super.initState();
    CrudMethods.getData().then((result) {
      setState(() {
        postsStream = result;
      });
    });
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  Widget postsList() {
    var s;

    if (postsStream != null) {
      s = postsStream!.snapshots();
    }
    return Container(
      child: Column(
        children: <Widget>[
          postsStream != null
              ? Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: s,
                      builder: (context, stream) {
                        QuerySnapshot? querySnapshot = stream.data;

                        Iterable<QueryDocumentSnapshot>? l;
                        if (querySnapshot != null) {
                          l = querySnapshot.docs
                              .where((element) => element["Event_Name"]
                                  .toLowerCase()
                                  .contains(widget.eventName.toLowerCase()))
                              .where((element) => element["Event_Location"]
                                  .toLowerCase()
                                  .contains(widget.eventLocation.toLowerCase()))
                              .where((element) => element["Event_Time"]
                                  .toLowerCase()
                                  .contains(widget.eventTime.toLowerCase()))
                              .where((element) => element["Event_Date"]
                                  .toLowerCase()
                                  .contains(widget.eventDate.toLowerCase()));
                        }

                        var ic;
                        if (l != null) {
                          ic = l.length;
                        }

                        return ListView.builder(
                            itemCount: ic,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var docsIndex;
                              List? listL;
                              if (l != null) {
                                listL = l.toList();
                              }

                              if (listL != null) {
                                docsIndex = listL[index];
                                //print(l);

                                return oneOfThePosts(
                                  // ignore: unrelated_type_equality_checks
                                  imgUrl: docsIndex.data()['Event_Image'],
                                  eventName: docsIndex.data()["Event_Name"],
                                  eventLocation:
                                      docsIndex.data()['Event_Location'],
                                  eventTime: docsIndex.data()['Event_Time'],
                                  eventDate: docsIndex.get('Event_Date'),
                                  name: docsIndex.get('name'),
                                  email: docsIndex.get('email'),
                                  time: docsIndex.data()['time'],
                                  eventId: docsIndex.id,
                                );
                              }
                              return Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator());
                            });
                      }))
              : Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          title: Text("Search Result"),
        ),
        body: postsList());

    return scaffold;
  }
}

class oneOfThePosts extends StatefulWidget {
  String imgUrl,
      eventName,
      eventLocation,
      eventTime,
      eventDate,
      name,
      email,
      eventId;
  int time;
  oneOfThePosts(
      {required this.imgUrl,
      required this.eventName,
      required this.eventLocation,
      required this.eventTime,
      required this.eventDate,
      required this.name,
      required this.email,
      required this.time,
      required this.eventId});

  @override
  _oneOfThePostsState createState() => _oneOfThePostsState();
}

class _oneOfThePostsState extends State<oneOfThePosts> {
  Query? postsStream;

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
    var ss;
    if (postsStream != null) {
      ss = postsStream!.snapshots();
    }

    return Container(
        height: 150,
        margin: EdgeInsets.fromLTRB(5, 2.5, 5, 2.5),
        child: FlatButton(
          color: Colors.white,
          height: 140,
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new DetailedEvent(
                        title: 'DetailedEvent',
                        eventDate: widget.eventDate,
                        eventImage: widget.imgUrl,
                        eventLocation: widget.eventLocation,
                        eventName: widget.eventName,
                        eventTime: widget.eventTime,
                        email: widget.email,
                        name: widget.name,
                        time: widget.time,
                        eventId: widget.eventId,
                      )),
            );
            print("button click");
          },
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      height: 140,
                      child: Image.network(
                        widget.imgUrl,
                        fit: BoxFit.cover,
                      ))),

              //color: Colors.amber.shade50,

              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsetsDirectional.only(start: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Wrap(
                        spacing: 2,
                        runSpacing: 5,
                        children: [
                          Text(
                            widget.eventName,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 130,
                        height: 30,
                      ),
                      Wrap(
                        spacing: 2,
                        runSpacing: 5,
                        children: [
                          Text(
                            widget.eventLocation,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: Wrap(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 60),
                      //child: Text("19:0001/01/2021"),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.eventTime),
                          Text(widget.eventDate),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0.0),
                      child: FlatButton(
                        onPressed: () {
                          print("profile按钮被点击了");
                        },
                        // minWidth: 150,
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            postsStream != null
                                ? Expanded(
                                    child: StreamBuilder<QuerySnapshot>(
                                        stream: ss,
                                        builder: (context, stream) {
                                          QuerySnapshot? querySnapshot =
                                              stream.data;
                                          var sdocs;
                                          if (querySnapshot != null) {
                                            sdocs = querySnapshot.docs;
                                          }

                                          var nwImage;
                                          if (sdocs != null) {
                                            nwImage = sdocs!
                                                .firstWhere(
                                                    (doc) =>
                                                        doc.id == widget.email,
                                                    orElse: () => null)
                                                .data()['Image'];
                                          }

                                          return Container(
                                              width: 20,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          nwImage != null
                                                              ? nwImage
                                                              : 'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                                                      fit: BoxFit.contain)));
                                        }),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator()),
                            Container(
                              width: 43,
                              margin: EdgeInsetsDirectional.only(start: 0),
                              child: Text(
                                widget.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: TextStyle(
                                  fontSize: 11,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
