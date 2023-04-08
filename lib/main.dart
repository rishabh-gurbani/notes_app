import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/consts/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_events.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import 'package:notes_app/services/auth/firebase_auth_provider.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes/create_update_note_view.dart';
import 'package:notes_app/views/notes/notes_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: BlocProvider(
      create: (context) => AuthBloc(FireBaseAuthProvider()),
      child: HomePage(),
    ),
    routes: {
      createUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final authService = AuthService.firebase();

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialise());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateEmailNotVerified){
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut){
          return const LoginView();
        } else if (state is AuthStateRegistering){
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
