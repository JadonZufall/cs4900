import 'package:firebase_auth/firebase_auth.dart';


Future<void> signupWithPhoneNumber(String number) async {

}

Future<void> signinWithPhoneNumber(String number) async {

}

Future<void> signupWithEmailAndPassword(String email, String password) async {

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

