import 'package:flutter/material.dart';

class SignupTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController controller;

  const SignupTextField({
    super.key,
    required this.hint,
    required this.isPassword,
    required this.controller
  });

  @override
  State<SignupTextField> createState() => _SignupTextFieldState();
}

class _SignupTextFieldState extends State<SignupTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword,
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled:true,
        hintText: widget.hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
    );
  }
}