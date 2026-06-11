import 'package:driver_app/login/LoginAppleButton.dart';
import 'package:driver_app/login/LoginGoogleButton.dart';
import 'package:driver_app/login/Separator.dart';
import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Separator(),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(child: LoginGoogleButton()),
            const SizedBox(width: 12),
            const Expanded(child: LoginAppleButton()),
          ],
        ),
      ],
    );
  }
}