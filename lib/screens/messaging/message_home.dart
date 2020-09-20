import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/contact.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/messaging/chat_screen.dart';
import 'package:insta/screens/messaging/messagingserch.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:provider/provider.dart';
import 'package:insta/services/database/Message_database.dart';

class MessageHome extends StatefulWidget {
  @override
  _MessageHomeState createState() => _MessageHomeState();
}

class _MessageHomeState extends State<MessageHome> {
  List<String> contacts = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);
    UserDatabaseService _userdatabaseService =
        UserDatabaseService(uid: user.uid);

    final bool dark = Provider.of<bool>(context);

    MessageDatabaseService _messageDatabaseService =
        MessageDatabaseService(senderId: user.uid, receiverId: '');

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
        backgroundColor: dark ? Color.fromARGB(255, 39, 39, 39) : Colors.white,
        title: Text(
          'Message',
          style: TextStyle(color: dark ? Colors.white : Colors.black),
        ),
        actions: [
          StreamBuilder<List<UserProfileWithUid>>(
              stream: _userdatabaseService.usersWithUid,
              builder: (context, snapshot) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    snapshot.data
                        .removeWhere((element) => element.uid == user.uid);
                    if (snapshot.hasData)
                      showSearch(
                          context: context,
                          delegate: MessageSearch(snapshot.data));
                  },
                );
              })
        ],
      ),
      body: StreamBuilder<List<Contact>>(
          stream: _messageDatabaseService.contacts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Contact> temp = snapshot.data;
              for (int i = 0; i < temp.length; i++) {
                if (contacts != null) {
                  if (!contacts.contains(temp[i].id)) contacts.add(temp[i].id);
                } else {
                  contacts.add(temp[i].id);
                }
              }
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  UserDatabaseService service =
                      UserDatabaseService(uid: contacts[index]);
                  return StreamBuilder<UserProfileWithUid>(
                      stream: service.userData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1.0, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                                uid: snapshot.data.uid,
                                              )));
                                },
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(snapshot.data.dpurl),
                                ),
                                title: Text(
                                  snapshot.data.name,
                                  style: TextStyle(
                                      color: dark ? Colors.white : Colors.black,
                                      fontFamily: 'kalam',
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return ListTile();
                        }
                      });
                },
              );
            } else {
              return Container();
            }
          }),
      floatingActionButton: StreamBuilder<List<UserProfileWithUid>>(
          stream: _userdatabaseService.usersWithUid,
          builder: (context, snapshot) {
            return FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 248, 90, 44),
              onPressed: () {
                if (snapshot.hasData)
                  showSearch(
                      context: context, delegate: MessageSearch(snapshot.data));
              },
              child: Icon(Icons.add),
            );
          }),
    );
  }
}
