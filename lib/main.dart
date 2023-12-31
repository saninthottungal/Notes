import 'package:firebase2/Screens/EmailVerify.dart';
import 'package:firebase2/Screens/ScreenNote.dart/ScreenNotes.dart';
import 'package:firebase2/Screens/ScreenLogin.dart';
import 'package:firebase2/Screens/ScreenRegister.dart';
import 'package:firebase2/Screens/ScreenSplash.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: const ScreenSplash(),
        routes: {
          "login": (context) => const ScreenLogin(),
          "register": (context) => const ScreenRegister(),
          "notes": (context) => const ScreenNotes(),
          "verify": (context) => const EmailVerify(),
        });
  }
}
