import 'package:flutter/material.dart';

class SignupText extends StatelessWidget {
  const SignupText({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 150,
      left: 30,
      child: Text(
        "Sign Up!",
        style: TextStyle(fontSize: 40, color: Colors.white),
      ),
    );
  }
}
