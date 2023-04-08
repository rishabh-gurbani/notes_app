import 'package:notes_app/services/auth/auth_provider.dart';
import 'package:notes_app/services/auth/auth_user.dart';
import 'firebase_auth_provider.dart';

class AuthService implements AuthProvider{
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FireBaseAuthProvider());


  @override
  AuthUser? get getCurrentUser => provider.getCurrentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password})
  => provider.logIn(email: email, password: password);

  @override
  Future<AuthUser> register({required String email, required String password}) =>
      provider.register(email: email, password: password);

  @override
  Future<void> sendVerificationMail() =>
      provider.sendVerificationMail();

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> initialise() => provider.initialise();

}