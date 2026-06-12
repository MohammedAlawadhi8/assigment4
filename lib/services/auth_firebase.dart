import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthFirebase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

    
      await _firestore.collection('users').doc(user!.uid).set({
        'email': email,
        'username': username,
        'uid': user.uid,
      });

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

 
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

 
  Future<void> logout() async {
    await _auth.signOut();
  }
}
