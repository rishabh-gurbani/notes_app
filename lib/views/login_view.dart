import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_events.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import '../services/auth/auth_exceptions.dart';
import 'package:notes_app/utils/dialog/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController email;

  late final TextEditingController password;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
      color: Theme.of(context).primaryColor,
    );

    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateLoggedOut) {
            if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(
                context,
                'User not found',
              );
            } else if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(
                context,
                'Wrong credentials',
              );
            } else if (state.exception!=null){
              await showErrorDialog(
                context,
                'Authentication error',
              );
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Login"),
          ),
          body: Column(
            children: [
              TextField(
                controller: email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: "Enter Email"),
              ),
              TextField(
                controller: password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(hintText: "Enter Password"),
              ),
              TextButton(
                  child: Text("Login", style: style),
                  onPressed: () {
                    final mail = email.text;
                    final pass = password.text;
                    context.read<AuthBloc>().add(AuthEventLogIn(mail, pass));
                  }),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text("Register new User"),
              )
            ],
          ),
        ));
  }
}
