import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/services/auth/bloc/auth_event.dart';
import '../screens/verify_email_view_screen.dart';
import '../services/auth/auth_service.dart';
import '../screens/login_view_screen.dart';
import 'dart:developer' as devtools show log;

import '../services/auth/auth_exceptions.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class RegisteViewScreen extends StatefulWidget {
  static const routeName = '/register_view';
  const RegisteViewScreen({super.key});

  @override
  State<RegisteViewScreen> createState() => _RegisteViewScreenState();
}

class _RegisteViewScreenState extends State<RegisteViewScreen> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email is already in use');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
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
                context
                    .read<AuthBloc>()
                    .add(AuthEventRegister(email, password));
                // try {
                //   final userCredential =
                //       await AuthService.firebase().createUser(
                //     email: email,
                //     password: password,
                //   );

                //   devtools.log(userCredential.toString());
                //   final user = AuthService.firebase().currentUser;
                //   await AuthService.firebase().sendEmailVerification();
                //   Navigator.pushNamed(context, VerifyEmailViewScreen.routeName);
                // } on EmailAlreadyInUseAuthException catch (e) {
                //   showErrorDialog(context, 'Email is already in use');
                // } on WeakPasswordAuthException catch (e) {
                //   showErrorDialog(context, 'Weak password');
                // } on InvalidEmailAuthException catch (e) {
                //   showErrorDialog(context, 'Invalid email');
                // } on GenericAuthException {
                //   showErrorDialog(context, 'Error');
                // }
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, LoginViewScreen.routeName, (route) => false);
                },
                child: const Text('Already registered? Login here!'))
          ],
        ),
      ),
    );
  }
}
