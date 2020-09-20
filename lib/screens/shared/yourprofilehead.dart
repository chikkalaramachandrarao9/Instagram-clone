import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/follower.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/home/about_me.dart';
import 'package:insta/screens/shared/followers.dart';
import 'package:insta/screens/shared/following_page.dart';
import 'package:insta/services/database/follow_database.dart';
import 'package:insta/services/database/postdatabase.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:provider/provider.dart';
import 'package:insta/screens/shared/loading.dart';

class YourProfileHead extends StatefulWidget {
  @override
  _YourProfileHeadState createState() => _YourProfileHeadState();
}

class _YourProfileHeadState extends State<YourProfileHead> {
  bool dark;

  int noOfPosts = 0;
  int noOfFollowers = 0;
  int following = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final user = Provider.of<UserDetails>(context);
    FollowerDatabaseService _userstatsService =
        FollowerDatabaseService.follow(user.uid);
    PostDatabaseService postDatabaseService =
        PostDatabaseService(uid: user.uid);

    dark = Provider.of<bool>(context);

    return StreamBuilder<UserProfileWithUid>(
        stream: UserDatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserProfileWithUid details = snapshot.data;
            return Column(
              children: <Widget>[
                StreamBuilder<List<PostDetails>>(
                    stream: postDatabaseService.userPosts,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) noOfPosts = snapshot.data.length;
                      return Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12.0, 15.0, 20.0, 12.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(details.dpurl),
                              radius: 45.0,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(noOfPosts.toString(),
                                        style: TextStyle(
                                            color: dark
                                                ? Colors.white54
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30.0)),
                                    SizedBox(
                                      width: 50.0,
                                    ),
                                    StreamBuilder<List<Follower>>(
                                        stream: _userstatsService.followers,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData)
                                            noOfFollowers =
                                                snapshot.data.length;
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FollowersPage(
                                                            user.uid)),
                                              );
                                            },
                                            child: Text(
                                                noOfFollowers.toString(),
                                                style: TextStyle(
                                                    color: dark
                                                        ? Colors.white54
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30.0)),
                                          );
                                        }),
                                    SizedBox(
                                      width: 50.0,
                                    ),
                                    StreamBuilder<List<Follower>>(
                                        stream: _userstatsService.following,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData)
                                            following = snapshot.data.length;
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FollowingPage(
                                                            user.uid)),
                                              );
                                            },
                                            child: Text(following.toString(),
                                                style: TextStyle(
                                                    color: dark
                                                        ? Colors.white54
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30.0)),
                                          );
                                        }),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('Posts',
                                        style: TextStyle(
                                            color: dark
                                                ? Colors.white54
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0)),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowersPage(user.uid)),
                                        );
                                      },
                                      child: Text('Followers',
                                          style: TextStyle(
                                              color: dark
                                                  ? Colors.white54
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0)),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowingPage(user.uid)),
                                        );
                                      },
                                      child: Text('Following',
                                          style: TextStyle(
                                              color: dark
                                                  ? Colors.white54
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25.0,
                    ),
                    Text(
                      details.name,
                      style: TextStyle(
                        fontFamily: 'kalam',
                        color: dark ? Colors.white : Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25.0,
                    ),
                    Text(
                      details.aboutMe,
                      style: TextStyle(
                        color: dark ? Colors.white54 : Colors.black,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: FlatButton(
                    child: Text(
                      'Edit Your Profile',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Color.fromARGB(255, 254, 91, 3),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutMe()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25.0, 0, 15.0),
                  child: Container(
                    height: 2.0,
                    color: Color.fromARGB(255, 240, 143, 110),
                  ),
                ),
              ],
            );
          } else {
            return spinkit;
          }
        });
  }
}
