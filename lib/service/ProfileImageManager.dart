import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ProfileImageManager {
  
  static Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/current_driver_profile.jpg');
  }

  
  static Future<bool> hasLocalImage() async {
    final file = await _localFile;
    return await file.exists();
  }

  
  static Future<File> getLocalImageFile() async {
    return await _localFile;
  }

  
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

  
  static Future<void> overwriteLocalFile(File newlyCroppedFile) async {
    try {
      final file = await _localFile;
      
      await newlyCroppedFile.copy(file.path);
      await FileImage(file).evict(); 
      debugPrint("Local profile image source of truth overridden.");
    } catch (e) {
      debugPrint("Error overwriting local profile file: $e");
    }
  }
}