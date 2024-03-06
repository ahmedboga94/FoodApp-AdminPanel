import 'package:flutter/material.dart';
import 'package:foodappadmin/model/seller_model.dart';

class SellerCard extends StatelessWidget {
  final SellerModel sellerModel;
  final Function() onPressed;
  final String buttonLabel;
  final bool isRed;

  const SellerCard(
      {super.key,
      required this.sellerModel,
      required this.onPressed,
      this.isRed = true,
      required this.buttonLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Column(children: [
          const SizedBox(height: 8),
          ListTile(
              leading: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(sellerModel.sellerPhotoURL),
                          fit: BoxFit.fill))),
              title: Text(sellerModel.sellerName),
              trailing: Text(sellerModel.sellerEmail,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Text("Total Earnings: ${sellerModel.earning} \$",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
          ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  backgroundColor: isRed ? Colors.red : Colors.green),
              icon: const Icon(Icons.person_pin_sharp),
              label: Text(buttonLabel))
        ]),
      ),
    );
  }
}
