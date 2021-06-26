import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_app/postCreatePage.dart';
import 'package:my_app/services/crud.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();
  get mainAxisAlignment => null;
  late Query postsStream;

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
    return Container(
      child: Column(
        children: <Widget>[
          postsStream != null
              ? Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: postsStream.snapshots(),
                      builder: (context, stream) {
                        QuerySnapshot? querySnapshot = stream.data;
                        return ListView.builder(
                            itemCount: querySnapshot!.size,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return oneOfThePosts(
                                  imgUrl: querySnapshot.docs[index]
                                      .data()['Event_Image'],
                                  eventName: querySnapshot.docs[index]
                                      .data()["Event_Name"],
                                  eventLocation: querySnapshot.docs[index]
                                      .data()['Event_Location'],
                                  eventTime: querySnapshot.docs[index]
                                      .data()['Event_Time'],
                                  eventDate: querySnapshot.docs[index]
                                      .get('Event_Date'));
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
                  Navigator.of(context).pop();
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

class oneOfThePosts extends StatelessWidget {
  String imgUrl, eventName, eventLocation, eventTime, eventDate;
  oneOfThePosts(
      {required this.imgUrl,
      required this.eventName,
      required this.eventLocation,
      required this.eventTime,
      required this.eventDate});

  Widget build(BuildContext context) {
    return Container(
        height: 150,
        margin: EdgeInsets.fromLTRB(5, 2.5, 5, 2.5),
        child: FlatButton(
          color: Colors.white,
          height: 140,
          onPressed: () {
            print("button click");
          },
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Container(
                      height: 140,
                      child: Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                      ))),

              //color: Colors.amber.shade50,

              Container(
                height: 150,
                width: 130,
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 130,
                      height: 15,
                    ),
                    Wrap(
                      spacing: 2,
                      runSpacing: 5,
                      children: [
                        Text(
                          eventName,
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
                          eventLocation,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 60),
                    //child: Text("19:0001/01/2021"),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(eventTime),
                        Text(eventDate),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: FlatButton(
                      onPressed: () {
                        print("profile按钮被点击了");
                      },
                      minWidth: 50,
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ClipOval(
                            child: Image.asset(
                              'images/pikachu.jpeg',
                              width: 15,
                              height: 15,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text("Name"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
