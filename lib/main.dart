import 'package:flutter/material.dart';
import 'package:notes_app/consts/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes/create_update_note_view.dart';
import 'package:notes_app/views/notes/notes_view.dart';
import 'package:notes_app/views/register_view.dart';
import 'package:notes_app/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: HomePage(),
        routes: {
          loginRoute : (context) => const LoginView(),
          registerRoute : (context) => const RegisterView(),
          notesRoute : (context) => const NotesView(),
          verifyEmailRoute : (context) => const VerifyEmailView(),
          createUpdateNoteRoute : (context) => const CreateUpdateNoteView(),
        },
      )
  );
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final authService = AuthService.firebase();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: authService.initialise(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done :
              final user = authService.getCurrentUser;
              if(user!=null){
                if(user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              }
              return const LoginView();
            default:
              return const CircularProgressIndicator();
          }
        },
    );
  }
}









