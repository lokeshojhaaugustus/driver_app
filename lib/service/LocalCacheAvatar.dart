import 'dart:io';
import 'package:driver_app/service/ProfileImageManager.dart';
import 'package:flutter/material.dart';

class LocalCacheAvatar extends StatelessWidget {
  final double radius;

  const LocalCacheAvatar({
    super.key,
    this.radius = 46,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: ProfileImageManager.getLocalImageFile(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.existsSync()) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: const Color(0xFFF1F5F9),
            backgroundImage: FileImage(snapshot.data!),
          );
        }

        
        return CircleAvatar(
          radius: radius,
          backgroundColor: const Color(0xFFF1F5F9),
          backgroundImage: const AssetImage("assets/img/defaultdriverpic.JPG"),
        );
      },
    );
  }
}