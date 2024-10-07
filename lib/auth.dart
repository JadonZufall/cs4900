import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';


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
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
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
    log("Something went wrong!");
  }
}


Future<void> signinWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    log("User was logged in");

  }
  on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      log('No user found.');
    }
    else if (e.code == 'wrong-password') {
      log('Invalid password.');
    }

  }
}

Future<void> signoutOfAccountInstance() async {
  await FirebaseAuth.instance.signOut();
  log("Account signed out!");
  return;
}

