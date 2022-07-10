import 'package:flutter/material.dart';

import '../constants/routes.dart';
import '../services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final authService = AuthService.firebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(
              'We\'ve sent you and email verification. Please open it to verify your account.'),
          const Text(
              'If you haven\'t received a verification email yet, press the button below.'),
          TextButton(
            onPressed: () async {
              await authService.sendEmailVerification();
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async {
              await authService.logOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
