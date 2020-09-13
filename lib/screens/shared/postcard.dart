import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/Like.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/shared/comment_screen.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:insta/services/database/likedatabase.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final String picurl;
  final String uid;
  final String tag;
  final String postId;

  PostCard(this.picurl, this.uid, this.tag, this.postId);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    UserDatabaseService _userdatabaseService =
        UserDatabaseService(uid: widget.uid);
    final user = Provider.of<UserDetails>(context);
    LikeDatabaseService _likedatabaseService =
        LikeDatabaseService(widget.postId, user.uid);

    List<Like> temp;
    int likes = 0;

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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontFamily: 'kalam'),
                        )
                      ],
                    ),
                    IconButton(
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
              StreamBuilder<List<Like>>(
                  stream: _likedatabaseService.isliked,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      temp = snapshot.data;
                      if (temp.length != 0) {
                        isLiked = true;
                      } else {
                        isLiked = false;
                      }
                    }
                    return Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.0, 16.0, 8.0, 16.0),
                          child: isLiked
                              ? IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLiked = false;
                                    });
                                    await _likedatabaseService
                                        .deleteLike(temp[0].docId);
                                  },
                                  icon: Icon(Icons.favorite),
                                  color: Colors.pinkAccent,
                                  iconSize: 30.0,
                                )
                              : IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLiked = true;
                                    });
                                    await _likedatabaseService.updateLikeData();
                                  },
                                  icon: Icon(Icons.favorite_border),
                                  color: Colors.pinkAccent,
                                  iconSize: 30.0,
                                ),
                        ),
                        StreamBuilder<List<Like>>(
                            stream: _likedatabaseService.noOfLikes,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                likes = snapshot.data.length;
                              }
                              return Text(likes.toString());
                            }),
                        SizedBox(
                          width: 100.0,
                        ),
                        FlatButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CommentScreen(widget.postId)),
                              );
                            },
                            icon: Icon(Icons.message),
                            label: Text('Comment'))
                      ],
                    );
                  })
            ],
          );
        });
  }
}
