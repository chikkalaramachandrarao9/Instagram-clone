import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta/models/user.dart';
import 'package:insta/services/database/user_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserDetails _userFromFirebaseUser(User user) {
    return user != null ? UserDetails(uid: user.uid) : null;
  }

  Stream<UserDetails> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
  }

//  Future signinAnon() async {
//    try {
//      UserCredential result = await _auth.signInAnonymously();
//      User user = result.user;
//      return _userFromFirebaseUser(user);
//    } catch (e) {
//      print(e);
//    }
//  }

  Future register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      await UserDatabaseService(uid: user.uid).updateUserData(email, "",
          "https://images.unsplash.com/photo-1518707606293-6274eadcf07d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=600&q=60");
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signinWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
