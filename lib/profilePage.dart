import 'package:flutter/material.dart';
import 'package:my_app/settingPage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ProfilePageState createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var _tabs = <String>[];
    _tabs = <String>[
      "Posts",
      "Joined Posts",
      //"Tab 3",
    ];

    return Scaffold(
      body: DefaultTabController(
        length: _tabs.length, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  floating: false,
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
                            new Expanded(
                              flex: 1,
                              child: new Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 60.0,
                                  left: 30.0,
                                ),
                                child: new CircleAvatar(
                                  radius: 38.0,
                                  backgroundImage:
                                      AssetImage('images/pikachu.jpeg'),
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
                                            'Name',
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 35.0),
                                          ),
                                          new Text(
                                            'NUS id:e1234567',
                                            style: new TextStyle(
                                                color: Colors.white,
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
                    //isScrollable: true,
                    tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            // These are the contents of the tab views, below the tabs.
            children: _tabs.map((String name) {
              //SafeArea 适配刘海屏的一个widget
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.all(0.0),
                          sliver: SliverFixedExtentList(
                            itemExtent: 500.0,
                            //item高度或宽度，取决于滑动方向
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ListView(children: [
                                  FlatButton(
                                    onPressed: () {
                                      print("按钮被点击了");
                                    },
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.center,
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Image.asset(
                                            'images/pikachu.jpeg',
                                            width: 150,
                                            height: 150,
                                          ),
                                          color: Colors.amber.shade50,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Event name"),
                                              Text("Event location"),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 60),
                                              //child: Text("19:0001/01/2021"),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("19:00"),
                                                  Text("06/06/21"),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: FlatButton(
                                                onPressed: () {
                                                  print("profile按钮被点击了");
                                                },
                                                minWidth: 50,
                                                height: 30,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
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
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      print("按钮被点击了");
                                    },
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.center,
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Image.asset(
                                            'images/pikachu.jpeg',
                                            width: 150,
                                            height: 150,
                                          ),
                                          color: Colors.amber.shade50,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Event name"),
                                              Text("Event location"),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 60),
                                              //child: Text("19:0001/01/2021"),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("19:00"),
                                                  Text("06/06/21"),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: FlatButton(
                                                onPressed: () {
                                                  print("profile按钮被点击了");
                                                },
                                                minWidth: 50,
                                                height: 30,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
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
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      print("按钮被点击了");
                                    },
                                    child: Row(
                                      //crossAxisAlignment: CrossAxisAlignment.center,
                                      //mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Image.asset(
                                            'images/pikachu.jpeg',
                                            width: 150,
                                            height: 150,
                                          ),
                                          color: Colors.amber.shade50,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("Event name"),
                                              Text("Event location"),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 0, 0, 60),
                                              //child: Text("19:0001/01/2021"),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("19:00"),
                                                  Text("06/06/21"),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 0.0),
                                              child: FlatButton(
                                                onPressed: () {
                                                  print("profile按钮被点击了");
                                                },
                                                minWidth: 50,
                                                height: 30,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
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
                                  ),
                                ]);
                              },
                              childCount: 1,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
