import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/follower.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/messaging/chat_screen.dart';
import 'package:insta/screens/shared/followers.dart';
import 'package:insta/screens/shared/following_page.dart';
import 'package:insta/screens/shared/loading.dart';
import 'package:insta/services/database/postdatabase.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:insta/services/database/follow_database.dart';
import 'package:provider/provider.dart';
import 'package:insta/services/database/notification_database.dart';

class ProfileHead extends StatefulWidget {
  final String uid;

  ProfileHead({this.uid});

  @override
  _ProfileHeadState createState() => _ProfileHeadState();
}

class _ProfileHeadState extends State<ProfileHead> {
  bool _isfollowing = false;
  bool dark;

  followerPage(String id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FollowersPage(id)));
  }

  followingPage(String id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FollowingPage(id)));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);
    dark = Provider.of<bool>(context);

    FollowerDatabaseService _followerdatabaseService =
        FollowerDatabaseService(user.uid, widget.uid);
    FollowerDatabaseService _userstatsService =
        FollowerDatabaseService.follow(widget.uid);
    PostDatabaseService postDatabaseService =
        PostDatabaseService(uid: widget.uid);

    List<Follower> doc;

    int noOfPosts = 0;
    int noOfFollowers = 0;
    int following = 0;

    // TODO: implement build
    return StreamBuilder<UserProfileWithUid>(
        stream: UserDatabaseService(uid: widget.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserProfileWithUid details = snapshot.data;
            return StreamBuilder<List<Follower>>(
                stream: _followerdatabaseService.isfollower,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    doc = snapshot.data;
                    print(doc);
                    if (doc.length != 0)
                      _isfollowing = true;
                    else
                      _isfollowing = false;
                  }
                  return Column(
                    children: <Widget>[
                      StreamBuilder<List<PostDetails>>(
                          stream: postDatabaseService.userPosts,
                          builder: (context, snapshot) {
                            if (snapshot.hasData)
                              noOfPosts = snapshot.data.length;
                            return Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      12.0, 15.0, 20.0, 12.0),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(details.dpurl),
                                    radius: 45.0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      20.0, 5.0, 20.0, 5.0),
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
                                              stream:
                                                  _userstatsService.followers,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData)
                                                  noOfFollowers =
                                                      snapshot.data.length;
                                                return InkWell(
                                                  onTap: () {
                                                    followerPage(widget.uid);
                                                  },
                                                  child: Text(
                                                      noOfFollowers.toString(),
                                                      style: TextStyle(
                                                          color: dark
                                                              ? Colors.white54
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30.0)),
                                                );
                                              }),
                                          SizedBox(
                                            width: 50.0,
                                          ),
                                          StreamBuilder<List<Follower>>(
                                              stream:
                                                  _userstatsService.following,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData)
                                                  following =
                                                      snapshot.data.length;
                                                return InkWell(
                                                  onTap: () {
                                                    followingPage(widget.uid);
                                                  },
                                                  child: Text(
                                                      following.toString(),
                                                      style: TextStyle(
                                                          color: dark
                                                              ? Colors.white54
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                            child: Text('Followers',
                                                style: TextStyle(
                                                    color: dark
                                                        ? Colors.white54
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0)),
                                            onTap: () {
                                              followerPage(widget.uid);
                                            },
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          InkWell(
                                            child: Text('Following',
                                                style: TextStyle(
                                                    color: dark
                                                        ? Colors.white54
                                                        : Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0)),
                                            onTap: () {
                                              followingPage(widget.uid);
                                            },
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
                      widget.uid != user.uid
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FlatButton(
                                  child: Text('Message'),
                                  color: Color.fromARGB(255, 248, 90, 44),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            uid: widget.uid,
                                          ),
                                        ));
                                  },
                                ),
                                Container(
                                  child: _isfollowing
                                      ? FlatButton(
                                          child: Text('Following'),
                                          color: Colors.grey[200],
                                          onPressed: () async {
                                            setState(() {
                                              _isfollowing = false;
                                            });
                                            _followerdatabaseService
                                                .deleteUser(doc[0].docid);
                                          },
                                        )
                                      : FlatButton(
                                          child: Text(
                                            'Follow',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color:
                                              Color.fromARGB(255, 248, 90, 44),
                                          onPressed: () async {
                                            setState(() {
                                              _isfollowing = true;
                                            });
                                            await _followerdatabaseService
                                                .updateUserData();
                                            await NotificationDatabaseService(
                                                    widget.uid)
                                                .updateNotification(
                                                    'started following you.',
                                                    user.uid,
                                                    'follow');
                                          },
                                        ),
                                ),
                              ],
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 25.0, 0, 15.0),
                        child: Container(
                          height: 2.0,
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return spinkit;
          }
        });
  }
}
