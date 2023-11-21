import 'package:firebase2/Services/Auth/AuthExceptions.dart';
import 'package:firebase2/Services/Auth/AuthSerivce.dart';
import 'package:firebase2/Widgets/SnackBar.dart';
import 'package:flutter/material.dart';

class EmailVerify extends StatelessWidget {
  const EmailVerify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          const Text(
            "Click the button below to verify your email",
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                AuthService.firebase().sendEmailVerification();

                SnackBaar.show(
                    context, "E-mail Verification has been initiated");
              } on UserNotLoggedInAuthException catch (_) {
                SnackBaar.show(context, "User Not Logged In");
              }
            },
            child: const Text("Verify"),
          ),
          ElevatedButton(
              onPressed: () async {
                final user = AuthService.firebase().getCurrentUser();
                if (user != null) {
                  user.refreshUser();
                  if (user.isEmailVerified) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("notes", (route) => false);
                  } else {
                    SnackBaar.show(context, "Your email is not verified yet");
                  }
                } else {
                  SnackBaar.show(context, "User Not Logged In");
                }
              },
              child: const Text("Refresh")),
        ],
      ),
    );
  }
}
