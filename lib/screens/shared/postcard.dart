import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/Like.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/shared/comment_screen.dart';
import 'package:insta/screens/shared/likes.dart';
import 'package:insta/screens/shared/loading.dart';
import 'package:insta/services/database/notification_database.dart';
import 'package:insta/services/database/postdatabase.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:insta/services/database/likedatabase.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final String picurl;
  final String uid;
  final String tag;
  final String postId;
  final String refId;
  PostCard(this.picurl, this.uid, this.tag, this.postId, this.refId);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool dark;
  bool isLiked = false;
  bool selected = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    UserDatabaseService _userdatabaseService =
        UserDatabaseService(uid: widget.uid);
    final user = Provider.of<UserDetails>(context);
    LikeDatabaseService _likedatabaseService =
        LikeDatabaseService(widget.postId, user.uid);
    UserProfileWithUid details;

    dark = Provider.of<bool>(context);
    List<Like> temp;
    int likes = 0;

    // TODO: implement build
    return loading
        ? spinkit3
        : Card(
            color: dark ? Color.fromARGB(255, 18, 18, 18) : Colors.white,
            elevation: dark ? 0.0 : 4.0,
            shadowColor: Colors.grey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StreamBuilder<UserProfileWithUid>(
                          stream: _userdatabaseService.userData,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              details = snapshot.data;
                              return Row(
                                children: <Widget>[
                                  Container(
                                    height: 40.0,
                                    width: 40.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: details.dpurl != null
                                            ? NetworkImage(details.dpurl)
                                            : Image.asset('images/logo.jpg'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    details.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'kalam',
                                      color: dark ? Colors.white : Colors.black,
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  SizedBox(
                                    height: 50.0,
                                  )
                                ],
                              );
                            }
                          }),
                      !selected
                          ? IconButton(
                              icon: Icon(Icons.more_vert),
                              color: dark ? Colors.white : Colors.black,
                              onPressed: () {
                                if (widget.uid == user.uid) {
                                  setState(() {
                                    selected = true;
                                  });
                                }
                              },
                            )
                          : IconButton(
                              icon: Icon(Icons.delete),
                              color: dark ? Colors.white : Colors.black,
                              onPressed: () async {
                                setState(() {
                                  selected = false;
                                  loading = true;
                                });

                                await PostDatabaseService(uid: user.uid)
                                    .deletePost(widget.refId);
                              },
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                  child: GestureDetector(
                    onDoubleTap: () async {
                      if (!isLiked) {
                        setState(() {
                          isLiked = true;
                        });
                        await _likedatabaseService.updateLikeData();
                        String tag = widget.tag;
                        await NotificationDatabaseService(widget.uid)
                            .updateNotification(
                                'liked your post $tag', user.uid, 'like');
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 350.0,
                      child: Image.network(
                        widget.picurl,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.tag,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: dark ? Colors.white : Colors.black),
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
                            padding: EdgeInsets.fromLTRB(20.0, 10.0, 8.0, 10.0),
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
                                      await _likedatabaseService
                                          .updateLikeData();
                                      String tag = widget.tag;
                                      await NotificationDatabaseService(
                                              widget.uid)
                                          .updateNotification(
                                              'liked your post $tag',
                                              user.uid,
                                              'like');
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
                                return InkWell(
                                  child: Text(
                                    likes.toString(),
                                    style: TextStyle(
                                      color: dark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LikesPage(postId: widget.postId),
                                        ));
                                  },
                                );
                              }),
                          SizedBox(
                            width: 100.0,
                          ),
                          FlatButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommentScreen(
                                          widget.postId,
                                          widget.uid,
                                          widget.tag)),
                                );
                              },
                              icon: Icon(
                                Icons.message,
                                color: dark ? Colors.white : Colors.black,
                              ),
                              label: Text(
                                'Comment',
                                style: TextStyle(
                                  color: dark ? Colors.white : Colors.black,
                                ),
                              ))
                        ],
                      );
                    })
              ],
            ),
          );
  }
}
