import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/follower.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/models/user.dart';
import 'package:insta/screens/shared/postcard.dart';
import 'package:insta/services/database/postdatabase.dart';
import 'package:provider/provider.dart';
import 'package:insta/services/database/follow_database.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final user = Provider.of<UserDetails>(context);

    PostDatabaseService _postdatabase = PostDatabaseService(uid: user.uid);

    FollowerDatabaseService _followdatabase =
        FollowerDatabaseService.follow(user.uid);

    // TODO: implement build
    return StreamBuilder<List<Follower>>(
        stream: _followdatabase.following,
        builder: (context, snapshot) {
          List<Follower> _followlist = snapshot.data;
          List<String> _following = [];

          List<PostDetails> entries = [];

          for (int i = 0; i < _followlist.length; i++) {
            _following.add(_followlist[i].following);
          }

          return Container(
            height: MediaQuery.of(context).size.height / 1.3,
            child: StreamBuilder<List<PostDetails>>(
                stream: _postdatabase.posts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<PostDetails> allposts = snapshot.data;

                    for (int i = 0; i < allposts.length; i++) {
                      if (_following.indexWhere((element) =>
                              element.startsWith(allposts[i].uid)) !=
                          -1) {
                        entries.add(allposts[i]);
                      }
                    }
                    entries.shuffle();

//            return Text('hello');

                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: entries.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PostCard(entries[index].url, entries[index].uid,
                            entries[index].tag, entries[index].docid);
                      },
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
                }),
          );
        });
  }
}

//                      addAutomaticKeepAlives: false,
//                      addRepaintBoundaries: false,
//                      addSemanticIndexes: false,
//                      shrinkWrap: true,
