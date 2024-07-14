import 'package:flutter/material.dart';
import 'package:ongea_chat_app/services/auth/auth_service.dart';
import 'package:ongea_chat_app/components/my_button.dart';
import 'package:ongea_chat_app/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login method

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 60,
            ),

            const SizedBox(
              height: 50,
            ),

            Text(
              "Welcome back!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // email
            MyTextfield(
                hintText: "E-mail",
                obscureText: false,
                controller: emailController),

            const SizedBox(
              height: 10,
            ),
            MyTextfield(
                hintText: "Password",
                obscureText: true,
                controller: passwordController),
            const SizedBox(
              height: 10,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Forgot Password ?",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  )
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // button login
            MyButton(text: "Log In", onTap: () => login(context)),

            const SizedBox(
              height: 50,
            ),

            //Register not having an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                const SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Register",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
