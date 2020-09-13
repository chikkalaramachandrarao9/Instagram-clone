import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/comment.dart';

class CommentDatabaseService {
  String postId;
  String userId;

  CommentDatabaseService(this.postId, this.userId);

  final CollectionReference commentCollection =
      FirebaseFirestore.instance.collection('comments');

  Future updateCommentData(String comment) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('comments').doc();
    return await documentReference.set({
      'userid': userId,
      'postid': postId,
      'comment': comment,
      'docId': documentReference.id,
    });
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
        .where('postid', isEqualTo: postId)
        .snapshots()
        .map(_commentData);
  }
}
