import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cs4900/database.dart';



Future<bool> isAuthenticated() async {
  User? localUser = FirebaseAuth.instance.currentUser;
  return localUser != null;
}

Future<Map<String, dynamic>> getLocalUserInfo() async {
  UserInstance? localUser = UserInstance.getLocalUser();
  Map<String, dynamic> result = {};
  if (localUser != null) {
    result = await localUser.get();
  }
  return result;
}

Future<String> getLocalUsername() async {
  Map<String, dynamic> user = await getLocalUserInfo();
  return await user["username"];
}

Future<void> setLocalUsername(String username) async {
  User? localUser = FirebaseAuth.instance.currentUser;
  UserModel.setUsername(localUser!.uid, username);
  return;
}



bool validatePhoneNumber(String number) {
  /* User input sanitation.
  */

  return true;
}

bool validateEmailAndPassword(String email, String password) {
  /* User input sanitation.
  */
  return true;
}

Future<void> signupWithPhoneNumber(String number) async {
  throw Exception("Not implemented!");
}

Future<void> signinWithPhoneNumber(String number) async {
  throw Exception("Not implemented");
}


/*
  Likely need to include these functions directly in the widget themselves in order to correctly handle the applications authentication state.
*/
Future<void> signupWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    UserModel.create(cred.user!.uid, email, "", "");

    String uid = cred.user!.uid;
    log("Authentication account created, $uid");

    return;

  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      log("Authentication account creation failed, password is too weak.");
      return;
    }
    else if (e.code == 'email-already-in-use') {
      log("Authentication account creation failed, email is already in use.");
    }
    else {
      String errorCode = e.code;
      log("Authentication account creation failed, $errorCode");
    }
  }
  catch (e) {
    log("Authentication account creation failed, unexpected exception.");
  }
}


Future<int> signinWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    String uid = cred.user!.uid;
    UserModel.validate(uid, email: email);
    log("Authenticated as $uid");
    return 0;
  }
  on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      log('Authentication failed, user was not found.');
      return 1;
    }
    else if (e.code == 'wrong-password') {
      log('Authentication failed, invalid password.');
      return 2;
    }
    else {
      log("Authentication failed, unexpected exception.");
      return -1;
    }
  }
}

Future<void> signoutOfAccountInstance() async {
  await FirebaseAuth.instance.signOut();
  log("Authentication was deauthenticated.");
  return;
}

