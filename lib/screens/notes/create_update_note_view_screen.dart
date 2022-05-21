import 'package:flutter/material.dart';
import 'package:login_app/services/auth/auth_service.dart';
import 'package:login_app/services/cloud/cloud_note.dart';
import 'package:login_app/services/cloud/firebase_cloud_storage.dart';
import 'package:login_app/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

import '../../utilities/dialogs/cannot_share_empty_note_dialog.dart';

class CreateUpdateNoteViewScreen extends StatefulWidget {
  static const routeName = '/create_update_note_view';
  const CreateUpdateNoteViewScreen({super.key});

  @override
  State<CreateUpdateNoteViewScreen> createState() =>
      _CreateUpdateNoteViewScreenState();
}

class _CreateUpdateNoteViewScreenState
    extends State<CreateUpdateNoteViewScreen> {
//  DatabaseNote? _note;
//  late final NotesService _notesService;
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    //  _notesService = NotesService();
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  // Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
  //   final widgetNote = context.getArgument<DatabaseNote>();
  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    // final owner = await _notesService.getUser(email: email);
    // final newNote = await _notesService.createNote(owner: owner);
    final newNote =
        await _notesService.createNewNote(ownerUserId: currentUser.id);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      //   _notesService.deleteNote(id: note.id);
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      // await _notesService.updateNote(
      //   note: note,
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    // await _notesService.updateNote(
    //   note: note,
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        actions: [
          IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share(text);
                }
              },
              icon: Icon(Icons.share))
        ],
      ),
      // body: FutureBuilder<DatabaseNote>(
      body: FutureBuilder<CloudNote>(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration:
                    InputDecoration(hintText: 'Start typing your note...'),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
