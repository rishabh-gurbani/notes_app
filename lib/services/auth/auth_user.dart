import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  final String userId;
  final bool isEmailVerified;
  final String email;

  //can fetch notes for particular user using email ID

  const AuthUser({
    required this.userId,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebaseUser(User user) => AuthUser(
        userId: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );
}
