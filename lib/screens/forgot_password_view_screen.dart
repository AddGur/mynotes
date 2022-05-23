import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/services/auth/bloc/auth_bloc.dart';
import 'package:login_app/services/auth/bloc/auth_event.dart';
import 'package:login_app/services/auth/bloc/auth_state.dart';
import 'package:login_app/utilities/dialogs/error_dialog.dart';

import '../utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordViewScreen extends StatefulWidget {
  const ForgotPasswordViewScreen({super.key});

  @override
  State<ForgotPasswordViewScreen> createState() =>
      _ForgotPasswordViewScreenState();
}

class _ForgotPasswordViewScreenState extends State<ForgotPasswordViewScreen> {
  late final TextEditingController _controller;
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context,
                'We colud not precess your request. Please make sure that you are a registerd user');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Forgot Password')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            const Text(
                'If you forgot password, simply enter email and we will send you a password reset link'),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofocus: true,
              decoration:
                  const InputDecoration(hintText: 'Your email adress...'),
            ),
            TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                },
                child: const Text('Send me password reset link')),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: const Text('Back to login page')),
          ]),
        ),
      ),
    );
  }
}
