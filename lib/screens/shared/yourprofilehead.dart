import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/home/about_me.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:provider/provider.dart';
import 'package:insta/screens/shared/loading.dart';

class YourProfileHead extends StatefulWidget {
  @override
  _YourProfileHeadState createState() => _YourProfileHeadState();
}

class _YourProfileHeadState extends State<YourProfileHead> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final user = Provider.of<UserDetails>(context);
    return StreamBuilder<UserProfileWithUid>(
        stream: UserDatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserProfileWithUid details = snapshot.data;
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(12.0, 15.0, 20.0, 12.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(details.dpurl),
                        radius: 45.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 5.0, 20.0, 5.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 15.0,
                              ),
                              Text('1',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0)),
                              SizedBox(
                                width: 55.0,
                              ),
                              Text('1',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0)),
                              SizedBox(
                                width: 55.0,
                              ),
                              Text('1',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0)),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: <Widget>[
                              Text('Posts',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0)),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Followers',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0)),
                              SizedBox(
                                width: 20.0,
                              ),
                              Text('Following',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0)),
                            ],
                          )
                        ],
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
                      details.name,
                      style: TextStyle(
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
                    child: Text('Edit Your Profile'),
                    color: Colors.grey[100],
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
                    color: Colors.grey[200],
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
