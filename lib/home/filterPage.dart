import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:my_app/home/resultPage.dart';

class SearchBarPage extends StatefulWidget {
  //String keyWord;
  //SearchBarPage(this.keyWord);

  @override
  State<StatefulWidget> createState() => new _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  late String eventName = "",
      eventTime = "",
      eventDate = "",
      eventLocation = "";
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Scope down"),
            ],
          ),
        ),
        body: Column(children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 0 // MediaQueryData.fromWindow(window).padding.top,
                  ),
              child: Container(
                color: Colors.amber[100],
                height: 70.0,
                child: new Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: new Card(
                        child: new Container(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 5.0,
                          ),
                          new Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: TextField(
                                onChanged: (val) {
                                  eventName = val;
                                },
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 0.0),
                                    hintText: 'Event Name',
                                    border: InputBorder.none),
                                // onChanged: onSearchTextChanged,
                              ),
                            ),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.cancel),
                            color: Colors.grey,
                            iconSize: 18.0,
                            onPressed: () {
                              controller.clear();
                              // onSearchTextChanged('');
                            },
                          ),
                        ],
                      ),
                    ))),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 0 // MediaQueryData.fromWindow(window).padding.top,
                  ),
              child: Container(
                color: Colors.amber[100],
                height: 70.0,
                child: new Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: new Card(
                        child: new Container(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 5.0,
                          ),
                          new Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: TextField(
                                onChanged: (val) {
                                  eventLocation = val;
                                },
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 0.0),
                                    hintText: 'Event Location',
                                    border: InputBorder.none),
                                // onChanged: onSearchTextChanged,
                              ),
                            ),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.cancel),
                            color: Colors.grey,
                            iconSize: 18.0,
                            onPressed: () {
                              controller.clear();
                              // onSearchTextChanged('');
                            },
                          ),
                        ],
                      ),
                    ))),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 0 // MediaQueryData.fromWindow(window).padding.top,
                  ),
              child: Container(
                color: Colors.amber[100],
                height: 70.0,
                child: new Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: new Card(
                        child: new Container(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 10.0,
                          ),
                          new Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: TextField(
                                onChanged: (val) {
                                  eventTime = val;
                                },
                                //controller: controller,
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 0.0),
                                    hintText: 'Event time (e.g. 17:00)',
                                    border: InputBorder.none),
                                // onChanged: onSearchTextChanged,
                              ),
                            ),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.cancel),
                            color: Colors.grey,
                            iconSize: 18.0,
                            onPressed: () {
                              controller.clear();
                              // onSearchTextChanged('');
                            },
                          ),
                        ],
                      ),
                    ))),
              ),
            ),
          ),
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 0 // MediaQueryData.fromWindow(window).padding.top,
                  ),
              child: Container(
                color: Colors.amber[100],
                height: 70.0,
                child: new Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: new Card(
                        child: new Container(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 10.0,
                          ),
                          new Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: TextField(
                                onChanged: (val) {
                                  eventDate = val;
                                },
                                //controller: controller,
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 0.0),
                                    hintText: 'Event Date (dd/mm/yyyy)',
                                    border: InputBorder.none),
                                // onChanged: onSearchTextChanged,
                              ),
                            ),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.cancel),
                            color: Colors.grey,
                            iconSize: 18.0,
                            onPressed: () {
                              controller.clear();
                              // onSearchTextChanged('');
                            },
                          ),
                        ],
                      ),
                    ))),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
              height: 50,
              color: Colors.amber,
              highlightColor: Colors.amber[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.black,
              child: Text("   Search!   ",
                  style: new TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  )),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new ResultPage(
                          eventName, eventLocation, eventTime, eventDate),
                    ));
              }),
        ]));
  }
}
