// lib/home/TripUploadScreen.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:driver_app/apiservice/ApiConfig.dart';

class TripUploadScreen extends StatefulWidget {
  final int tripId;

  const TripUploadScreen({super.key, required this.tripId});

  @override
  State<TripUploadScreen> createState() => _TripUploadScreenState();
}

class _TripUploadScreenState extends State<TripUploadScreen> {
  final List<File> _selectedFiles = [];
  bool _isUploading = false;
  bool _uploadSuccess = false;

  Future<void> _captureImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera, 
      imageQuality: 70,       
      maxWidth: 1920,         
      maxHeight: 1080,
    );
    
    if (photo != null) {
      setState(() {
        _selectedFiles.add(File(photo.path));
      });
    }
  }

  Future<void> _selectDocumentFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFiles.add(File(result.files.single.path!));
      });
    }
  }

  Future<void> _uploadAllDocuments() async {
    if (_selectedFiles.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        ApiConfig.uri("/trip/document/upload-document/${widget.tripId}"),
      );

      for (int i = 0; i < _selectedFiles.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'files', 
            _selectedFiles[i].path,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          _uploadSuccess = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🎉 Documents verified and uploaded successfully!')),
        );
      } else {
        _showErrorDialog("Server Error", "Failed to update documents on backend server. Try again.");
      }
    } catch (e) {
      _showErrorDialog("Network Error", "Unable to communicate with the driver backend systems.");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  void _completeTripAction() {
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trip #${widget.tripId} Verification')),
      // ⚡ FIX 1: Wrap body in a SafeArea to guarantee layout bounds remain true across different screen styles
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Upload Proof of Delivery Documents",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Attach package photos or manifest PDFs to complete this order safely.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              if (!_uploadSuccess)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUploading ? null : _captureImageFromCamera,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Take Photo"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUploading ? null : _selectDocumentFile,
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Add PDF / File"),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              // ⚡ FIX 2: List container safely structured inside explicit layout boundaries
              Expanded(
                child: _selectedFiles.isEmpty
                    ? const Center(child: Text("No attachments added yet.", style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: _selectedFiles.length,
                        // ⚡ FIX 3: Add properties telling the engine to tightly pack list bounds inside the window frame
                        shrinkWrap: true, 
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          String filePath = _selectedFiles[index].path;
                          String nameStr = filePath.split('/').last;
                          bool isPdf = nameStr.toLowerCase().endsWith('.pdf');

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              leading: Icon(isPdf ? Icons.picture_as_pdf : Icons.image, color: isPdf ? Colors.red : Colors.blue),
                              title: Text(nameStr, maxLines: 1, overflow: TextOverflow.ellipsis),
                              trailing: _uploadSuccess 
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => setState(() => _selectedFiles.removeAt(index)),
                                    ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 16),
              
              // Bottom Action button block
              SizedBox(
                width: double.infinity,
                height: 55,
                child: _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : !_uploadSuccess
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              disabledBackgroundColor: Colors.grey.shade300,
                            ),
                            onPressed: _selectedFiles.isEmpty ? null : _uploadAllDocuments,
                            child: Text(
                              "UPLOAD ${_selectedFiles.length} FILE(S)",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            onPressed: _completeTripAction,
                            child: const Text(
                              "MARK TRIP AS COMPLETE",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}