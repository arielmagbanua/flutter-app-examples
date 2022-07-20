import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailedVerified;

  const AuthUser({
    required this.isEmailedVerified,
  });

  factory AuthUser.fromFirebase(User user) =>
      AuthUser(isEmailedVerified: user.emailVerified);
}
