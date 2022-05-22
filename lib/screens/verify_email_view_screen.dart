import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/services/auth/auth_service.dart';
import 'package:login_app/services/auth/bloc/auth_bloc.dart';
import 'package:login_app/services/auth/bloc/auth_event.dart';

class VerifyEmailViewScreen extends StatefulWidget {
  static const routeName = '/verify_email';
  const VerifyEmailViewScreen({super.key});

  @override
  State<VerifyEmailViewScreen> createState() => _VerifyEmailViewScreenState();
}

class _VerifyEmailViewScreenState extends State<VerifyEmailViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Column(children: [
        const Text(
            'We\'ve sent you an email verifiaton. Please open it to verify your account'),
        const Text(
            'If you haven\'t received a verification email yet, press the button below'),
        TextButton(
            onPressed: () async {
              context
                  .read<AuthBloc>()
                  .add(const AuthEventSendEmailVerification());
              // final user = AuthService.firebase().currentUser;
              // await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Send email verification'))
      ]),
    );
  }
}
