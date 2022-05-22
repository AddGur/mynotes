import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/screens/notes/create_update_note_view_screen.dart';
import 'package:login_app/screens/notes/notes_view_screen.dart';
import 'package:login_app/services/auth/bloc/auth_bloc.dart';
import 'package:login_app/services/auth/bloc/auth_event.dart';
import 'package:login_app/services/auth/bloc/auth_state.dart';
import 'package:login_app/services/auth/firebase_auth_provider.dart';
import '../screens/verify_email_view_screen.dart';
import '../screens/login_view_screen.dart';
import '../screens/register_view_screen.dart';
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
      home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage()),
      debugShowCheckedModeBanner: false,
      routes: {
        // '/login/' : (context) => const LoginViewScreen(),
        // LoginViewScreen.routeName: (context) => const LoginViewScreen(),
        // RegisteViewScreen.routeName: (context) => const RegisteViewScreen(),
        // NotesViewScreen.routeName: (context) => const NotesViewScreen(),
        CreateUpdateNoteViewScreen.routeName: (context) =>
            const CreateUpdateNoteViewScreen(),
        // VerifyEmailViewScreen.routeName: (context) =>
        //     const VerifyEmailViewScreen(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesViewScreen();
      } else if (state is AuthStateNeedsVerification) {
        return const VerifyEmailViewScreen();
      } else if (state is AuthStateLoggedOut) {
        return const LoginViewScreen();
      } else if (state is AuthStateRegistering) {
        return const RegisteViewScreen();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }

//     return FutureBuilder(
//       future: AuthService.firebase().initialize(),
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             final user = AuthService.firebase().currentUser;
//             if (user != null) {
//               if (user.isEmailVerified) {
//                 return const NotesViewScreen();
//               } else {
//                 return const VerifyEmailViewScreen();
//               }
//             } else {
//               return const LoginViewScreen();
//             }
//           default:
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//         }
//       },
//     );
//   }
// }

}
