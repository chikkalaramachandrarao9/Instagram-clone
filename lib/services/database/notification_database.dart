import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/notification_model.dart';

class NotificationDatabaseService {
  String userId;
  String month, day, hour, minute, second, time;
  NotificationDatabaseService(this.userId);

  final CollectionReference notificationCollection =
      FirebaseFirestore.instance.collection('notifications');

  Future updateNotification(
      String notification, String triggerId, String type) async {
    DateTime dateTime = DateTime.now();

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
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('notifications')
        .doc('notif$userId')
        .collection('notif$userId')
        .doc();
    return await documentReference.set({
      'triggerid': triggerId,
      'notification': notification,
      'docId': documentReference.id,
      'time': time,
      'type': type,
    });
  }

  List<NotifModel> _notifData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return NotifModel(
          trigger: doc.get('triggerid') ?? '',
          notification: doc.get('notification') ?? '',
          type: doc.get('type') ?? '',
          docId: doc.id);
    }).toList();
  }

  Stream<List<NotifModel>> get notifications {
    return notificationCollection
        .doc('notif$userId')
        .collection('notif$userId')
        .orderBy('time', descending: true)
        .snapshots()
        .map(_notifData);
  }
}
