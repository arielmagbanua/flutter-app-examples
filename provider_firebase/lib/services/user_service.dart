import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<void> logout() => FirebaseAuth.instance.signOut();
}
