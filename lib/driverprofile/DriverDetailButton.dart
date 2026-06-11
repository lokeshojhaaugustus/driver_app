import 'package:driver_app/driverdetails/DriverDetailsScreen.dart';
import 'package:flutter/material.dart';

class DriverDetailButton extends StatelessWidget {
  const DriverDetailButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverDetailsScreen()));
      },
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.person_search_rounded, color: Colors.blueAccent, size: 22),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Driver Details", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 2),
                  Text("View and modify personal details", style: TextStyle(fontSize: 12, color: Colors.black38)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}