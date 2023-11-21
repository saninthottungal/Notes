import 'package:firebase2/Services/Auth/AuthSerivce.dart';
import 'package:firebase2/Services/Crud/NotesDatabase.dart';
import 'package:firebase2/Services/Crud/notes_service.dart';
import 'package:flutter/material.dart';

class ScreenAddNote extends StatefulWidget {
  const ScreenAddNote({super.key});

  @override
  State<ScreenAddNote> createState() => _ScreenAddNoteState();
}

class _ScreenAddNoteState extends State<ScreenAddNote> {
  DatabaseNotes? _note;
  late final NotesService _notesService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesService = NotesService();
    _textEditingController = TextEditingController();
    super.initState();
  }

  Future<DatabaseNotes> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().getCurrentUser()!;
    final email = currentUser.email!;
    final user = await _notesService.getUser(email: email);
    final note = await _notesService.createNote(user: user);

    return note;
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      await _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(note: note, text: text);
    }
  }

  void _textControllerListner() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListner() {
    _textEditingController.removeListener(_textControllerListner);
    _textEditingController.addListener(_textControllerListner);
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNotes;
              _setupTextControllerListner();
              return TextField(
                decoration: const InputDecoration(
                    hintText: "start typing your note..."),
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
