import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/home/post.dart';
import 'package:insta/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:insta/screens/home/userfeed.dart';
import 'package:insta/screens/home/search.dart';
import 'package:insta/screens/home/yourprofile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = AuthService();

  int _page = 0;

  List<String> titles = [
    "Instagram",
    "Search",
    "Post",
    "Your Profile",
  ];

  List<Widget> _list = [Feed(), Search(), Post(), YourProfile()];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamProvider<List<UserProfile>>.value(
      value: UserDatabaseService().users,
      child: Scaffold(
        appBar: AppBar(
//          backgroundColor: Colors.pinkAccent,
          backgroundColor: Colors.white,
          title: Text(
            titles[_page],
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton.icon(
                icon: Icon(Icons.exit_to_app),
//                color: Colors.pinkAccent[200],
                color: Colors.white,
                label: Text(' '),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(child: _list[_page]),
        bottomNavigationBar: CurvedNavigationBar(
          index: _page,
          backgroundColor: Colors.white,
//          color: Colors.pinkAccent,
          color: Colors.white,
          items: <Widget>[
            Icon(
              Icons.dashboard,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.perm_identity,
              size: 30,
              color: Colors.white,
            ),
          ],
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 200),
          onTap: (index) {
            //Handle button tap
            setState(() {
              _page = index;
            });
          },
        ),
      ),
    );
  }
}