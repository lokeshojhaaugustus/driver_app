import 'package:flutter/material.dart';

class SignupButton extends StatefulWidget {
  final VoidCallback onSignup;
  const SignupButton({super.key, required this.onSignup});

  @override
  State<SignupButton> createState() => _SignupButtonState();
}

class _SignupButtonState extends State<SignupButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade900,
          ),
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade900,
          child: IconButton(
            color: Colors.white,
            onPressed: widget.onSignup,
            icon: Icon(Icons.arrow_forward_outlined),
          ),
        ),
      ],
    );
  }
}
