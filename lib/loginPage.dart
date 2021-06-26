import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  late String _userID;
  late String _password;
  bool _isChecked = true;
  IconData _checkIcon = Icons.check_box;

//  void _changeFormToLogin() {
//    _formKey.currentState.reset();
//  }

  void _onLogin() {
    final form = _formKey.currentState;
    form!.save();

    if (_userID == '') {
      _showMessageDialog('Email adress cannot be empty!');
      return;
    }
    if (_password == '') {
      _showMessageDialog('Password can not be empty!');
      return;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(
              builder: (context) => new FirstPage(
                    title: 'HomePage',
                  )), (route) {
        var other;
        return route == other;
      });
    }
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Warning'),
          content: new Text(message),
          actions: <Widget>[
            new TextButton(
              child: new Text("ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showEmailInput() {
    Padding padding2;
    padding2 = Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter your NUS email address',
            icon: new Icon(
              Icons.email,
              color: Colors.grey,
            )),
        onSaved: (value) => _userID = value!.trim(),
      ),
    );
    return padding2;
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(fontSize: 15),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        onSaved: (value) => _password = value!.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          middle: const Text('Login'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 30),
              height: 220,
              child: new Center(
                child: new Image.asset('images/pikachu.jpeg'),
              ),
            ),
            Form(
              key: _formKey,
              child: Container(
                height: 122,
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      _showEmailInput(),
                      Divider(
                        height: 0.5,
                        indent: 16.0,
                        color: Colors.grey[300],
                      ),
                      _showPasswordInput(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(35, 30, 35, 5),
              // ignore: deprecated_member_use
              child: new OutlineButton(
                child: Text('Login'),
                textColor: Colors.orange,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                borderSide: BorderSide(color: Colors.amber, width: 2),
                onPressed: () {
                  _onLogin();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 50, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: Icon(_checkIcon),
                      color: Colors.orange,
                      onPressed: () {
                        setState(() {
                          _isChecked = !_isChecked;
                          if (_isChecked) {
                            _checkIcon = Icons.check_box;
                          } else {
                            _checkIcon = Icons.check_box_outline_blank;
                          }
                        });
                      }),
                  Expanded(
                    child: RichText(
                        text: TextSpan(
                            text: 'I have read and agree to',
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            children: <TextSpan>[
                          TextSpan(
                              text: ' Privacy Policy',
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline)),
                          TextSpan(text: ' and '),
                          TextSpan(
                              text: 'User Agreement',
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline))
                        ])),
                  )
                ],
              ),
            )
          ],
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty("_password", _password));
  }
}
