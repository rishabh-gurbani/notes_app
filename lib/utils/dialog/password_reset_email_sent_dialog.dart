import 'package:flutter/cupertino.dart';
import 'package:notes_app/extensions/buildcontext/loc.dart';
import 'package:notes_app/utils/dialog/generic_dialog.dart';

Future<void> showPasswordResetSentEmailDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: context.loc.password_reset,
    content:
      context.loc.password_reset_dialog_prompt,
    optionBuilder: () => {
      context.loc.ok: null,
    },
  );
}
