import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

// Constructor
  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

// SigInWithGoogle
  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

// SigInWithCredentials
  Future<void> signInWithCredentials(String mail, String psswd) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: mail, password: psswd);
  }

// SignUp
  Future<void> signUp(String mail, String psswd) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: mail, password: psswd);
  }

// SignOut
  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

// Logeado?
  Future<bool> isLogged() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

// Obtener Usuario
  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).email;
  }
}
