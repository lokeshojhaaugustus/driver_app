import 'dart:io';
import 'package:driver_app/apiservice/DriverApiService.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/signup/SignupButton.dart';
import 'package:driver_app/signup/SignupProfileSelector.dart';
import 'package:driver_app/signup/SignupTextField.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.licenceController,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController licenceController;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _isLoading = false;
  File? _profileImage; // Holds the local 1:1 cropped square image file

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Reusable Profile Selector with explicit state pass-backs
            SignupProfileSelector(
              selectedImage: _profileImage,
              onImageSelected: (File? file) {
                setState(() {
                  _profileImage = file;
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SignupTextField(
                    hint: "First Name",
                    isPassword: false,
                    controller: widget.firstNameController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SignupTextField(
                    hint: "Last Name",
                    isPassword: false,
                    controller: widget.lastNameController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SignupTextField(
              hint: "Email Address",
              isPassword: false,
              keyboardType: TextInputType.emailAddress,
              controller: widget.emailController,
            ),
            const SizedBox(height: 16),
            SignupTextField(
              hint: "Phone Number",
              isPassword: false,
              keyboardType: TextInputType.phone,
              controller: widget.phoneController,
            ),
            const SizedBox(height: 16),
            SignupTextField(
              hint: "Password",
              isPassword: true,
              controller: widget.passwordController,
            ),
            const SizedBox(height: 16),
            SignupTextField(
              hint: "Driver License Number",
              isPassword: false,
              textCapitalization: TextCapitalization.characters,
              controller: widget.licenceController,
            ),
            const SizedBox(height: 28),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SignupButton(
                    // Inside SignupForm.dart -> Replace your current onSignup logic block:
                    onSignup: () async {
                      if (_isLoading) return;
                      setState(() => _isLoading = true);

                      try {
                        Driver driver = Driver(
                          firstName: widget.firstNameController.text.trim(),
                          lastName: widget.lastNameController.text.trim(),
                          email: widget.emailController.text.trim(),
                          phone: widget.phoneController.text.trim(),
                          password: widget.passwordController.text,
                          licenceNumber: widget.licenceController.text.trim(),
                        );

                        // 1. Save text fields to database and grab the unique ID
                        final int? newDriverId = await DriverApiService.addDriver(driver);
                        if (!context.mounted) return;

                        if (newDriverId != null) {
                          // 2. Upload the cropped picture if they picked one
                          if (_profileImage != null) {
                            String? remoteUrl = await DriverApiService.uploadImage(_profileImage!, newDriverId);
                            
                            // 3. Cache it locally to app document storage immediately
                            if (remoteUrl != null) {
                              final directory = await getApplicationDocumentsDirectory();
                              final localPath = '${directory.path}/profile_driver_$newDriverId.jpg';
                              await _profileImage!.copy(localPath); // Saves it locally as driver_X.jpg
                            }
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Signup Successful!"), backgroundColor: Colors.green),
                          );
                          Navigator.of(context).pushReplacementNamed("/login");
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Registration failed. Please try again."), backgroundColor: Colors.redAccent),
                          );
                        }
                      } catch (_) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Connection error occurs"), backgroundColor: Colors.orangeAccent),
                        );
                      } finally {
                        if (mounted) setState(() => _isLoading = false);
                      }
                    }
                  ),
          ],
        ),
      ),
    );
  }
}