import 'package:flutter/material.dart';
import 'generic_dialog.dart';

Future<void> showCanNotShareDialog(BuildContext context) {
  // returning a function
  return showGenericDialog<void>(context: context,
    title: 'Empty Note',
    content: 'Can not share empty note',
    optionBuilder: () =>
    {
      'OK': null,
    },);
}