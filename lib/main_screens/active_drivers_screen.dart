import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappadmin/model/driver_model.dart';
import 'package:foodappadmin/widget/app_app_bar.dart';
import 'package:foodappadmin/widget/driver_card.dart';

class ActiveDriversScreen extends StatefulWidget {
  const ActiveDriversScreen({super.key});

  @override
  State<ActiveDriversScreen> createState() => _ActiveDriversScreenState();
}

class _ActiveDriversScreenState extends State<ActiveDriversScreen> {
  displayBlockingAccount(String driverID) {
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
                    .collection("drivers")
                    .doc(driverID)
                    .update({"status": "not approved"}).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Driver is Blocked Successfully"),
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
      appBar: const AppAppBar(title: "Active Drivers"),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("drivers")
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
                        final driverModel = DriverModel.fromJson(
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>);
                        return DriverCard(
                            driverModel: driverModel,
                            buttonLabel: "BLOCK THIS ACCOUNT",
                            onPressed: () =>
                                displayBlockingAccount(driverModel.driverUID));
                      },
                    );
        },
      ),
    );
  }
}
