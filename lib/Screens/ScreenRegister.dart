import 'package:firebase2/Widgets/SnackBar.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "E-mail", border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      hintText: "Password", border: OutlineInputBorder()),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscuringCharacter: "*",
                ),
                ElevatedButton(
                    onPressed: () async {
                      final email = emailController.text;
                      final password = passwordController.text;
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password);
                        Navigator.of(context).pushNamed("verify");
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'email-already-in-use') {
                          SnackBaar.show(context, "Email is already in use");
                        } else if (e.code == 'weak-password') {
                          SnackBaar.show(
                              context, "Password must be atleast 6 characters");
                        } else if (e.code == 'invalid-email') {}
                      }
                    },
                    child: const Text("Register")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("login");
                    },
                    child: const Text("Already a user?\n         Login")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
