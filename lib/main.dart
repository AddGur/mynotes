import 'package:flutter/material.dart';
import 'package:login_app/enums/menu_action.dart';
import 'package:login_app/screens/notes/new_note_view_screen.dart';
import 'package:login_app/screens/notes/notes_view_screen.dart';
import 'package:login_app/services/auth/auth_service.dart';
import '../screens/verify_email_view_screen.dart';
import '../screens/login_view_screen.dart';
import '../screens/register_view_screen.dart';
import 'firebase_options.dart';
import 'dart:developer' as devtools show log;

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
      debugShowCheckedModeBanner: false,
      routes: {
        // '/login/' : (context) => const LoginViewScreen(),
        LoginViewScreen.routeName: (context) => const LoginViewScreen(),
        RegisteViewScreen.routeName: (context) => const RegisteViewScreen(),
        NotesViewScreen.routeName: (context) => const NotesViewScreen(),
        NewNoteViewScreen.routeName: (context) => const NewNoteViewScreen(),
        VerifyEmailViewScreen.routeName: (context) =>
            const VerifyEmailViewScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesViewScreen();
              } else {
                return const VerifyEmailViewScreen();
              }
            } else {
              return const LoginViewScreen();
            }
          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}
