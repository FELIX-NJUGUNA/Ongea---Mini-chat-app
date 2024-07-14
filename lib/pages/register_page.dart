import 'package:flutter/material.dart';
import 'package:ongea_chat_app/services/auth/auth_service.dart';
import 'package:ongea_chat_app/components/my_button.dart';
import 'package:ongea_chat_app/components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  //final _formKey = GlobalKey<FormState>();

  // Email validation
  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email';
    }
    // Check if the entered email is valid
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Password validation
  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    // Add more password criteria if needed
    return null;
  }

  // Confirm password validation
  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // register
  void _register(BuildContext context) {
    final auth = AuthService();

    if (passwordController.text == confirmPasswordController.text) {
      try {
        auth.signUpWithEmailPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    }
    // password don't match -> show errorto user
    else {
      showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(title: Text("Password don't match")),
      );
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
              "Let's create an account for you.",
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
              controller: emailController,
            ),

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

            MyTextfield(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmPasswordController),

            const SizedBox(
              height: 25,
            ),

            // button login
            MyButton(text: "Register", onTap: () => _register(context)),

            const SizedBox(
              height: 50,
            ),

            //Register not having an account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                const SizedBox(
                  width: 4,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Log In",
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
