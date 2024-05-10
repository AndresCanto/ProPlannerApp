import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  //current logged un user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  //future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50,),
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: getUserDetails(),
              builder: (context, snapshot) {
                //loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                //error
                else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                }
                //data received
                else if (snapshot.hasData) {
                  //extract data
                  Map<String, dynamic>? user = snapshot.data!.data();

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.all(25),
                          child: const Icon(
                            Icons.person,
                            size: 80,
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          user!['username'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user['email'],
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text("No user data");
                }
              },
            ),
            const SizedBox(height: 200,),
            GestureDetector(
              onTap: logout,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                child: const Text(
                  "Cerrar sesión",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
