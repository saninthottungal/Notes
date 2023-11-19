import 'package:firebase2/Services/Auth/AuthExceptions.dart';
import 'package:firebase2/Services/Auth/AuthSerivce.dart';
import 'package:firebase2/Widgets/SnackBar.dart';
import 'package:flutter/material.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
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
        title: const Text("Login"),
      ),
      body: SafeArea(
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
                      final user = await AuthService.firebase()
                          .signIn(email: email, password: password);

                      if (!user.isEmailVerified) {
                        Navigator.of(context).pushNamed("verify");
                      } else {
                        Navigator.of(context).pushReplacementNamed("home");
                      }
                    } on UserNotLoggedInAuthException catch (_) {
                      SnackBaar.show(context, "User Not Found");
                    } on InvalidUserCredentialsAuthException catch (_) {
                      SnackBaar.show(context, "Invalid User Credentials");
                    } on GenericAuthExceptions catch (_) {
                      SnackBaar.show(context, "Invalid User Credentials");
                    }
                  },
                  child: const Text("Login")),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("register", (route) => false);
                  },
                  child: const Text("New to firebase?\n   Register here")),
            ],
          ),
        ),
      ),
    );
  }
}
