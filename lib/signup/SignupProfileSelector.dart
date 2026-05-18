import 'package:flutter/material.dart';

class SignupProfileSelector extends StatefulWidget {
  const SignupProfileSelector({super.key});

  @override
  State<SignupProfileSelector> createState() => _SignupProfileSelectorState();
}

class _SignupProfileSelectorState extends State<SignupProfileSelector> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: AssetImage("assets/img/defaultdriverpic.JPG"),
          ),
        ],
      ),
    );
  }
}
