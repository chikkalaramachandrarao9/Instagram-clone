import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta/models/userdetails.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String aboutMe, String dpurl) async {
    return await userCollection
        .doc(uid)
        .set({'name': name, 'aboutme': aboutMe, 'dp': dpurl});
  }

  UserProfileWithUid _userFromSnapshot(DocumentSnapshot snapshot) {
    return UserProfileWithUid(
        uid: uid,
        name: snapshot.get('name'),
        aboutMe: snapshot.get('aboutme'),
        dpurl: snapshot.get('dp'));
  }

  List<UserProfile> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserProfile(
          name: doc.get('name') ?? '',
          aboutMe: doc.get('aboutme') ?? '',
          dpurl: doc.get('dp'));
    }).toList();
  }

  List<UserProfileWithUid> _userListFromSnapshotWithUid(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserProfileWithUid(
          uid: doc.id,
          name: doc.get('name') ?? '',
          aboutMe: doc.get('aboutme') ?? '',
          dpurl: doc.get('dp'));
    }).toList();
  }

  Stream<List<UserProfile>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Stream<List<UserProfileWithUid>> get usersWithUid {
    return userCollection.snapshots().map(_userListFromSnapshotWithUid);
  }

  Stream<UserProfileWithUid> get userData {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }
}
