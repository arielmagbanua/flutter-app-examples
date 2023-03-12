import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  final String? errorMessage;

  const Error(this.errorMessage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(errorMessage ?? 'Something went wrong!'),
      ),
    );
  }
}
