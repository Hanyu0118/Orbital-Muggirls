import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:my_app/Login/LoginPage2.dart';
import 'package:provider/provider.dart';
//import 'package:flutter/services.dart';
//import './loginPage.dart';

import 'home/homePage.dart';
import 'chat/chatPage.dart';
import 'profile/profilePage.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var loginPage = LoginPage2();
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: loginPage,
    );
  }
}

class FirstPage extends StatefulWidget {
  FirstPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _FirstPageState createState() => new _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      HomePage(
        title: 'HomePage',
      ),
      ChatPage(),
      ProfilePage(title: 'ProfilePage')
    ];

    final List<BottomNavigationBarItem> bottomNavItems = [
      BottomNavigationBarItem(
        backgroundColor: Colors.amber,
        icon: Icon(Icons.home),
        title: Text('home'),
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.amber,
        icon: Icon(Icons.message),
        title: Text('chat'),
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.amber,
        icon: Icon(Icons.person),
        title: Text('profile'),
      ),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: bottomNavItems,
        onTap: onTabTapped,
      ),
      body: _children[_currentIndex],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class Router {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}
