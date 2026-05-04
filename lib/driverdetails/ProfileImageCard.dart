import 'package:flutter/material.dart';

class ProfileImageCard extends StatelessWidget {
  const ProfileImageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage("assets/img/defaultdriverpic.jpg"),
      ),
    );
  }
}