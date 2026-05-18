import 'package:flutter/material.dart';

class SignupBackground extends StatelessWidget {
  const SignupBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/register.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
