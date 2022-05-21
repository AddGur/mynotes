import 'package:flutter/material.dart';
import 'package:login_app/screens/notes/create_update_note_view_screen.dart';
import 'package:login_app/screens/notes/notes_list_view_screen.dart';
import 'package:login_app/services/auth/auth_service.dart';
import 'package:login_app/services/crud/notes_service.dart';

import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';
import '../login_view_screen.dart';
import 'dart:developer' as devtools show log;

class NotesViewScreen extends StatefulWidget {
  static const routeName = '/notes_view';
  const NotesViewScreen({super.key});

  @override
  State<NotesViewScreen> createState() => _NotesViewScreenState();
}

class _NotesViewScreenState extends State<NotesViewScreen> {
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final NotesService _notesService;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
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
                  await AuthService.firebase().logOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginViewScreen.routeName, (route) => false);
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
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _notesService.allNotes,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as List<DatabaseNote>;
                            print(allNotes);
                            return NotesListViewScreen(
                                onTap: (note) {
                                  Navigator.pushNamed(context,
                                      CreateUpdateNoteViewScreen.routeName,
                                      arguments: note);
                                },
                                notes: allNotes,
                                onDeleteNote: (note) async {
                                  await _notesService.deleteNote(id: note.id);
                                });
                          } else {
                            return const CircularProgressIndicator();
                          }
                        default:
                          return const CircularProgressIndicator();
                      }
                    });
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
