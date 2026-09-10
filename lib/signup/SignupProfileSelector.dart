import 'dart:io';
import 'package:driver_app/service/ImageService.dart';
import 'package:flutter/material.dart';

class SignupProfileSelector extends StatefulWidget {
  final File? selectedImage;
  final ValueChanged<File?> onImageSelected;

  const SignupProfileSelector({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
  });

  @override
  State<SignupProfileSelector> createState() => _SignupProfileSelectorState();
}

class _SignupProfileSelectorState extends State<SignupProfileSelector> {
  bool _isProcessing = false;

  Future<void> _handleImageSelection() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    final File? croppedImage = await ImageService.pickAndCropSquareImage(context);
    
    if (croppedImage != null) {
      widget.onImageSelected(croppedImage);
    }

    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          GestureDetector(
            onTap: _handleImageSelection,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF2A5298).withOpacity(0.2), width: 2),
              ),
              child: CircleAvatar(
                radius: 46,
                backgroundColor: const Color(0xFFF1F5F9),
                
                backgroundImage: widget.selectedImage != null
                    ? FileImage(widget.selectedImage!) as ImageProvider
                    : const AssetImage("assets/img/defaultdriverpic.JPG"),
                child: _isProcessing 
                    ? const CircularProgressIndicator(color: Color(0xFF2A5298)) 
                    : null,
              ),
            ),
          ),
          GestureDetector(
            onTap: _handleImageSelection,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF2A5298),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}