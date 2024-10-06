import 'package:firebase_auth/firebase_auth.dart';


Future<void> loginWithEmailAndPassword(String email, String password) async {
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

