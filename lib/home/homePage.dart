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

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                        var ic;
                        if (querySnapshot != null) {
                          ic = querySnapshot.size;
                        }
                        return ListView.builder(
                            itemCount: ic,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var docsIndex;
                              if (querySnapshot != null) {
                                docsIndex = querySnapshot.docs[index];

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
          title: Text("Home"),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new SearchBarPage()),
                  );
                  print("button click");

                  // Navigator.of(context).pop();
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("FloratingAcitionButton");
          },
          child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreatePost()));
              }),
          //tooltip: "按这么长时间干嘛",
          foregroundColor: Colors.white,
          backgroundColor: Colors.amber,
          // elevation: 6.0,
          // highlightElevation: 12.0,
          shape: CircleBorder(),
          //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
