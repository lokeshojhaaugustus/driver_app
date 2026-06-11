import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;
  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onLogout,
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: const Text(
          "Sign Out Account",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: 0.3),
        ),
        style: OutlinedButton.styleFrom(
          //textColor: Colors.red,
          side: const BorderSide(color: Color(0xFFFFD6D6), width: 1.5),
          backgroundColor: const Color(0xFFFFF5F5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}