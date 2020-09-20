import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/comment.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/services/database/commentdatabase.dart';
import 'package:insta/services/database/notification_database.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postID;
  final String postOwner;
  final String tag;

  CommentScreen(this.postID, this.postOwner, this.tag);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comment> _commentlist;
  TextEditingController commentcntrl = TextEditingController();
  final _controller = ScrollController();
  bool dark;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final user = Provider.of<UserDetails>(context);
    CommentDatabaseService commentDatabaseService =
        CommentDatabaseService(widget.postID, user.uid);
    dark = Provider.of<bool>(context);

    UserProfileWithUid details;

    return Scaffold(
      backgroundColor: dark
          ? Color.fromARGB(255, 18, 18, 18)
          : Color.fromARGB(255, 245, 246, 252),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: dark ? Colors.white : Color.fromARGB(255, 248, 90, 44),
        ),
        elevation: 4.0,
        title: Text(
          'Comments',
          style: TextStyle(
            color: dark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: dark ? Color.fromARGB(255, 39, 39, 39) : Colors.white,
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<List<Comment>>(
                stream: commentDatabaseService.comments,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _commentlist = snapshot.data;

                    return ListView.builder(
                        controller: _controller,
                        itemCount: _commentlist.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          UserDatabaseService userDatabaseService =
                              UserDatabaseService(uid: _commentlist[index].uid);
                          Timer(
                            Duration(milliseconds: 1),
                            () => _controller
                                .jumpTo(_controller.position.maxScrollExtent),
                          );
                          return StreamBuilder<UserProfileWithUid>(
                              stream: userDatabaseService.userData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  details = snapshot.data;
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(details.dpurl),
                                    ),
                                    title: Text(
                                      details.name,
                                      style: TextStyle(
                                          color: dark
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    trailing:
                                        _commentlist[index].uid == user.uid
                                            ? IconButton(
                                                onPressed: () {
                                                  commentDatabaseService
                                                      .deleteComment(
                                                          _commentlist[index]
                                                              .docId);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Color.fromARGB(
                                                      255, 174, 215, 129),
                                                ),
                                              )
                                            : Text(''),
                                    subtitle: Text(
                                      _commentlist[index].comment,
                                      style: TextStyle(
                                          color: dark
                                              ? Colors.white54
                                              : Colors.black54),
                                    ),
                                  );
                                } else {
                                  return ListTile();
                                }
                              });
                        });
                  } else {
                    return Container();
                  }
                }),
          ),
          Divider(
            color: Colors.grey,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  height: 50.0,
                  child: TextField(
                    controller: commentcntrl,
                    style: TextStyle(color: dark ? Colors.white : Colors.black),
                    decoration: InputDecoration.collapsed(
                        hintStyle: TextStyle(
                          color: dark ? Colors.white54 : Colors.black54,
                        ),
                        fillColor: dark
                            ? Color.fromARGB(255, 44, 44, 44)
                            : Colors.white,
                        hintText: 'Write your comment here!'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        mini: true,
        onPressed: () async {
          if (commentcntrl.text.replaceAll(' ', '') != '') {
            await commentDatabaseService.updateCommentData(commentcntrl.text);
            String tag = widget.tag;
            await NotificationDatabaseService(widget.postOwner)
                .updateNotification(
                    'commented on your post $tag', user.uid, 'comment');
          }
          setState(() {
            commentcntrl.text = '';
          });
        },
        child: Icon(
          Icons.send,
          color: Color.fromARGB(255, 248, 90, 44),
        ),
      ),
    );
  }
}
