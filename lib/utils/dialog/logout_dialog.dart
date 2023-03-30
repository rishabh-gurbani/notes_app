import 'package:flutter/material.dart';
import 'generic_dialog.dart';

Future<bool> showLogoutDialog(
  BuildContext context,
) async {
  return await showGenericDialog<bool>(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to log out?',
    optionBuilder: () => {
      'Cancel': false,
      'Log Out': true,
    },
  ).then((value) => value ?? false);
}
