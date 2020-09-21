import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/screens/shared/postcard.dart';
import 'package:insta/services/database/postdatabase.dart';

class PostsDisplay extends StatefulWidget {
  final String uid;

  PostsDisplay(this.uid);

  @override
  _PostsDisplayState createState() => _PostsDisplayState();
}

class _PostsDisplayState extends State<PostsDisplay> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    PostDatabaseService _postdatabase = PostDatabaseService(uid: widget.uid);

    // TODO: implement build
    return StreamBuilder<List<PostDetails>>(
        stream: _postdatabase.userPosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PostDetails> entries = snapshot.data;

            for (int i = 0; i < entries.length; i++) {
              print(entries[i].url);
            }

            return Container(
              height: MediaQuery.of(context).size.height / 2.0,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostCard(
                      entries[index].url,
                      widget.uid,
                      entries[index].tag,
                      entries[index].docid,
                      entries[index].refid);
                },
              ),
            );
          } else {
            return Text(
              'No Posts Yet',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            );
          }
        });
  }
}
