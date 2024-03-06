import 'package:flutter/material.dart';
import 'package:foodappadmin/model/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel userModel;
  final Function() onPressed;
  final String buttonLabel;
  final bool isRed;

  const UserCard(
      {super.key,
      required this.userModel,
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
                          image: NetworkImage(userModel.userPhotoURL),
                          fit: BoxFit.fill))),
              title: Text(userModel.userName),
              trailing: Text(userModel.userEmail,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
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
