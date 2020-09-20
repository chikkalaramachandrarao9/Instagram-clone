import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/message.dart';
import 'package:insta/models/user.dart';
import 'package:insta/models/userdetails.dart';
import 'package:insta/screens/messaging/message_view.dart';
import 'package:insta/services/database/Message_database.dart';
import 'package:insta/services/database/user_database.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String uid;

  ChatScreen({this.uid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController msgcntrl = TextEditingController();

  String month, time, day, hour, minute, second;

  final _controller = ScrollController();

  bool tmp;

  @override
  Widget build(BuildContext context) {
    UserDatabaseService userDatabaseService =
        UserDatabaseService(uid: widget.uid);

    List<Message> messageList;

    final bool dark = Provider.of<bool>(context);

    final user = Provider.of<UserDetails>(context);

    MessageDatabaseService _messageDatabaseservice =
        MessageDatabaseService(senderId: user.uid, receiverId: widget.uid);
    // TODO: implement build
    return Scaffold(
      backgroundColor: dark
          ? Color.fromARGB(255, 18, 18, 18)
          : Color.fromARGB(255, 245, 246, 252),
      appBar: AppBar(
        backgroundColor: dark ? Color.fromARGB(255, 39, 39, 39) : Colors.white,
        iconTheme: IconThemeData(
          color: dark ? Colors.white : Color.fromARGB(255, 248, 90, 44),
        ),
        title: StreamBuilder<UserProfileWithUid>(
            stream: userDatabaseService.userData,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DancingScript',
                      color: dark ? Colors.white : Colors.black,
                      fontSize: 15.0),
                );
              else
                return Text('');
            }),
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<List<Message>>(
                stream: _messageDatabaseservice.chat,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('yes');
                    messageList = snapshot.data;
                    return ListView.builder(
                      controller: _controller,
                      itemCount: messageList.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (user.uid == messageList[index].senderId) {
                          tmp = true;
                        } else {
                          tmp = false;
                        }
                        Timer(
                          Duration(milliseconds: 1),
                          () => _controller
                              .jumpTo(_controller.position.maxScrollExtent),
                        );
                        return MessageView(
                            messageList[index].message,
                            messageList[index].time,
                            tmp,
                            messageList[index].docId,
                            user.uid,
                            widget.uid);
                      },
                    );
                  } else {
                    print('no');
                    return Container();
                  }
                }),
          ),
          Divider(
            thickness: 1.0,
            height: 1.0,
            color: Colors.grey,
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60.0,
                    child: TextField(
                      controller: msgcntrl,
                      style: TextStyle(
                        color: dark ? Colors.white : Colors.black,
                        fontSize: 20.0,
                      ),
                      maxLines: 20,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(
                          color: dark ? Colors.white54 : Colors.black54,
                        ),
                        fillColor: dark
                            ? Color.fromARGB(255, 44, 44, 44)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 248, 90, 44),
        mini: true,
        child: Icon(
          Icons.send,
        ),
        onPressed: () async {
          DateTime dateTime = DateTime.now();

          if (msgcntrl.text.replaceAll(' ', '') != '') {
            String message = msgcntrl.text;
            msgcntrl.text = '';
            if (dateTime.month < 10)
              month = '0' + dateTime.month.toString();
            else
              month = dateTime.month.toString();
            if (dateTime.day < 10)
              day = '0' + dateTime.day.toString();
            else
              day = dateTime.day.toString();
            if (dateTime.hour < 10)
              hour = '0' + dateTime.hour.toString();
            else
              hour = dateTime.hour.toString();
            if (dateTime.minute < 10)
              minute = '0' + dateTime.minute.toString();
            else
              minute = dateTime.minute.toString();

            if (dateTime.second < 10)
              second = '0' + dateTime.second.toString();
            else
              second = dateTime.second.toString();

            time = dateTime.year.toString() +
                '/' +
                month +
                '/' +
                day +
                ' ' +
                hour +
                ':' +
                minute +
                ':' +
                second;
            await _messageDatabaseservice.updateMessageData(message, time);
          }
        },
      ),
    );
  }
}
