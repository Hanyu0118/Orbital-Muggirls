import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/services/crud.dart';

class ConversationPage extends StatefulWidget {
  String chatroomId, userId;
  ConversationPage(this.chatroomId, this.userId);
  @override
  _ConversationPageState createState() => new _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  Query? postsStream, postsStream2;

  CrudMethods cm = new CrudMethods();
  TextEditingController messageController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    CrudMethods.getProfileImfo().then((result) {
      if (!mounted) {
        return;
      }
      setState(() {
        postsStream2 = result;
      });
    });
    cm.getConversationMessages(widget.chatroomId).then((result) {
      setState(() {
        postsStream = result;
      });
    });
  }

  Widget chatMessagesList() {
    var ss;
    if (postsStream != null) {
      ss = postsStream!.snapshots();
    }

    return StreamBuilder<QuerySnapshot>(
        stream: ss,
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
                  return MessagesTile(
                      docsIndex.data()["Message"],
                      docsIndex.data()["SendBy"] ==
                          FirebaseAuth.instance.currentUser!.uid);
                }
                return Container(
                  height: 10,
                );
              });
        });
  }

  sendMessages() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messagesMap = {
        "Message": messageController.text,
        "SendBy": FirebaseAuth.instance.currentUser!.uid,
        "Time": DateTime.now().millisecondsSinceEpoch
      };
      cm.addConversationMessages(widget.chatroomId, messagesMap);
      messageController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var ss;
    if (postsStream != null) {
      //print("haha");
      ss = postsStream2!.snapshots();
    }
    return Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          title: postsStream != null
              ? StreamBuilder<QuerySnapshot>(
                  stream: ss,
                  builder: (context, stream) {
                    QuerySnapshot? querySnapshot = stream.data;
                    var sdocs;
                    if (querySnapshot != null) {
                      sdocs = querySnapshot.docs;
                      //print(sdocs);
                    }

                    var nwName;
                    if (sdocs != null) {
                      nwName = sdocs!
                          .firstWhere(
                              (doc) => doc.data()['UserId'] == widget.userId,
                              orElse: () => null)
                          .data()['Name'];
                    }
                    if (nwName != null) {
                      return Text(nwName);
                    } else {
                      return Text("Chat");
                    }
                  })
              : Text("Chat"),
        ),
        body: Container(
          child: Stack(
            children: [
              chatMessagesList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.amber,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Messages ...", border: InputBorder.none),
                      )),
                      GestureDetector(
                        onTap: () {
                          sendMessages();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(1),
                          child: Icon(Icons.send),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}

class MessagesTile extends StatelessWidget {
  final String message;
  bool isSentByMe;
  MessagesTile(this.message, this.isSentByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: isSentByMe ? 0 : 24, right: isSentByMe ? 24 : 0),
        width: MediaQuery.of(context).size.width,
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
              borderRadius: isSentByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23))
                  : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23)),
              gradient: LinearGradient(
                colors: isSentByMe
                    ? [Color(0xFFFFD54F), Color(0xFFFFD54F)]
                    : [Color(0x99FFFFFF), Color(0x99FFFFFF)],
              )),
          child: Text(
            message,
            style: TextStyle(fontSize: 17),
          ),
        ));
  }
}
