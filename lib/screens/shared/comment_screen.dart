import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/comment.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/services/database/commentdatabase.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postID;

  CommentScreen(this.postID);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<Comment> _commentlist;
  TextEditingController commentcntrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final user = Provider.of<UserDetails>(context);
    CommentDatabaseService commentDatabaseService =
        CommentDatabaseService(widget.postID, user.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
    );
  }
}
