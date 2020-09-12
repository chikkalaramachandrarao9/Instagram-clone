import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/usersearch.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:provider/provider.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);
    UserDatabaseService _databaseService = UserDatabaseService(uid: user.uid);

    // TODO: implement build
    return StreamBuilder<List<UserProfileWithUid>>(
        stream: _databaseService.usersWithUid,
        builder: (context, snapshot) {
          return Container(
            child: RaisedButton(
              child: Row(
                children: <Widget>[
                  Text('Search'),
                  Icon(Icons.search),
                ],
              ),
              onPressed: () {
                showSearch(
                    context: context, delegate: UserSearch(snapshot.data));
              },
            ),
          );
        });
  }
}
