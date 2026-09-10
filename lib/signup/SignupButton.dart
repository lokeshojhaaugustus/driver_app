import 'package:flutter/material.dart';


class SignupButton extends StatelessWidget {
  final VoidCallback onSignup;
  const SignupButton({
    super.key, 
    required this.onSignup
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onSignup,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A5298),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create Account", 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold, 
                letterSpacing: 0.5
              )
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}