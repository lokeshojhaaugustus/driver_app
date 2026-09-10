import 'package:flutter/material.dart';

class LoginTextButtons extends StatelessWidget {
  const LoginTextButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pushNamed("/signup"),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF2A5298)),
          child: const Text("Create Account", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(foregroundColor: Colors.black54),
          child: const Text("Forgot Password?", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}