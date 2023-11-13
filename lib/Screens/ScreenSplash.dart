import 'package:firebase2/Screens/EmailVerify.dart';
import 'package:firebase2/Screens/ScreenHome.dart';
import 'package:firebase2/Screens/ScreenLogin.dart';

import 'package:firebase2/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  return const ScreenHome();
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
