import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailedVerified;
  const AuthUser(this.isEmailedVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
