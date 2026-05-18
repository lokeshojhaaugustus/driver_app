import 'package:driver_app/driverdetails/DriverDetailItem.dart';
import 'package:driver_app/driverdetails/LogoutButton.dart';
import 'package:driver_app/driverdetails/ProfileImageCard.dart';
import 'package:driver_app/service/SessionService.dart';
import 'package:flutter/material.dart';


class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({super.key});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {

  bool isEditing = false;

  // TEMP DATA (later bind with real driver)
  String name = "Lokesh";
  String surname = "Ojha";
  String phone = "8171422287";
  String license = "UK07BT";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔵 PROFILE IMAGE
            const ProfileImageCard(),

            const SizedBox(height: 20),

            // 🔽 DETAILS
            DriverDetailItem(
              label: "Name",
              value: name,
              isEditing: isEditing,
              onChanged: (val) => name = val,
            ),

            DriverDetailItem(
              label: "Surname",
              value: surname,
              isEditing: isEditing,
              onChanged: (val) => surname = val,
            ),

            DriverDetailItem(
              label: "Phone",
              value: phone,
              isEditing: isEditing,
              onChanged: (val) => phone = val,
            ),

            DriverDetailItem(
              label: "License",
              value: license,
              isEditing: isEditing,
              onChanged: (val) => license = val,
            ),

            const Spacer(),

            
            LogoutButton(
              onLogout: () {
                SessionService.clearSession();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            )
          ],
        ),
      ),
    );
  }
}