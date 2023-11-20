import 'package:firebase2/Services/Auth/AuthExceptions.dart';
import 'package:firebase2/Services/Auth/AuthSerivce.dart';
import 'package:firebase2/Widgets/SnackBar.dart';
import 'package:flutter/material.dart';

enum MenuActions {
  logOut,
  help,
}

class ScreenNotes extends StatelessWidget {
  const ScreenNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
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
      body: const SafeArea(
          child: Center(
        child: Text("Home Screen"),
      )),
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
