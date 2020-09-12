import 'package:flutter/material.dart';
import 'package:insta/screens/authenicate/authenicate.dart';
import 'package:insta/screens/home/home.dart';
import 'package:insta/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);
    print(user);

    // TODO: implement build
    if (user == null) {
      return AuthScreen();
    } else {
      return Home();
    }
  }
}
