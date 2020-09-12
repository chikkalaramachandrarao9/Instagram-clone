import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/services/database/user_database.dart';

class PostCard extends StatefulWidget {
  final String picurl;
  final String uid;
  final String tag;

  PostCard(this.picurl, this.uid, this.tag);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    UserDatabaseService _userdatabaseService =
        UserDatabaseService(uid: widget.uid);

    // TODO: implement build
    return StreamBuilder<UserProfileWithUid>(
        stream: _userdatabaseService.userData,
        builder: (context, snapshot) {
          UserProfileWithUid user = snapshot.data;
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(user.dpurl)),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          user.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    new IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: null,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                child: Image.network(widget.picurl),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.tag,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 16.0, 8.0, 16.0),
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.pinkAccent,
                  size: 30.0,
                ),
              )
            ],
          );
        });
  }
}
