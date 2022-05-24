import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/extensions/buildcontext/loc.dart';
import 'package:login_app/services/auth/auth_exceptions.dart';
import 'package:login_app/services/auth/bloc/auth_bloc.dart';
import 'package:login_app/services/auth/bloc/auth_event.dart';
import 'package:login_app/services/auth/bloc/auth_state.dart';
import 'package:login_app/utilities/dialogs/loading_dialog.dart';
import '../screens/register_view_screen.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  // CloseDialog? _closeDialogHandle;

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
        if (state is AuthStateLoggedOut) {
          //   final closeDialog = _closeDialogHandle;
          //   if (!state.isLoading && closeDialog != null) {
          //     closeDialog();
          //     _closeDialogHandle = null;
          //   } else if (state.isLoading && closeDialog == null) {
          //     _closeDialogHandle =
          //         showLoadingDialog(context: context, text: 'Loading...');
          //   }

          if (state.exception is UserNotFoundAuthException ||
              state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Wrong Crednetials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentiaction error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          //    title: Text(AppLocalizations.of(context)!.my_title),
          // after adding loc.dart it's looks like:
          title: Text(context.loc.my_title),

          //  title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  'Please log in to your account in order to interat with and acreate notes!'),
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
                  //       try {
                  context.read<AuthBloc>().add(AuthEventLogIn(email, password));
                  // CONVERTING DO BLOC
                  // final userCredential = await AuthService.firebase().logIn(
                  //   email: email,
                  //   password: password,
                  // );
                  // final user = AuthService.firebase().currentUser;
                  // if (user?.isEmailVerified ?? false) {
                  //   Navigator.pushNamedAndRemoveUntil(
                  //     context,
                  //     NotesViewScreen.routeName,
                  //     (route) => false,
                  //   );
                  // } else {
                  //   Navigator.pushNamed(
                  //     context,
                  //     VerifyEmailViewScreen.routeName,
                  //   );
                  //}

                  // devtools.log(userCredential.toString());
                  // } on UserNotFoundAuthException catch (e) {
                  //   showErrorDialog(context, 'User not found');
                  // } on WrongPasswordAuthException catch (e) {
                  //   showErrorDialog(context, 'Wrong credentials');
                  // } on GenericAuthException {
                  //   showErrorDialog(context, 'Error');
                  //   }
                  //  },
                },
                child: const Text('Login'),
              ),
              TextButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(const AuthEventShouldRegister());
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, RegisteViewScreen.routeName, (route) => false);
                  },
                  child: const Text('Not registered yet? Register here!')),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        );
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, RegisteViewScreen.routeName, (route) => false);
                  },
                  child: const Text('I forgot my password'))
            ],
          ),
        ),
      ),
    );
  }
}
