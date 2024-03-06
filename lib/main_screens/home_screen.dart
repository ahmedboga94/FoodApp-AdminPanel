import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodappadmin/authantication/login_screen.dart';
import 'package:foodappadmin/main_screens/active_drivers_screen.dart';
import 'package:foodappadmin/main_screens/active_sellers_screen.dart';
import 'package:foodappadmin/main_screens/active_users_screen.dart';
import 'package:foodappadmin/main_screens/block_drivers_screen.dart';
import 'package:foodappadmin/main_screens/block_sellers_screen.dart';
import 'package:foodappadmin/main_screens/block_users_screen.dart';

import 'package:intl/intl.dart';

import '../widget/app_app_bar.dart';

class HomeScreen extends StatefulWidget {
  static String id = "homeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String time = "";
  String date = "";

  String formateCurrentTime(DateTime time) {
    return DateFormat("hh:mm:ss a").format(time);
  }

  String formateCurrentDate(DateTime date) {
    return DateFormat("dd MMMM, yyyy").format(date);
  }

  getCurrentLiveTime() {
    final DateTime timeNow = DateTime.now();
    final String liveTime = formateCurrentTime(timeNow);
    final String liveDate = formateCurrentDate(timeNow);

    if (mounted) {
      setState(() {
        time = liveTime;
        date = liveDate;
      });
    }
  }

  @override
  void initState() {
    time = formateCurrentTime(DateTime.now());
    date = formateCurrentDate(DateTime.now());

    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCurrentLiveTime();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "Admin Panel"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text(time, style: const TextStyle(fontSize: 22)),
              Text(date, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 25),
              Text("Users".toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 35)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ActiveUsersScreen()));
                      },
                      icon: const Icon(Icons.person_add),
                      label: Text("Activate Accounts".toUpperCase(),
                          style: const TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan)),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BlockUsersScreen()));
                      },
                      icon: const Icon(Icons.block_flipped),
                      label: Text("Block Accounts".toUpperCase(),
                          style: const TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber))
                ],
              ),
              const SizedBox(height: 25),
              Text("Sellers".toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 35)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ActiveSellersScreen()));
                      },
                      icon: const Icon(Icons.person_add),
                      label: Text("Activate Accounts".toUpperCase(),
                          style: const TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan)),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BlockSellersScreen()));
                      },
                      icon: const Icon(Icons.block_flipped),
                      label: Text("Block Accounts".toUpperCase(),
                          style: const TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber))
                ],
              ),
              const SizedBox(height: 25),
              Text("Drivers".toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 35)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ActiveDriversScreen()));
                      },
                      icon: const Icon(Icons.person_add),
                      label: Text("Activate Accounts".toUpperCase(),
                          style: const TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan)),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const BlockDriversScreen()));
                      },
                      icon: const Icon(Icons.block_flipped),
                      label: Text("Block Accounts".toUpperCase(),
                          style: const TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber))
                ],
              ),
              const SizedBox(height: 60),
              ElevatedButton.icon(
                  onPressed: () => FirebaseAuth.instance.signOut().then(
                      (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.id, (route) => false)),
                  icon: const Icon(Icons.logout),
                  label: Text("Logout".toUpperCase()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.all(15))),
            ],
          ),
        ),
      ),
    );
  }
}
