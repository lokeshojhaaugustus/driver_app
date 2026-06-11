import 'package:flutter/material.dart';

class LoginAppleButton extends StatelessWidget {
  const LoginAppleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => debugPrint("Apple Login!"),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: Colors.grey.shade200, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.apple, size: 20, color: Colors.black),
          SizedBox(width: 6),
          Text("Apple", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}