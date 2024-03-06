import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodappadmin/main_screens/home_screen.dart';
import 'package:foodappadmin/widget/app_app_bar.dart';

class LoginScreen extends StatefulWidget {
  static String id = "loginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String adminEmail = "";
  String adminPassword = "";

  allowAdminLogin() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Checking Credientials, Loading ..."),
        duration: Duration(seconds: 1)));

    User? currentAdmin;

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: adminEmail, password: adminPassword)
        .then((userCredential) {
      currentAdmin = userCredential.user;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Login Successfully"), duration: Duration(seconds: 1)));
    }).catchError((onError) {
      final snackBar = SnackBar(
          content: Text("Error Occured : $onError"),
          duration: const Duration(seconds: 3));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    if (currentAdmin != null) {
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(currentAdmin!.uid)
          .get()
          .then((snap) {
        if (snap.exists) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "No record found, Please Contact with support services")));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "Login to Admin Portal"),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Image.asset("assets/images/admin.png"),
                TextFormField(
                  onChanged: (value) => adminEmail = value,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 3)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amberAccent, width: 3)),
                      hintText: "Email",
                      icon: Icon(Icons.email, color: Colors.cyan)),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  onChanged: (value) => adminPassword = value,
                  obscureText: true,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan, width: 3)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.amberAccent, width: 3)),
                      hintText: "Password",
                      icon:
                          Icon(Icons.admin_panel_settings, color: Colors.cyan)),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => allowAdminLogin(),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      backgroundColor: Colors.cyan),
                  child: const Text("Login",
                      style: TextStyle(fontSize: 16, letterSpacing: 2)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
