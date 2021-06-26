import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'LoginPage2.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SettingPageState createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Settings"),
          ],
        ),
      ),
      body: FlatButton(
        onPressed: () {
          ApplicationState().signOut();
        },
        child: Text(
          "Logout",
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
