import 'package:flutter/material.dart';

class LoginGoogleButton extends StatelessWidget {
  const LoginGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        debugPrint("Google Login!");
      },
      icon: const Icon(Icons.g_mobiledata, size: 28),
      label: const Text("Google"),
    );
  }
}
