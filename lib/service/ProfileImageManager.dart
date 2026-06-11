import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ProfileImageManager {
  /// Returns the fixed, local file path where our active profile pic always lives
  static Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/current_driver_profile.jpg');
  }

  /// Check if we have a locally stored profile image
  static Future<bool> hasLocalImage() async {
    final file = await _localFile;
    return await file.exists();
  }

  /// Return the File instance directly
  static Future<File> getLocalImageFile() async {
    return await _localFile;
  }

  /// Syncs the image from the server (Used during login or session restoration)
  static Future<void> syncFromRemote(String? remoteUrl) async {
    if (remoteUrl == null || remoteUrl.isEmpty) return;

    try {
      final file = await _localFile;
      final response = await http.get(Uri.parse(remoteUrl));
      
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        await FileImage(file).evict(); // Drop old image from Flutter RAM
        debugPrint("Successfully synced profile image to local storage.");
      }
    } catch (e) {
      debugPrint("Error syncing remote image to local file: $e");
    }
  }

  /// Overwrites the local file instantly when a user crops and accepts a new image
  static Future<void> overwriteLocalFile(File newlyCroppedFile) async {
    try {
      final file = await _localFile;
      // Copy the cropped file's bytes over our single source of truth path
      await newlyCroppedFile.copy(file.path);
      await FileImage(file).evict(); // Evict from Flutter RAM immediately
      debugPrint("Local profile image source of truth overridden.");
    } catch (e) {
      debugPrint("Error overwriting local profile file: $e");
    }
  }
}