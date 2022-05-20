import 'package:flutter/material.dart';

class NewNoteViewScreen extends StatefulWidget {
  static const routeName = '/new_note_view';
  const NewNoteViewScreen({super.key});

  @override
  State<NewNoteViewScreen> createState() => _NewNoteViewScreenState();
}

class _NewNoteViewScreenState extends State<NewNoteViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Note')),
      body: Text('Write your new note here...'),
    );
  }
}
