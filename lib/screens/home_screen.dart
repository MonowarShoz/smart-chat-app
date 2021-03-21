import 'package:chat_smart_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  double _height;
  double _width;

  _HomeScreenState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 16),
        ),
        title:
            Container(alignment: Alignment.center, child: Text("Smart Chat")),
        bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            controller: _tabController,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.person_outline,
                  size: 25,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.people_outline,
                  size: 25,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.chat_bubble,
                  size: 25,
                ),
              )
            ]),
      ),
      body: _tabBarWidget(),
    );
  }

  Widget _tabBarWidget() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        
        ProfileScreen(_height,_width),
        ProfileScreen(_height,_width),
        ProfileScreen(_height,_width),
      ],
    );
  }
}
