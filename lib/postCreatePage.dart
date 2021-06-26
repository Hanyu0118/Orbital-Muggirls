import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:my_app/services/crud.dart';
import 'package:random_string/random_string.dart';

class CreatePost extends StatefulWidget {
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late String ownerName, eventName, eventTime, eventDate, eventLocation, time;
  CrudMethods crudMethods = new CrudMethods();
  final picker = ImagePicker();
  File? selectedImage;
  bool isloading = false;
  Future getImage() async {
    Firebase.initializeApp();
    var pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadEvent() async {
    Firebase.initializeApp();
    if (selectedImage != null) {
      setState(() {
        isloading = true;
      });

      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("eventImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseStorageRef.putFile(selectedImage);

      var downloadUrl = await (await task).ref.getDownloadURL();
      print("this is url $downloadUrl");

      Map<String, String> eventMap = {
        "Event_Name": eventName,
        "Event_Image": downloadUrl,
        "Event_Location": eventLocation,
        "Event_Time": eventTime,
        "Event_Date": eventDate
      };

      crudMethods.addData(eventMap).then((result) {
        Navigator.pop(context);
      });
    } else {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Add a Post"),
            ],
          ),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  uploadEvent();
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.file_upload)))
          ]),
      body: isloading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: selectedImage != null
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              height: 200.0,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  )))
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 200.0,
                              decoration: BoxDecoration(
                                  color: Colors.amber[50],
                                  borderRadius: BorderRadius.circular(6)),
                              width: MediaQuery.of(context).size.width,
                              child:
                                  Icon(Icons.add_a_photo, color: Colors.amber),
                            )),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(hintText: "Event Name"),
                          onChanged: (val) {
                            eventName = val;
                          },
                        ),
                        TextField(
                          decoration:
                              InputDecoration(hintText: "Event Location"),
                          onChanged: (val) {
                            eventLocation = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Event Time"),
                          onChanged: (val) {
                            eventTime = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Event Date"),
                          onChanged: (val) {
                            eventDate = val;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
