import 'package:flutter/material.dart';
import 'package:notes_app/extensions/buildcontext/loc.dart';
import 'generic_dialog.dart';

Future<void> showCanNotShareDialog(BuildContext context) {
  // returning a function
  return showGenericDialog<void>(context: context,
    title: context.loc.sharing,
    content: context.loc.cannot_share_empty_note_prompt,
    optionBuilder: () =>
    {
      context.loc.ok: null,
    },);
}