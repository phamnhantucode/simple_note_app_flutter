import 'package:flutter/material.dart';
import 'package:mynotesbeginer/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Logout',
    content: 'Are you sure to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
