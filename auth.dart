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

Future<void> signupWithEmailAndPassword(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("Account created!");
    return;

  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print("Weak password!");
    }
    else if (e.code == 'email-already-in-use') {
      print("Email already in use!");
    }
    else {
      print("Unknown firebase auth error");
    }
  }
  catch (e) {
    print("Something went wrong!");
  }
}


Future<void> signinWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print("User was logged in");

  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found.');
    }
    else if (e.code == 'wrong-password') {
      print('Invalid password.');
    }

  }
}

