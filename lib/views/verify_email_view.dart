import 'package:flutter/material.dart';
import 'package:notes_app/services/auth/auth_service.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email"),),
      body: Column(
        children: [
          TextButton(onPressed: () async {
            await AuthService.firebase().sendVerificationMail();
          },
              child: const Text("Verify Email ID"),
          )
        ]
      )
    );
  }
}