import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/post_model.dart';

class PostDatabaseService {
  final String uid;
  PostDatabaseService({this.uid});

  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  Future updateUserData(String tag, String url) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('posts').doc();
    return await documentReference.set(
        {'uid': uid, 'tag': tag, 'url': url, 'postId': documentReference.id});
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
          url: doc.get('url'));
    }).toList();
  }

  Stream<List<PostDetails>> get userPosts {
    return postCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Stream<List<PostDetails>> get posts {
    return postCollection.snapshots().map(_postListFromSnapshot);
  }
}
