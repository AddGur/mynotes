import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/register_view_screen.dart';
import 'dart:developer' as devtools show log;

import '../utilities/show_errod_dialog.dart';

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
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  NotesViewScreen.routeName,
                  (route) => false,
                );
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  showErrorDialog(context, 'User not found');
                } else if (e.code == 'wrong-password') {
                  showErrorDialog(context, 'Wrong credentials');
                } else {
                  showErrorDialog(context, 'Error: ${e.code}');
                }
              } catch (e) {
                showErrorDialog(context, 'Error: ${e.toString()}');
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
