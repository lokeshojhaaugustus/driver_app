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
        SizedBox(height: 10),
        Separator(),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [LoginGoogleButton(), LoginAppleButton()],
        ),
      ],
    );
  }
}
