import 'package:flutter/material.dart';
import 'generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text,) {
  // returning a function
  return showGenericDialog<void>(context: context,
    title: 'An error occurred',
    content: text,
    optionBuilder: () =>
    {
      'OK': null,
    },);
}
