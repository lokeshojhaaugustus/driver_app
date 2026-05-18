import 'package:driver_app/driverdetails/DriverDetailsScreen.dart';
import 'package:flutter/material.dart';

class DriverDetailButton extends StatelessWidget {
  const DriverDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DriverDetailsScreen()),
            );
          },
          child: const Text("Driver Details", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
