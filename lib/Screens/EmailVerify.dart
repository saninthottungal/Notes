import 'package:firebase2/Widgets/SnackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
              SnackBaar.show(context, "E-mail Verification has been initiated");
            },
            child: const Text("Verify"),
          ),
          ElevatedButton(
              onPressed: () async {
                final user = await FirebaseAuth.instance.currentUser;
                user?.reload();
                if (user!.emailVerified) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("home", (route) => false);
                } else {
                  SnackBaar.show(context, "Your email is not verified yet");
                }
              },
              child: const Text("Refresh")),
        ],
      ),
    );
  }
}
