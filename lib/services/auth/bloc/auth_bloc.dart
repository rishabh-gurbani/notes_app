import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/services/auth/auth_provider.dart';
import 'package:notes_app/services/auth/bloc/auth_events.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialised(isLoading: true)) {
    on<AuthEventSendEmailVerification>((event, emit) async {
      await provider.sendVerificationMail();
      emit(state);
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        provider.register(email: email, password: password);
        await provider.sendVerificationMail();
        emit(const AuthStateEmailNotVerified(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(isLoading: false, exception: e));
      }
    });

    // initialise
    on<AuthEventInitialise>((event, emit) async {
      await provider.initialise();
      final user = provider.getCurrentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateEmailNotVerified(isLoading: false));
      } else {
        emit(AuthStateLoggedIn(
          user: user,
          isLoading: false,
        ));
      }
    });

    // log in
    on<AuthEventLogIn>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        emit(const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: "Please wait, logging in",
        ));
        final user = await provider.logIn(email: email, password: password);
        if (user.isEmailVerified) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        } else {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          emit(const AuthStateEmailNotVerified(isLoading: false));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });

    // log out
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null, isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
  }
}
