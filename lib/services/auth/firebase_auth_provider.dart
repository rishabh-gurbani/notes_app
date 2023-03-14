import 'package:firebase_core/firebase_core.dart';
import 'package:notes_app/services/auth/auth_provider.dart';
import 'package:notes_app/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_options.dart';
import 'auth_exceptions.dart';

class FireBaseAuthProvider implements AuthProvider{

  @override
  AuthUser? get getCurrentUser {
    User? user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      return AuthUser.fromFirebaseUser(user);
    }else{
      return null;
    }
  }

  @override
  Future<AuthUser> logIn ({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = getCurrentUser;
      if(user!=null){
        return user;
      }else{
        throw UserNotLoggedInException();
      }
    }

    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> register({required String email, required String password}) async {
    try{
      await FirebaseAuth.instance.
      createUserWithEmailAndPassword(email: email, password: password);
      final user = getCurrentUser;
      if(user!=null) {
        return user;
      } else{
        throw UserNotLoggedInException();
      }
    }

    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }


  @override
  Future<void> sendVerificationMail() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      user.sendEmailVerification();
    }else{
      throw UserNotLoggedInException();
    }
  }


  @override
  Future<void> signOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInException();
    }
  }

  @override
  Future<void> initialise() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

}