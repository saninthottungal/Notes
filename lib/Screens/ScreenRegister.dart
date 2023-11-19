import 'package:firebase2/Services/Auth/AuthExceptions.dart';
import 'package:firebase2/Services/Auth/AuthSerivce.dart';
import 'package:firebase2/Widgets/SnackBar.dart';
import 'package:flutter/material.dart';

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
                        await AuthService.firebase()
                            .signUp(email: email, password: password);

                        Navigator.of(context).pushNamed("verify");
                      } on UserNotLoggedInAuthException {
                        SnackBaar.show(context, "User Not Found");
                      } on EmailAlreadyInUseAuthException catch (_) {
                        SnackBaar.show(context, "Email is already in use");
                      } on WeakPasswordAuthException catch (_) {
                        SnackBaar.show(
                            context, "Password must be atleast 6 characters");
                      } on InvalidEmailAuthException catch (_) {
                        SnackBaar.show(context, "Invalid Email");
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
