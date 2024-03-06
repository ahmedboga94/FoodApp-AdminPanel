import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappadmin/model/seller_model.dart';
import 'package:foodappadmin/widget/app_app_bar.dart';
import 'package:foodappadmin/widget/seller_card.dart';

class ActiveSellersScreen extends StatefulWidget {
  const ActiveSellersScreen({super.key});

  @override
  State<ActiveSellersScreen> createState() => _ActiveSellersScreenState();
}

class _ActiveSellersScreenState extends State<ActiveSellersScreen> {
  displayBlockingAccount(String sellerID) {
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
                    .collection("sellers")
                    .doc(sellerID)
                    .update({"status": "not approved"}).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Seller is Blocked Successfully"),
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
      appBar: const AppAppBar(title: "Active Sellers"),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("sellers")
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
                        final sellerModel = SellerModel.fromJson(
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>);
                        return SellerCard(
                            sellerModel: sellerModel,
                            buttonLabel: "BLOCK THIS ACCOUNT",
                            onPressed: () =>
                                displayBlockingAccount(sellerModel.sellerUID));
                      },
                    );
        },
      ),
    );
  }
}
