import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../helper/helper_function.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // login method
  void login() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //display error message to the user
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            // logo
            Icon(
              Icons.deblur,
              size: 200,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 25),

            // app name
            const Center(
              child: Text(
                "PRO PLANNER",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 50),

            // email textfield
            MyTextField(
              hintText: "Correo",
              obscureText: false,
              controller: emailController,
            ),
            const SizedBox(height: 25),

            //password textfield
            MyTextField(
              hintText: "Contraseña",
              obscureText: true,
              controller: passwordController,
            ),
            const SizedBox(height: 10),

            // forgot password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Olvidaste tu contraseña?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // login button
            MyButton(
              text: "Iniciar sesión",
              onTap: login,
            ),
            const SizedBox(height: 20),

            //dont have an account? Register here
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "No tienes una cuenta?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    " Crear cuenta.",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
