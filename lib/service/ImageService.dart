import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery and enforces a strict 1:1 crop window
  static Future<File?> pickAndCropSquareImage(BuildContext context) async {
    try {
      // 1. Pick the raw file from device storage gallery
      final XFile? rawFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Optimizes compression before transit
      );

      if (rawFile == null) return null;

      // 2. Open the image cropper forcing 1:1 aspect ratios
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: rawFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0), // Forces perfect square
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Picture',
            toolbarColor: const Color(0xFF1E3C72),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true, // Prevents resizing away from 1:1 square
          ),
          IOSUiSettings(
            title: 'Crop Profile Picture',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) return null;
      return File(croppedFile.path);
    } catch (e) {
      debugPrint("Error during image processing: $e");
      return null;
    }
  }
}