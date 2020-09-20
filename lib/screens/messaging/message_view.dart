import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/services/database/Message_database.dart';
import 'package:provider/provider.dart';

class MessageView extends StatefulWidget {
  final String message;
  final String time;
  final bool me;
  final String docId;
  final String senderId;
  final String recieverId;

  MessageView(this.message, this.time, this.me, this.docId, this.senderId,
      this.recieverId);

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final bool dark = Provider.of<bool>(context);
    // TODO: implement build
    return Align(
      alignment: widget.me ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onLongPress: () {
            setState(() {
              selected = true;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: dark
                    ? widget.me
                        ? selected ? Colors.blue[100] : Colors.grey[100]
                        : Colors.black
                    : widget.me
                        ? selected ? Colors.blue[100] : Colors.grey[200]
                        : Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.grey[200])),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 4.0),
              child: Column(
                children: [
                  selected
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                await MessageDatabaseService(
                                        senderId: widget.senderId,
                                        receiverId: widget.recieverId)
                                    .deleteMessage(widget.docId);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: dark ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  selected = false;
                                });
                              },
                            ),
                          ],
                        )
                      : Text(''),
                  Text(
                    widget.message,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: dark
                            ? widget.me ? Colors.black : Colors.white
                            : Colors.black),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(fontSize: 10.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
