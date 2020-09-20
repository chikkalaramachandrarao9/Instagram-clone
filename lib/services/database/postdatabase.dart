import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/post_model.dart';

class PostDatabaseService {
  final String uid;
  PostDatabaseService({this.uid});

  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  String time, month, day, minute, second, hour;

  Future updatePostData(String tag, String url) async {
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

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('posts').doc();
    return await documentReference.set({
      'uid': uid,
      'tag': tag,
      'url': url,
      'postId': documentReference.id,
      'time': time,
    });
  }

  deletePost(String id) async {
    await postCollection.doc(id).delete();
  }

//  PostDetails _postFromSnapshot(DocumentSnapshot snapshot) {
//    return PostDetails(
//        uid: snapshot.get('uid'),
//        tag: snapshot.get('tag'),
//        docid: snapshot.get('postid'),
//        url: snapshot.get('url'));
//  }

  List<PostDetails> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return PostDetails(
        uid: doc.get('uid'),
        tag: doc.get('tag') ?? '',
        docid: doc.get('postId') ?? '',
        url: doc.get('url'),
        refid: doc.id,
      );
    }).toList();
  }

  Stream<List<PostDetails>> get userPosts {
    return postCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Stream<List<PostDetails>> get posts {
    return postCollection
        .orderBy('time', descending: true)
        .snapshots()
        .map(_postListFromSnapshot);
  }
}
