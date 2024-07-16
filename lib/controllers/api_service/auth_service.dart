

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/baseUser.dart';




class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleAuthProvider googleProvider = GoogleAuthProvider();
  // GoogleSignIn signIn = GoogleSignIn();
  BaseUser? createUser(User? user) {
    return user != null ? BaseUser(uid: user.uid, email: user.email, name: user.displayName,isAnonymous: user.isAnonymous) : null;
  }

  Stream<BaseUser?> get baseUser {
    return  _auth.authStateChanges()
        .map((user) => createUser(user)
      // .map(createUser)
    );
  }

  Stream<User> get fireBaseUser {
    return  _auth.authStateChanges().map((user) => user!);
  }

  /// sign in with anon
  Future signInAnon()async {
    try{
      UserCredential response = await _auth.signInAnonymously();
      User user = response.user!;
      return createUser(user);
    }catch (e){
      print(e.toString());
      return null;
    }
  }



  /// Sign in email and password
  Future signInWithGoogle() async {

    googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({
      'login_hint': 'user@example.com'
    });

    UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
    // Once signed in, return the UserCredential
    return createUser(userCredential.user);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }


  ///

  Future signOut (BaseUser user)async{
    try{
      if(!user.isAnonymous!){
        // await signIn.disconnect();
      }
      return await _auth.signOut();
    }catch(e){
      return null;
    }
  }
}