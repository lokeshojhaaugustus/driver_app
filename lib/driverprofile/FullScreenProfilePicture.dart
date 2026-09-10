import 'dart:io';
import 'package:driver_app/apiservice/DriverApiService.dart'; 
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/service/ImageService.dart'; 
import 'package:driver_app/service/LocalCacheAvatar.dart';
import 'package:driver_app/service/ProfileImageManager.dart'; // <--- 1. NEW IMPORT ADDED HERE
import 'package:flutter/material.dart';

class FullScreenProfilePicture extends StatefulWidget {
  final Driver driver;
  final Function(String newUrl) onImageUpdated; 

  const FullScreenProfilePicture({
    super.key, 
    required this.driver, 
    required this.onImageUpdated,
  });

  @override
  State<FullScreenProfilePicture> createState() => _FullScreenProfilePictureState();
}

class _FullScreenProfilePictureState extends State<FullScreenProfilePicture> {
  bool _isUploading = false;

  Future<void> _handleImageEdit(BuildContext context) async {
    final File? croppedImage = await ImageService.pickAndCropSquareImage(context);
    if (croppedImage == null) return; 

    setState(() => _isUploading = true);


    final String? newImageUrl = await DriverApiService.uploadImage(
      croppedImage, 
      widget.driver.driverId ?? 0,
    );


    if (newImageUrl != null) {

      await ProfileImageManager.overwriteLocalFile(croppedImage);


      widget.onImageUpdated(newImageUrl);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile picture updated successfully!")),
        );
        Navigator.of(context).pop(); 
      }
    } else {
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload failed. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.85),
      body: GestureDetector(
        onTap: _isUploading ? null : () => Navigator.of(context).pop(),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () {}, 
                child: _isUploading
                    ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text("Uploading new picture...", style: TextStyle(color: Colors.white70)),
                        ],
                      )
                    : const Hero(
                        tag: 'avatar-profile-hero',
                        
                        child: LocalCacheAvatar(
                          radius: 200, 
                        ),
                      ),
              ),
            ),
            
            // Core Actions Footer
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {}, 
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: const Text("Edit Image"),
                        onPressed: _isUploading ? null : () => _handleImageEdit(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        label: const Text("Remove"),
                        onPressed: _isUploading ? null : () {
                          // for later
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}