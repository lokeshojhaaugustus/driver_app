import 'package:flutter/material.dart';

class DriverStatCard extends StatelessWidget {

  final IconData icon;
  final String value;
  final String lable;

  const DriverStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.lable
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,size: 30),
          SizedBox(
            height: 10,
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(lable)
        ],
      ),
    );
  }
}