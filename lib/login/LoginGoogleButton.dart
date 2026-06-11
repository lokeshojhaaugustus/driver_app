import 'package:flutter/material.dart';

class LoginGoogleButton extends StatelessWidget {
  const LoginGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => debugPrint("Google Login!"),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: Colors.grey.shade200, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.g_mobiledata_rounded, size: 24, color: Colors.redAccent),
          SizedBox(width: 4),
          Text("Google", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}