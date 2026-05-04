import 'package:flutter/material.dart';

class LoginText extends StatelessWidget {
  const LoginText({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 200,
      left: 30,
      child: 
        Text("Welcome!",
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ),
        ),
    );
  }
}