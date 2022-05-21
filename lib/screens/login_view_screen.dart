import 'package:flutter/material.dart';
import 'package:login_app/screens/notes/notes_view_screen.dart';
import 'package:login_app/screens/verify_email_view_screen.dart';
import 'package:login_app/services/auth/auth_exceptions.dart';
import 'package:login_app/services/auth/auth_service.dart';
import '../main.dart';
import '../screens/register_view_screen.dart';
import 'dart:developer' as devtools show log;

import '../utilities/dialogs/error_dialog.dart';

class LoginViewScreen extends StatefulWidget {
  static const routeName = '/login_view';
  const LoginViewScreen({super.key});

  @override
  State<LoginViewScreen> createState() => _LoginViewScreenState();
}

class _LoginViewScreenState extends State<LoginViewScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential = await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    NotesViewScreen.routeName,
                    (route) => false,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    VerifyEmailViewScreen.routeName,
                  );
                }

                devtools.log(userCredential.toString());
              } on UserNotFoundAuthException catch (e) {
                showErrorDialog(context, 'User not found');
              } on WrongPasswordAuthException catch (e) {
                showErrorDialog(context, 'Wrong credentials');
              } on GenericAuthException {
                showErrorDialog(context, 'Error');
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RegisteViewScreen.routeName, (route) => false);
              },
              child: const Text('Not registered yet? Register here!'))
        ],
      ),
    );
  }
}
