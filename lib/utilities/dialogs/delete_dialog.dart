import 'package:flutter/material.dart';
import 'package:mynotesbeginer/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialog(
    context: context,
    title: 'Delete',
    content: 'Are you sure to delete this item?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}
