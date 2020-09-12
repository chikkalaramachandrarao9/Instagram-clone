import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:insta/models/follower.dart';

class FollowerDatabaseService {
   String followeruid;
   String followinguid;

  FollowerDatabaseService(this.followeruid, this.followinguid);


   FollowerDatabaseService.follow(this.followeruid);

   final CollectionReference followerCollection =
      FirebaseFirestore.instance.collection('followers');

  Future updateUserData() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('followers').doc();
    return await documentReference.set({
      'followeruid': followeruid,
      'followinguid': followinguid,
    });
  }

  Future deleteUser(String docid) async {
    return await followerCollection.doc(docid).delete();
  }

  List<Follower> _followData(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Follower(
          follower: doc.get('followeruid') ?? '',
          following: doc.get('followinguid') ?? '',
          docid: doc.id);
    }).toList();
  }

  Stream<List<Follower>> get isfollower {
    return followerCollection
        .where('followeruid', isEqualTo: followeruid)
        .where('followinguid', isEqualTo: followinguid)
        .snapshots()
        .map(_followData);
  }

  Stream<List<Follower>> get followers{
  return followerCollection
      .where('followeruid', isEqualTo: followeruid)
      .snapshots()
      .map(_followData);
  }
}
