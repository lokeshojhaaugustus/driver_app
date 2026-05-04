import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
      return Row(
          children: [
            Expanded(
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10
              ),
              child: Text(
                "OR"
              ),
            ),
            Expanded(
              child: Divider(),
            )
          ],
        );
  }
}