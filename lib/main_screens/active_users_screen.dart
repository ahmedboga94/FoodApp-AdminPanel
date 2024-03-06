import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappadmin/model/user_model.dart';
import 'package:foodappadmin/widget/app_app_bar.dart';
import 'package:foodappadmin/widget/user_card.dart';

class ActiveUsersScreen extends StatefulWidget {
  const ActiveUsersScreen({super.key});

  @override
  State<ActiveUsersScreen> createState() => _ActiveUsersScreenState();
}

class _ActiveUsersScreenState extends State<ActiveUsersScreen> {
  displayBlockingAccount(String userID) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block Account",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        content: const Text("Do you want to block this account?",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: const Text("NO")),
          ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(userID)
                    .update({"status": "not approved"}).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("User is Blocked Successfully"),
                      duration: Duration(seconds: 1)));
                  Navigator.pop(context);
                });
              },
              child: const Text("Yes")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "Active Users"),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("status", isEqualTo: "approved")
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : snapshot.data!.docs.isEmpty
                  ? const Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.remove_shopping_cart_outlined,
                                size: 150, color: Colors.cyan),
                            Text("No Record found.",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))
                          ]),
                    )
                  : ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final userModel = UserModel.fromJson(
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>);
                        return UserCard(
                            userModel: userModel,
                            buttonLabel: "BLOCK THIS ACCOUNT",
                            onPressed: () =>
                                displayBlockingAccount(userModel.userUID));
                      },
                    );
        },
      ),
    );
  }
}
