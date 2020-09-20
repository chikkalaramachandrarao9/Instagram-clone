import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/Like.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/home/profile.dart';
import 'package:insta/services/database/likedatabase.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:provider/provider.dart';

class LikesPage extends StatefulWidget {
  final String postId;

  LikesPage({this.postId});

  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  List<Like> likers;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool dark = Provider.of<bool>(context);
    // TODO: implement build
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
          'Likes',
          style: TextStyle(
            color: dark ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: dark ? Color.fromARGB(255, 39, 39, 39) : Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height / 1.25,
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder<List<Like>>(
                  stream: LikeDatabaseService(widget.postId, '').likers,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      likers = snapshot.data;
                      return ListView.builder(
                          itemCount: likers.length,
                          itemBuilder: (BuildContext context, int index) {
                            return StreamBuilder<UserProfileWithUid>(
                                stream:
                                    UserDatabaseService(uid: likers[index].uid)
                                        .userData,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Profile(snapshot.data.uid),
                                            ));
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(snapshot.data.dpurl),
                                      ),
                                      title: Text(
                                        snapshot.data.name,
                                        style: TextStyle(
                                            color: dark
                                                ? Colors.white
                                                : Colors.black),
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
          ],
        ),
      ),
    );
  }
}
