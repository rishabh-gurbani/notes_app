import 'package:notes_app/consts/routes.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import '../services/auth/auth_exceptions.dart';
import '../utils/show_error_dialog.dart';

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

    var style = TextStyle(color: Theme.of(context).primaryColor,);

    return Scaffold(
        appBar: AppBar(title: const Text("Register"),),
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
              child: Text("Register", style: style),
              onPressed: () async {
                final mail = email.text;
                final pass = password.text;
                try{
                  await AuthService.firebase().register(email: mail, password: pass);
                  AuthService.firebase().sendVerificationMail();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Weak password',
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    'Email is already in use',
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    'This is an invalid email address',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Failed to register',
                  );
                }
              },
            ),
            TextButton(onPressed: (){
              Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute, (route) => false);
            },
              child: const Text("Login Existing User"),
            )
          ],
        )
    );
  }
}
