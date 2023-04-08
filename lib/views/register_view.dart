import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/services/auth/bloc/auth_bloc.dart';
import 'package:notes_app/services/auth/bloc/auth_events.dart';
import 'package:notes_app/services/auth/bloc/auth_state.dart';
import '../services/auth/auth_exceptions.dart';
import 'package:notes_app/utils/dialog/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              'Weak password',
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              'Email is already in use',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'This is an invalid email address',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Failed to register',
            );
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Register"),
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
                  child: Text("Register", style: style),
                  onPressed: () {
                    final mail = email.text;
                    final pass = password.text;
                    context.read<AuthBloc>().add(AuthEventRegister(
                          mail,
                          pass,
                        ));
                  }),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text("Login Existing User"),
              )
            ],
          )),
    );
  }
}
