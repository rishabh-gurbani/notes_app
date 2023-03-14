import 'package:flutter/material.dart';
import 'package:notes_app/consts/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import '../services/auth/auth_exceptions.dart';
import '../utils/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final AuthService authService = AuthService.firebase();

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
    var style = TextStyle(color: Theme
        .of(context)
        .primaryColor,);

    return Scaffold(
      appBar: AppBar(title: const Text("Login"),),
      body: Column(
        children: [
          TextField(
            controller: email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText: "Enter Email"
            ),
          ),
          TextField(
            controller: password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                hintText: "Enter Password"
            ),
          ),
          TextButton(
              child: Text("Login", style: style),
              onPressed: () async {
                final mail = email.text;
                final pass = password.text;
                showDialog(context: context,
                    builder: (context) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    });
                try {
                  final user = await authService.logIn(
                      email: mail, password: pass
                  );
                  devtools.log(user.toString());
                  if (user.isEmailVerified) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        notesRoute,
                            (route) => false);
                  } else {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  }
                } on UserNotFoundAuthException {
                    Navigator.of(context).pop();
                    await showErrorDialog(
                      context,
                      'User not found',
                    );
                  } on WrongPasswordAuthException {
                    Navigator.of(context).pop();
                    await showErrorDialog(
                      context,
                      'Wrong credentials',
                    );
                  } on GenericAuthException {
                    Navigator.of(context).pop();
                    await showErrorDialog(
                      context,
                      'Authentication error',
                    );
                  }
              }
          ),
          TextButton(onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute, (route) => false);
          },
            child: const Text("Register new User"),
          )
        ],
      ),
    );
  }
}