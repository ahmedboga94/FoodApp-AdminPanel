import 'package:flutter/material.dart';
import 'package:foodappadmin/model/driver_model.dart';

class DriverCard extends StatelessWidget {
  final DriverModel driverModel;
  final Function() onPressed;
  final String buttonLabel;
  final bool isRed;

  const DriverCard(
      {super.key,
      required this.driverModel,
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
                          image: NetworkImage(driverModel.driverPhotoURL),
                          fit: BoxFit.fill))),
              title: Text(driverModel.driverName),
              trailing: Text(driverModel.driverEmail,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Text("Total Earnings: ${driverModel.earning} \$",
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
