import 'package:flutter/material.dart';
import 'generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  // returning a function
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this note?',
    optionBuilder: () => {
      'No': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
