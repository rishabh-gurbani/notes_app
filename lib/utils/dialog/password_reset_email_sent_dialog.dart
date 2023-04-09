import 'package:flutter/cupertino.dart';
import 'package:notes_app/utils/dialog/generic_dialog.dart';

Future<void> showPasswordResetSentEmailDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: "Password Reset",
    content:
        "We have sent you a password reset link. Please check your email for more information.",
    optionBuilder: () => {
      'OK': null,
    },
  );
}
