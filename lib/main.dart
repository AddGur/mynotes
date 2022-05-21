import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/enums/menu_action.dart';
import 'package:login_app/screens/notes/create_update_note_view_screen.dart';
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
        CreateUpdateNoteViewScreen.routeName: (context) =>
            const CreateUpdateNoteViewScreen(),
        VerifyEmailViewScreen.routeName: (context) =>
            const VerifyEmailViewScreen(),
      },
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state) {
            _controller.clear();
          },
          builder: (context, state) {
            final invalidValue =
                (state is CounterStateInvalidNumber) ? state.invalideValue : '';

            return Column(
              children: [
                Text('Current value => ${state.value}'),
                Visibility(
                    child: Text('Invalid input: $invalidValue'),
                    visible: state is CounterStateInvalidNumber),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Enter a number here'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(DecrementEvent(_controller.text));
                        },
                        child: const Text('-')),
                    TextButton(
                        onPressed: () {
                          context
                              .read<CounterBloc>()
                              .add(IncrementEvent(_controller.text));
                        },
                        child: const Text('+')),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalideValue;

  const CounterStateInvalidNumber({
    required this.invalideValue,
    required int previousValue,
  }) : super(previousValue);
}

abstract class CounterEvent {
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer == null) {
          emit(CounterStateInvalidNumber(
            invalideValue: event.value,
            previousValue: state.value,
          ));
        } else {
          emit(CounterStateValid(state.value + integer));
        }
      },
    );
    on<DecrementEvent>(
      (event, emit) {
        final integer = int.tryParse(event.value);
        if (integer == null) {
          emit(CounterStateInvalidNumber(
            invalideValue: event.value,
            previousValue: state.value,
          ));
        } else {
          emit(CounterStateValid(state.value - integer));
        }
      },
    );
  }
}
