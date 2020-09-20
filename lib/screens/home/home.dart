import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/home/notification_screen.dart';
import 'package:insta/screens/home/post.dart';
import 'package:insta/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:insta/screens/home/userfeed.dart';
import 'package:insta/screens/home/search.dart';
import 'package:insta/screens/home/yourprofile.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'dart:math';
import 'about_me.dart';
import 'package:insta/screens/messaging/message_home.dart';
import 'package:insta/services/darktheme.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool dark;
  final _auth = AuthService();

  UserProfileWithUid details;

  int _page = 0;

  List<String> _titles = ['Flicks', ' ', 'Post', 'Notifications', 'Me'];

  List<Widget> _list = [
    Feed(),
    Search(),
    Post(),
    NotificationScreen(),
    YourProfile()
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);

    dark = Provider.of<bool>(context);

    UserDatabaseService _userDatabaseService =
        UserDatabaseService(uid: user.uid);

    // TODO: implement build
    return Scaffold(
      backgroundColor: dark
          ? Color.fromARGB(255, 18, 18, 18)
          : Color.fromARGB(255, 245, 246, 252),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: dark ? Colors.white : Color.fromARGB(255, 248, 90, 44),
        ),
        elevation: 4.0,
        backgroundColor: dark ? Color.fromARGB(255, 39, 39, 39) : Colors.white,
        title: Text(
          _titles[_page],
          style: TextStyle(
            color: dark ? Colors.white : Colors.black,
            fontFamily: 'DancingScript',
            fontSize: 30.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 8.0),
            child: FlatButton.icon(
              icon: Transform.rotate(
                angle: 325 * pi / 180,
                child: Icon(
                  Icons.send,
                  color: dark ? Colors.white : Color.fromARGB(255, 248, 90, 44),
                  size: 30.0,
                ),
              ),
              color: dark ? Color.fromARGB(255, 39, 39, 39) : Colors.white,
              label: Text(' '),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessageHome()));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(child: _list[_page]),
      drawer: Drawer(
        child: Container(
          color: dark ? Color.fromARGB(255, 23, 36, 44) : Colors.white,
          child: Column(
            children: [
              StreamBuilder<UserProfileWithUid>(
                  stream: _userDatabaseService.userData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      details = snapshot.data;
                      return Container(
                        color: dark
                            ? Color.fromARGB(255, 133, 185, 238)
                            : Color.fromARGB(255, 248, 90, 44),
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 25.0, 5.0, 15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutMe()),
                              );
                            },
                            child: Column(
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    radius: 45.0,
                                    backgroundImage:
                                        NetworkImage(details.dpurl),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Center(
                                  child: Text(
                                    details.name,
                                    style: TextStyle(
                                      fontFamily: 'DancingScript',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        color: dark
                            ? Color.fromARGB(255, 133, 185, 238)
                            : Colors.limeAccent[100],
                      );
                    }
                  }),
              Divider(
                thickness: 5.0,
                height: 1.0,
              ),
              SwitchListTile(
                title: Text(
                  'Theme',
                  style: TextStyle(
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
                onChanged: (bool value) async {
                  bool currentValue =
                      MyAppSettings(await StreamingSharedPreferences.instance)
                          .darkMode
                          .getValue();
                  StreamingSharedPreferences settings =
                      await StreamingSharedPreferences.instance;
                  settings.setBool('darkMode', !currentValue);
                },
                inactiveTrackColor: Colors.black,
                value: dark ? true : false,
                activeColor: Colors.white,
              ),
              Container(
                child: GestureDetector(
                  onTap: () async {
                    await _auth.signOut();
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: dark ? Colors.white : Colors.black,
                    ),
                    title: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _page,
        height: 60.0,
        backgroundColor: dark
            ? Color.fromARGB(255, 18, 18, 18)
            : Color.fromARGB(255, 245, 246, 252),
        color: dark ? Color.fromARGB(255, 39, 39, 39) : Colors.white,
        items: <Widget>[
          Icon(
            Icons.dashboard,
            size: 30,
            color: dark ? Colors.white : Color.fromARGB(255, 248, 90, 44),
          ),
          Icon(
            Icons.search,
            size: 30,
            color: dark ? Colors.white : Color.fromARGB(255, 248, 90, 44),
          ),
          Icon(
            Icons.add,
            size: 30,
            color: dark ? Colors.white : Color.fromARGB(255, 248, 90, 44),
          ),
          Icon(
            Icons.notifications,
            size: 30,
            color: dark ? Colors.white : Color.fromARGB(255, 248, 90, 44),
          ),
          Icon(
            Icons.perm_identity,
            size: 30,
            color: dark ? Colors.white : Color.fromARGB(255, 248, 90, 44),
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
    );
  }
}
