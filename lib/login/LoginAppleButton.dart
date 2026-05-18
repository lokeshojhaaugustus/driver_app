import 'package:flutter/material.dart';

class LoginAppleButton extends StatelessWidget {
  const LoginAppleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        debugPrint("Apple Login!");
      },
      icon: const Icon(Icons.apple),
      label: const Text("Apple"),
    );
  }
}
