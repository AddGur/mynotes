import 'dart:convert';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../screens/login_view_screen.dart';
import '../screens/register_view_screen.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        // '/login/' : (context) => const LoginViewScreen(),
        LoginViewScreen.routeName: (context) => const LoginViewScreen(),
        RegisteViewScreen.routeName: (context) => const RegisteViewScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            // final user = FirebaseAuth.instance.currentUser;
            // if (user?.emailVerified ?? false) {
            //   print('Youa re verified user');
            // } else {
            //   print(user);
            //   print('You need to verify your email first');
            //   return VerifyEmailViewScreen();
            return const LoginViewScreen();
          //}
          default:
            return Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}

class VerifyEmailViewScreen extends StatefulWidget {
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
        const Text('Please verify your email adress:'),
        TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('Send email verification'))
      ]),
    );
  }
}
