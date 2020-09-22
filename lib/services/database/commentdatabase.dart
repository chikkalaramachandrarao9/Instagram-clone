import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/comment.dart';

class CommentDatabaseService {
  String postId;
  String userId;
  String month, day, hour, minute, second, time;
  CommentDatabaseService(this.postId, this.userId);

  final CollectionReference commentCollection =
      FirebaseFirestore.instance.collection('comments');

  Future updateCommentData(String comment) async {
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
        .collection('comments')
        .doc(postId)
        .collection('comments')
        .doc();
    return await documentReference.set({
      'userid': userId,
      'postid': postId,
      'comment': comment,
      'docId': documentReference.id,
      'time': time,
    });
  }

  deleteComment(String id) async {
    return await commentCollection.doc(id).delete();
  }

  List<Comment> _commentData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Comment(
          postId: doc.get('postid') ?? '',
          uid: doc.get('userid') ?? '',
          comment: doc.get('comment'),
          docId: doc.id);
    }).toList();
  }

  Stream<List<Comment>> get comments {
    return commentCollection
        .doc(postId)
        .collection('comments')
        .orderBy('time')
        .snapshots()
        .map(_commentData);
  }
}
