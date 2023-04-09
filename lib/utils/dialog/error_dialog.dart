import 'package:flutter/material.dart';
import 'package:notes_app/extensions/buildcontext/loc.dart';
import 'generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text,) {
  // returning a function
  return showGenericDialog<void>(context: context,
    title: context.loc.generic_error_prompt,
    content: text,
    optionBuilder: () =>
    {
      context.loc.ok: null,
    },);
}
