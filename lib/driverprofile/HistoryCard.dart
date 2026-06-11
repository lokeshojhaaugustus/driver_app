import 'package:driver_app/history/HistoryScreen.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final Driver driver;
  const HistoryCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final driverId = driver.driverId;
        if (driverId == null) return;
        Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryScreen(driverId: driverId)));
      },
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.purple.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.history_toggle_off_rounded, color: Colors.purpleAccent, size: 22),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Trip History", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                  SizedBox(height: 2),
                  Text("View completed trips", style: TextStyle(fontSize: 12, color: Colors.black38)),
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