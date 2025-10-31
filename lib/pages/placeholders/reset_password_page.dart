import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  final String token;
  const ResetPasswordPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(child: Text('Reset password token: $token (placeholder)')),
    );
  }
}
