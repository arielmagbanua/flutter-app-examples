import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String? errorMessage;

  const ErrorPage(this.errorMessage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(errorMessage ?? 'Something went wrong!'),
      ),
    );
  }
}
