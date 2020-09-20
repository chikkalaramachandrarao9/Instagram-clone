import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/Like.dart';

class LikeDatabaseService {
  String postId;
  String userId;

  LikeDatabaseService(this.postId, this.userId);

  final CollectionReference likeCollection =
      FirebaseFirestore.instance.collection('likes');

  Future updateLikeData() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('likes').doc();
    return await documentReference.set({
      'userid': userId,
      'postid': postId,
    });
  }

  Future deleteLike(String docid) async {
    return await likeCollection.doc(docid).delete();
  }

  List<Like> _likeData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Like(
          postId: doc.get('postid') ?? '',
          uid: doc.get('userid') ?? '',
          docId: doc.id);
    }).toList();
  }

  Stream<List<Like>> get likers {
    return likeCollection
        .where('postid', isEqualTo: postId)
        .snapshots()
        .map(_likeData);
  }

  Stream<List<Like>> get isliked {
    return likeCollection
        .where('postid', isEqualTo: postId)
        .where('userid', isEqualTo: userId)
        .snapshots()
        .map(_likeData);
  }

  Stream<List<Like>> get noOfLikes {
    return likeCollection
        .where('postid', isEqualTo: postId)
        .snapshots()
        .map(_likeData);
  }
}
