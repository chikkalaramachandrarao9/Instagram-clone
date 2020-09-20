import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/notification_model.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/services/database/notification_database.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotifModel> _list;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);
    bool dark = Provider.of<bool>(context);

    NotificationDatabaseService _notifDatabaseService =
        NotificationDatabaseService(user.uid);

    // TODO: implement build
    return StreamBuilder<List<NotifModel>>(
        stream: _notifDatabaseService.notifications,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _list = snapshot.data;
            print(snapshot.data);
            return Container(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Column(
                children: [
                  Flexible(
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 1.0,
                            color: Colors.grey,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return StreamBuilder<UserProfileWithUid>(
                              stream:
                                  UserDatabaseService(uid: _list[index].trigger)
                                      .userData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data.name +
                                          ' ' +
                                          _list[index].notification,
                                      style: TextStyle(
                                          fontSize: 17.0,
                                          color: dark
                                              ? Color.fromARGB(
                                                  255, 142, 197, 233)
                                              : Colors.black,
                                          fontFamily: 'kalam'),
                                    ),
                                  );
                                } else {
                                  return Text(
                                    _list[index].notification,
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        color: dark
                                            ? Color.fromARGB(255, 142, 197, 233)
                                            : Colors.black,
                                        fontFamily: 'kalam'),
                                  );
                                }
                              });
                        },
                        itemCount: _list.length),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Container(
                child: Text(
                  'No Notifications',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            );
          }
        });
  }
}
