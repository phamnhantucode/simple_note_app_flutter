import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

class LoadingDialog {
  static final LoadingDialog _shared = LoadingDialog._sharedInstance();
  LoadingDialog._sharedInstance();
  factory LoadingDialog() => _shared;
  CloseDialog? _closeDialog;
  void show({
    required BuildContext context,
    required String text,
  }) {
    final dialog = AlertDialog(
        content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10.0),
        Text(text),
      ],
    ));
    showDialog(context: context, builder: (context) => dialog);

    _closeDialog = () => Navigator.of(context).pop();
  }

  void close() {
    if (_closeDialog != null) {
      _closeDialog!();
      _closeDialog = null;
    }
  }
}
