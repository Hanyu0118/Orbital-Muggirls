// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/crud.dart';
import 'package:my_app/profile/settingPage.dart';

import '../home/homePage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Query? thispostsStream;
  Query? thispostsStream2;
  Query? postsStream;
  CrudMethods crudMethods = new CrudMethods();

  get arrayContains => null;

  @override
  void initState() {
    super.initState();
    CrudMethods.getProfileImfo().then((result) {
      setState(() {
        postsStream = result;
      });
    });
    // Map m = new Map();
    CrudMethods.getData().then((result) {
      setState(() {
        thispostsStream = result!
            // .where("interestedPeople", isNotEqualTo: m)
            .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
        /*if (thispostsStream != null) {
          thispostsStream = thispostsStream!.where("userId",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid);
        }*/
      });
    });

    CrudMethods.getData().then((result) {
      setState(() {
        thispostsStream2 = result;
        /*if (thispostsStream != null) {
          thispostsStream = thispostsStream!.where("userId",
              isEqualTo: FirebaseAuth.instance.currentUser!.uid);
        }*/
      });
    });

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    /* var _tabs = <String>[];
    _tabs = <String>[
      "Posts",
      "Joined Posts",
      //"Tab 3",
    ];
*/
    var s;
    if (thispostsStream != null) {
      s = thispostsStream!.snapshots();
    }
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        // This is the number of tabs.
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              var ss;
              if (postsStream != null) {
                ss = postsStream!.snapshots();
              }

              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    floating: true,
                    expandedHeight: 280.0,
                    flexibleSpace: new FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: new Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          const DecoratedBox(
                            decoration: const BoxDecoration(
                              gradient: const LinearGradient(
                                begin: const Alignment(0.0, -1.0),
                                end: const Alignment(0.0, -0.4),
                                colors: const <Color>[
                                  const Color(0x00000000),
                                  const Color(0x00000000)
                                ],
                              ),
                            ),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              new Expanded(
                                flex: 1,
                                child: new Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 55.0,
                                    left: 0.0,
                                  ),
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        postsStream != null
                                            ? Expanded(
                                                child: StreamBuilder<
                                                        QuerySnapshot>(
                                                    stream: ss,
                                                    builder: (context, stream) {
                                                      QuerySnapshot?
                                                          querySnapshot =
                                                          stream.data;
                                                      var sdocs;
                                                      if (querySnapshot !=
                                                          null) {
                                                        sdocs =
                                                            querySnapshot.docs;
                                                      }
                                                      var cuEmail;
                                                      if (FirebaseAuth.instance
                                                              .currentUser !=
                                                          null) {
                                                        cuEmail = FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .email;
                                                      }
                                                      var nwImage;
                                                      if (sdocs != null) {
                                                        nwImage = sdocs!
                                                            .firstWhere(
                                                                (doc) =>
                                                                    doc.id ==
                                                                    cuEmail,
                                                                orElse: () =>
                                                                    null)
                                                            .data()['Image'];
                                                      }

                                                      return Container(
                                                          width: 200,
                                                          // height: 200,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      nwImage !=
                                                                              null
                                                                          ? nwImage
                                                                          : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu1MJH2FirQkjWkbALgTYqyPxtCf9Xu4Ct-xZSjqFMhUOFrfeBybHfQcXP6xnJmOaDQ9A&usqp=CAU'),
                                                                  fit: BoxFit
                                                                      .contain)));
                                                    }),
                                              )
                                            : Container(
                                                alignment: Alignment.center,
                                                child:
                                                    CircularProgressIndicator())
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              new Expanded(
                                flex: 3,
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new Padding(
                                        padding: const EdgeInsets.only(
                                          left: 30.0,
                                          bottom: 60,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              FirebaseAuth.instance.currentUser!
                                                  .displayName,
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 27.0),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            new Text(
                                              "NUS email: " +
                                                  FirebaseAuth.instance
                                                      .currentUser!.email,
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 200),
                                child: IconButton(
                                    icon: Icon(Icons.settings),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SettingPage(
                                                    title: 'SettingPage',
                                                  )));
                                    }),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    bottom: TabBar(
                        //isScrollable: true
                        //,
                        tabs: [Tab(text: "Posts"), Tab(text: "Joined Events")]),
                    //title: Text("My Profile"),
                  ),
                ),
              ];
            },
            body: TabBarView(
                // These are the contents of the tab views, below the tabs.
                children: [
                  myPosts(),
                  joinedEvents(),
                ])
            //SafeArea 适配刘海屏的一个widget

            ),
      ),
    );
  }

  joinedEvents() {
    var s;
    if (thispostsStream2 != null) {
      s = thispostsStream2!.snapshots();
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              thispostsStream != null
                  ? Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: s,
                          builder: (context, stream) {
                            QuerySnapshot? querySnapshot = stream.data;
                            var l;
                            if (querySnapshot != null) {
                              l = querySnapshot.docs
                                  .where((element) => element["acceptedPeople"]
                                      .keys
                                      .toString()
                                      .contains(FirebaseAuth
                                          .instance.currentUser!.uid))
                                  .toList();
                              // print("a");
                            }
                            //print(l);
                            var ic;
                            if (l != null) {
                              ic = l.length;
                            }
                            //print(ic);
                            //print(l);
                            return ListView.builder(
                                itemCount: ic,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var docsIndex;
                                  if (l != null) {
                                    docsIndex = l[index];
                                    return oneOfThePosts(
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
          );
        },
      ),
    );
  }

  myPosts() {
    var s;
    if (thispostsStream != null) {
      s = thispostsStream!.snapshots();
    }
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              thispostsStream != null
                  ? Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: s,
                          builder: (context, stream) {
                            QuerySnapshot? querySnapshot = stream.data;
                            //var l;
                            /* if (querySnapshot != null) {
                                  l = querySnapshot.docs.where((element) =>
                                      element["interestedPeople"].length == 0);
                                }*/
                            var ic;
                            if (querySnapshot != null) {
                              ic = querySnapshot.size;
                            }
                            //print(l);
                            return ListView.builder(
                                itemCount: ic,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var docsIndex;
                                  if (querySnapshot != null) {
                                    docsIndex = querySnapshot.docs[index];

                                    return oneOfThePosts(
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
          );
        },
      ),
    );
  }
}
