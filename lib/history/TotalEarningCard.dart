import 'package:flutter/material.dart';

class TotalEarningCard extends StatelessWidget {
  final double totalEarning;

  const TotalEarningCard({super.key, required this.totalEarning});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Earning", style: TextStyle(color: Colors.white)),
          SizedBox(height: 10),
          Text(
            "Rs ${totalEarning.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
