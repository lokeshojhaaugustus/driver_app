import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginButton({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Sign In",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade900,
          ),
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade500,
          child: IconButton(
            onPressed: onLogin,
            icon: Icon(Icons.arrow_forward_outlined),
          ),
        ),
      ],
    );
  }
}
