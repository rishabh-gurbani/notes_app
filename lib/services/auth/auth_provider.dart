import 'auth_user.dart';

abstract class AuthProvider{

  AuthUser? get getCurrentUser;

  Future<AuthUser> logIn({required String email, required String password});
  Future<AuthUser> register({required String email, required String password});
  Future<void> signOut();
  Future<void>  sendVerificationMail();
  Future<void> initialise();

}