import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappadmin/model/user_model.dart';
import 'package:foodappadmin/widget/app_app_bar.dart';
import 'package:foodappadmin/widget/user_card.dart';

class BlockUsersScreen extends StatefulWidget {
  const BlockUsersScreen({super.key});

  @override
  State<BlockUsersScreen> createState() => _BlockUsersScreenState();
}

class _BlockUsersScreenState extends State<BlockUsersScreen> {
  displayActivatingAccount(userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Activate Account",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        content: const Text("Do you want to activate this account?",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: const Text("NO")),
          ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(userID)
                    .update({"status": "approved"}).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("User is Activated Successfully"),
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
      appBar: const AppAppBar(title: "Blocked Users"),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("status", isEqualTo: "not approved")
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
                            buttonLabel: "ACTIVATE THIS ACCOUNT",
                            isRed: false,
                            onPressed: () =>
                                displayActivatingAccount(userModel.userUID));
                      },
                    );
        },
      ),
    );
  }
}
