import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/message.dart';
import 'package:insta/models/contact.dart';

class MessageDatabaseService {
  String senderId;
  String receiverId;
  String uniqueId;

  MessageDatabaseService({this.senderId, this.receiverId});

  Future updateMessageData(String message, String time) async {
    uniqueId = senderId.compareTo(receiverId) == 1
        ? senderId + receiverId
        : receiverId + senderId;

    try {
      await FirebaseFirestore.instance
          .collection('contact$senderId')
          .doc(receiverId)
          .get()
          .then((doc) {
        if (!doc.exists) {
          FirebaseFirestore.instance
              .collection('contact$senderId')
              .doc(receiverId)
              .set({
            'id1': receiverId,
            'unseen': 0,
            'time': time,
          });
        }
      });
    } catch (e) {
      return false;
    }

    try {
      await FirebaseFirestore.instance
          .collection('contact$receiverId')
          .doc(senderId)
          .get()
          .then((doc) {
        if (!doc.exists) {
          FirebaseFirestore.instance
              .collection('contact$receiverId')
              .doc(senderId)
              .set({
            'id1': senderId,
            'unseen': 1,
            'time': time,
          });
        } else {
          FirebaseFirestore.instance
              .collection('contact$receiverId')
              .doc(senderId)
              .set({
            'id1': senderId,
            'unseen': doc.get('unseen') + 1,
            'time': time,
          });
        }
      });
    } catch (e) {
      return false;
    }

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(uniqueId).doc();
    return await documentReference.set({
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'time': time,
    });
  }

  deleteMessage(String id) async {
    uniqueId = senderId.compareTo(receiverId) == 1
        ? senderId + receiverId
        : receiverId + senderId;

    await FirebaseFirestore.instance.collection(uniqueId).doc(id).delete();
  }

  deleteUnseen() async {
    await FirebaseFirestore.instance
        .collection('contact$senderId')
        .doc(receiverId)
        .get()
        .then((doc) {
      if (doc.exists) {
        FirebaseFirestore.instance
            .collection('contact$senderId')
            .doc(receiverId)
            .update({
          'unseen': 0,
        });
      }
    });
  }

  List<Message> _messagesData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Message(
        senderId: doc.get('senderId') ?? '',
        recieverId: doc.get('receiverId') ?? '',
        time: doc.get('time'),
        docId: doc.id,
        message: doc.get('message'),
      );
    }).toList();
  }

  Stream<List<Message>> get chat {
    uniqueId = senderId.compareTo(receiverId) == 1
        ? senderId + receiverId
        : receiverId + senderId;

    CollectionReference msgcollection =
        FirebaseFirestore.instance.collection(uniqueId);
    return msgcollection.orderBy('time').snapshots().map(_messagesData);
  }

  List<Contact> _contactsData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Contact(
        id: doc.get('id1') ?? '',
        unseen: doc.get('unseen'),
      );
    }).toList();
  }

  Stream<List<Contact>> get contacts {
    return FirebaseFirestore.instance
        .collection('contact$senderId')
        .orderBy('time', descending: true)
        .snapshots()
        .map(_contactsData);
  }

  Stream<List<Contact>> get shouldNotify {
    return FirebaseFirestore.instance
        .collection('contact$senderId')
        .where('unseen', isGreaterThan: 0)
        .snapshots()
        .map(_contactsData);
  }
}
