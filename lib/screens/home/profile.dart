import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/screens/shared/posts_display.dart';
import 'package:insta/screens/shared/profile_head.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final String uid;

  Profile(this.uid);

  @override
  Widget build(BuildContext context) {
    bool dark = Provider.of<bool>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: dark ? Colors.white : Color.fromARGB(255, 248, 90, 44),
        ),
        elevation: 4.0,
        backgroundColor: dark ? Color.fromARGB(255, 39, 39, 39) : Colors.white,
      ),
      body: Container(
        color: dark
            ? Color.fromARGB(255, 18, 18, 18)
            : Color.fromARGB(255, 245, 246, 252),
        child: ListView(
          children: <Widget>[
            ProfileHead(
              uid: uid,
            ),
            PostsDisplay(uid),
          ],
        ),
      ),
    );
  }
}
