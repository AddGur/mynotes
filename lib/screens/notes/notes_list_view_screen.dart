import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:login_app/services/crud/notes_service.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NotesListViewScreen extends StatelessWidget {
  static const routeName = '/notes_list';

  final List<DatabaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListViewScreen(
      {super.key,
      required this.notes,
      required this.onDeleteNote,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              }),
        );
      },
      itemCount: notes.length,
    );
    ;
  }
}
