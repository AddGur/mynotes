import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_app/extensions/buildcontext/loc.dart';
import 'package:login_app/screens/notes/create_update_note_view_screen.dart';
import 'package:login_app/screens/notes/notes_list_view_screen.dart';
import 'package:login_app/services/auth/auth_service.dart';
import 'package:login_app/services/auth/bloc/auth_bloc.dart';
import 'package:login_app/services/auth/bloc/auth_event.dart';
import 'package:login_app/services/cloud/cloud_note.dart';
import 'package:login_app/services/cloud/firebase_cloud_storage.dart';
import 'package:login_app/services/crud/notes_service.dart';

import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';
import '../login_view_screen.dart';
import 'dart:developer' as devtools show log;

extension Count<T extends Iterable> on Stream {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesViewScreen extends StatefulWidget {
  static const routeName = '/notes_view';
  const NotesViewScreen({super.key});

  @override
  State<NotesViewScreen> createState() => _NotesViewScreenState();
}

class _NotesViewScreenState extends State<NotesViewScreen> {
  // String get userEmail => AuthService.firebase().currentUser!.email;
  String get userId => AuthService.firebase().currentUser!.id;

  // late final NotesService _notesService;
  late final FirebaseCloudStorage _notesService;

  @override
  void initState() {
    //_notesService = NotesService();
    _notesService = FirebaseCloudStorage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
            stream: _notesService.allNotes(onwerUserId: userId).getLength,
            builder: (context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                final noteCount = snapshot.data ?? 0;
                final text = context.loc.notes_title(noteCount);
                return Text(text);
              } else {
                return const Text('');
              }
            }),
        actions: [
          IconButton(
              onPressed: (() => Navigator.pushNamed(
                  context, CreateUpdateNoteViewScreen.routeName)),
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogut = await showLogOutDialog(context);
                devtools.log(shouldLogut.toString());
                if (shouldLogut) {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                  // convert to BLOC
                  //   await AuthService.firebase().logOut();
                  //   Navigator.pushNamedAndRemoveUntil(
                  //       context, LoginViewScreen.routeName, (route) => false);
                }
                break;
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log out'),
              ),
            ];
          })
        ],
      ),
      body:
          // FutureBuilder(
          //     future: _notesService.getOrCreateUser(email: userEmail),
          //     builder: (context, snapshot) {
          //       switch (snapshot.connectionState) {
          //         case ConnectionState.done:
          //           return
          StreamBuilder(
        // stream: _notesService.allNotes,
        stream: _notesService.allNotes(onwerUserId: userId),

        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes =
                    //  snapshot.data as List<DatabaseNote>;
                    snapshot.data as Iterable<CloudNote>;
                return NotesListViewScreen(
                    onTap: (note) {
                      Navigator.pushNamed(
                          context, CreateUpdateNoteViewScreen.routeName,
                          arguments: note);
                    },
                    notes: allNotes,
                    onDeleteNote: (note) async {
                      //    await _notesService.deleteNote(id: note.id);
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    });
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      // default:
      //   return const CircularProgressIndicator();
      // }
      // }),
    );
  }
}
