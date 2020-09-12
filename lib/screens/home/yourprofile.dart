import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/screens/shared/yourprofilehead.dart';
import 'package:insta/screens/shared/yourpostsdisplay.dart';

class YourProfile extends StatefulWidget {
  @override
  _YourProfileState createState() => _YourProfileState();
}

class _YourProfileState extends State<YourProfile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        YourProfileHead(),
        YourPostsDisplay(),
      ],
    );
  }
}
