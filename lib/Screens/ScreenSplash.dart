import 'package:firebase2/Screens/EmailVerify.dart';
import 'package:firebase2/Screens/ScreenNotes.dart';
import 'package:firebase2/Screens/ScreenLogin.dart';
import 'package:firebase2/Services/Auth/AuthSerivce.dart';
import 'package:flutter/material.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().firebaseInitialize(),
        builder: (ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().getCurrentUser();

              if (user != null) {
                user.refreshUser();
                if (user.isEmailVerified) {
                  return const ScreenNotes();
                } else {
                  return const EmailVerify();
                }
              } else {
                return const ScreenLogin();
              }

            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
