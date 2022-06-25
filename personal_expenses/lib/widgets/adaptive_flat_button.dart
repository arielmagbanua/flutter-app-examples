import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// FlatButton widget that supports android and iOS.
class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function()? handler;

  AdaptiveFlatButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoButton(
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: handler,
      );
    }

    return TextButton(
      onPressed: handler,
      child: const Text(
        'Choose Date',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
