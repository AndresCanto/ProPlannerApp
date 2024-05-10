import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/components/my_button.dart';
import 'package:notes_app/components/my_textfield.dart';
import 'package:notes_app/helper/helper_function.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  // reister method
  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    //make sure passwords match
    if (passwordController.text != confirmPwController.text) {
      // pop loading circle
      Navigator.pop(context);

      //show error message to user
      displayMessageToUser("Las contraseñas no coinciden!!", context);
    }
    // if passwords do match
    else {
      //try creating the user
      try {
        // create the user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // create a user document and add to firestore
        createUserDocument(userCredential);

        // pop loading circle
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        //pop loading circle
        Navigator.pop(context);
        //display error message to the user
        displayMessageToUser(e.code, context);
      }
    }
  }

  // create a user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
      });
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
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 50),

            // username textfield
            MyTextField(
              hintText: "Nombre",
              obscureText: false,
              controller: usernameController,
            ),
            const SizedBox(height: 25),

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
            const SizedBox(height: 25),

            //confirm password textfield
            MyTextField(
              hintText: "Confirmar contraseña",
              obscureText: true,
              controller: confirmPwController,
            ),
            const SizedBox(height: 50),

            // register button
            MyButton(
              text: "Crear cuenta",
              onTap: registerUser,
            ),
            const SizedBox(height: 20),

            //dont have an account? Register here
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Ya tienes una cuenta?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    " Inicia sesión aqui.",
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
