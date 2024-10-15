import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs4900/database.dart';




bool validatePhoneNumber(String number) {

  return true;
}

bool validateEmailAndPassword(String email, String password) {

  return true;
}

Future<void> signupWithPhoneNumber(String number) async {

}

Future<void> signinWithPhoneNumber(String number) async {

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

    log("Account created!");
    return;

  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      log("Weak password!");
    }
    else if (e.code == 'email-already-in-use') {
      log("Email already in use!");
    }
    else {
      log("Unknown firebase auth error");
    }
  }
  catch (e) {
    log("Signup failed, unexpected exception was invoked");
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
  log("Account signed out!");
  return;
}

