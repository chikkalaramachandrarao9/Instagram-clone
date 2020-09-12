import 'package:flutter/cupertino.dart';
import 'package:insta/screens/shared/posts_display.dart';
import 'package:insta/screens/shared/profile_head.dart';

class Profile extends StatelessWidget {
  final String uid;

  Profile(this.uid);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: <Widget>[
        ProfileHead(
          uid: uid,
        ),
        PostsDisplay(uid),
      ],
    );
  }
}
