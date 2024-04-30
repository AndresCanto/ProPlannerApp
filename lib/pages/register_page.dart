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
      displayMessageToUser("Passwords don't match!!", context);
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

        // pop loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        //pop loading circle
        Navigator.pop(context);
        //display error message to the user
        displayMessageToUser(e.code, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),

              // app name
              const Text(
                "PRO PLANNER",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),

              // username textfield
              MyTextField(
                hintText: "Username",
                obscureText: false,
                controller: usernameController,
              ),
              const SizedBox(height: 10),

              // email textfield
              MyTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 10),

              //password textfield
              MyTextField(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),

              //confirm password textfield
              MyTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmPwController,
              ),
              const SizedBox(height: 25),

              // register button
              MyButton(
                text: "Register",
                onTap: registerUser,
              ),
              const SizedBox(height: 10),

              //dont have an account? Register here
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Alreadey have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Login here.",
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
      ),
    );
  }
}
