import 'package:flutter/cupertino.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/models/user.dart';
import 'package:insta/screens/shared/postcard.dart';
import 'package:insta/services/database/postdatabase.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class YourPostsDisplay extends StatefulWidget {
  @override
  _YourPostsDisplayState createState() => _YourPostsDisplayState();
}

class _YourPostsDisplayState extends State<YourPostsDisplay> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);

    PostDatabaseService _postdatabase = PostDatabaseService(uid: user.uid);

    // TODO: implement build
    return StreamBuilder<List<PostDetails>>(
        stream: _postdatabase.userPosts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.length != 0){
            List<PostDetails> entries = snapshot.data;
//           return Text('hello');

            return Container(
              height: MediaQuery.of(context).size.height / 2.3,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostCard(
                      entries[index].url,
                      user.uid,
                      entries[index].tag,
                      entries[index].docid,
                      entries[index].refid);
                },
              ),
            );}
            else{
              return Text(
                'No Posts Yet',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              );
            }
          } else {
            return Text(
              ''
            );
          }
        });
  }
}
