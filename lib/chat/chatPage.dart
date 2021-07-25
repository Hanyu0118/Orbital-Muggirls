import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/chat/conversationPage.dart';
import 'package:my_app/services/crud.dart';
import 'NotificationPage.dart';

class ChatPage extends StatefulWidget {
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  CrudMethods cm = CrudMethods();
  Query? postsStream;

  @override
  void initState() {
    super.initState();
    cm.getChatRooms(FirebaseAuth.instance.currentUser!.uid).then((result) {
      setState(() {
        postsStream = result.where("users",
            arrayContains: FirebaseAuth.instance.currentUser!.uid);
        //print("DOne");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var s;

    if (postsStream != null) {
      s = postsStream!.snapshots();
    }
    var scaffold = Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          backgroundColor: Colors.amber,
          //toolbarHeight: 150,
          title: Text("Messages"),
          actions: <Widget>[
            /* IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })*/
          ],
        ),
        body: Column(children: [
          OutlineButton(
              borderSide: BorderSide(color: Colors.amber, width: 0.8),
              color: Colors.amber,
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new Notifications()));
              },
              child: Container(
                height: 70,
                child: Row(
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 2, top: 15, bottom: 15),
                        width: 50,
                        height: 50,
                        child: ClipOval(
                          child: Image.asset(
                            'images/Messages_logo.jpeg',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )

                        /* decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage('images/pikachu.jpeg'),
                              //'https://www.online-tech-tips.com/wp-content/uploads/2020/09/Google_Messages_logo.png'),
                              fit: BoxFit.contain))*/
                        ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Notifications",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              )),
          StreamBuilder<QuerySnapshot>(
              stream: s,
              builder: (context, stream) {
                QuerySnapshot? querySnapshot = stream.data;
                //print(querySnapshot);
                var ic;
                if (querySnapshot != null) {
                  ic = querySnapshot.size;
                  //print(ic);
                }
                return Expanded(
                    //height: 500,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: ic,
                        itemBuilder: (context, index) {
                          //print(ic);
                          var docsIndex;
                          if (querySnapshot != null) {
                            docsIndex = querySnapshot.docs[index];
                            String userName = docsIndex
                                .data()["chatroomId"]
                                .toString()
                                .replaceAll("_", "")
                                .replaceAll(
                                    FirebaseAuth.instance.currentUser!.uid, "");
                            String chatroomId =
                                docsIndex.data()["chatroomId"].toString();
                            //print(userName);
                            return ChatRoomTitle(userName, chatroomId);
                          }
                          return Container(height: 40);
                        }));
              })
        ]));

    return scaffold;
  }
}

class ChatRoomTitle extends StatefulWidget {
  String userName, chatroomId;
  ChatRoomTitle(this.userName, this.chatroomId);

  @override
  State<ChatRoomTitle> createState() => _ChatRoomTitleState();
}

class _ChatRoomTitleState extends State<ChatRoomTitle> {
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
      //print("haha");
      ss = postsStream!.snapshots();
    }
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ConversationPage(widget.chatroomId, widget.userName)));
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              //                   <--- left side
              color: Colors.amber,
            ),
          )),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: postsStream != null
              ? StreamBuilder<QuerySnapshot>(
                  stream: ss,
                  builder: (context, stream) {
                    QuerySnapshot? querySnapshot = stream.data;
                    var sdocs;
                    if (querySnapshot != null) {
                      sdocs = querySnapshot.docs;
                      //print(sdocs);
                    }

                    var nwImage;
                    var nwName;
                    if (sdocs != null) {
                      nwImage = sdocs!
                          .firstWhere(
                              (doc) => doc.data()['UserId'] == widget.userName,
                              orElse: () => null)
                          .data()['Image'];
                      nwName = sdocs!
                          .firstWhere(
                              (doc) => doc.data()['UserId'] == widget.userName,
                              orElse: () => null)
                          .data()['Name'];
                    }

                    return Row(children: [
                      Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.amber[200],
                              borderRadius: BorderRadius.circular(40)),
                          child: Image(
                            fit: BoxFit.fill,
                            image: NetworkImage(nwImage != null
                                ? nwImage
                                : 'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                          )),
                      SizedBox(width: 8),
                      Text(
                        nwName != null ? nwName : "No Name",
                        style: TextStyle(fontSize: 17),
                      )
                    ]);
                  })
              : Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator()),
        ));
  }
}
