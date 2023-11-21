import 'package:flutter/material.dart';

class ScreenAddNote extends StatefulWidget {
  const ScreenAddNote({super.key});

  @override
  State<ScreenAddNote> createState() => _ScreenAddNoteState();
}

class _ScreenAddNoteState extends State<ScreenAddNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
      ),
    );
  }
}
