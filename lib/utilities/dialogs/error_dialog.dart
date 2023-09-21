import 'package:flutter/material.dart';
import 'package:mynotesbeginer/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String content,
) {
  return showGenericDialog<void>(
      context: context,
      title: "An error occurs",
      content: content,
      optionsBuilder: () => {
            'OK': null,
          });
}
