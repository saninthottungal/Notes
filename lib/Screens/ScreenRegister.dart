import 'package:firebase2/Screens/ScreenLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';
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
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(10),
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
                              hintText: "Password",
                              border: OutlineInputBorder()),
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
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'email-already-in-use') {
                                  print("email is already in use");
                                } else if (e.code == 'weak-password') {
                                  print("The password is too weak");
                                } else if (e.code == 'invalid-email') {
                                  print("invalid email adresss");
                                }
                              }
                            },
                            child: const Text("Register")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ScreenLogin()));
                            },
                            child:
                                const Text("Already a user?\n         Login")),
                      ],
                    ),
                  ),
                );
              default:
                return const Text("Loading");
            }
          }),
    );
  }
}
