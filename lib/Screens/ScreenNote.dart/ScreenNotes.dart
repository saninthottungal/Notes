import 'package:firebase2/Screens/ScreenNote.dart/ScreenAddNote.dart';
import 'package:firebase2/Services/Auth/AuthExceptions.dart';
import 'package:firebase2/Services/Auth/AuthSerivce.dart';
import 'package:firebase2/Services/Crud/notes_service.dart';
import 'package:firebase2/Widgets/SnackBar.dart';
import 'package:flutter/material.dart';

enum MenuActions {
  logOut,
  help,
}

class ScreenNotes extends StatefulWidget {
  const ScreenNotes({super.key});

  @override
  State<ScreenNotes> createState() => _ScreenNotesState();
}

class _ScreenNotesState extends State<ScreenNotes> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().getCurrentUser()!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          PopupMenuButton<MenuActions>(onSelected: (value) async {
            switch (value) {
              case MenuActions.help:
              //helppppp
              case MenuActions.logOut:
                final stat = await showLogoutDialogue(context);

                if (stat) {
                  try {
                    AuthService.firebase().signOut();

                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("login", (route) => false);
                  } on UserNotLoggedInAuthException catch (_) {
                    SnackBaar.show(context, "User Not Logged In");
                  }
                }
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuActions>(
                value: MenuActions.logOut,
                child: Text("Log Out"),
              ),
              PopupMenuItem<MenuActions>(
                value: MenuActions.help,
                child: Text("Help"),
              ),
            ];
          }),
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Text("waiting for notes");
                      default:
                        return const CircularProgressIndicator();
                    }
                  });

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ScreenAddNote()));
          },
          child: const Icon(Icons.add)),
    );
  }
}

Future<bool> showLogoutDialogue(BuildContext ctx) {
  return showDialog<bool>(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Log Out?"),
          content: const Text("Do you really want to sign out?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text("Log Out")),
          ],
        );
      }).then((value) => value ?? false);
}
