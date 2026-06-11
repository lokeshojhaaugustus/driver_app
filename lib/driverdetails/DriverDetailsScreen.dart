import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/driverdetails/DriverDetailItem.dart';
import 'package:driver_app/driverdetails/LogoutButton.dart';
import 'package:driver_app/driverdetails/ProfileImageCard.dart';
import 'package:driver_app/service/SessionService.dart';
import 'package:driver_app/service/DriverService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverDetailsScreen extends ConsumerStatefulWidget {
  const DriverDetailsScreen({super.key});

  @override
  ConsumerState<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends ConsumerState<DriverDetailsScreen> {
  bool isEditing = false;
  bool isSaving = false;

  // Local controller states to cleanly handle user modifications before saving
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final currentDriver = ref.read(driverControllerProvider);
    if (currentDriver == null) return;

    setState(() => isSaving = true);

    try {
      // 1. Update the local fields on the current object structure
      currentDriver.firstName = _firstNameController.text.trim();
      currentDriver.lastName = _lastNameController.text.trim();

      // 2. Fire your static service method to update the backend database
      // Assumes your Driver class has an explicit 'id' or 'driverId' property
      bool isSuccess = await DriverService.updateDriverDetails(
        currentDriver.driverId!, 
        currentDriver,
      );

      if (isSuccess) {
        // 3. Clear and re-inject the state pointer back into Riverpod.
        // This break forces Riverpod to recognize it as a completely new change, 
        // causing all listening UI screens (like your HomeScreen Header) to instantly rebuild!
        ref.read(driverControllerProvider.notifier).state = null; 
        ref.read(driverControllerProvider.notifier).state = currentDriver;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile details updated successfully!'),
            backgroundColor: Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
          ),
        );

        setState(() {
          isEditing = false;
        });
      } else {
        throw Exception("Server rejected the profile update request.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save details: ${e.toString()}'), 
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final driver = ref.watch(driverControllerProvider);

    if (driver == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Syncing controllers with Riverpod state values once when edit mode opens
    if (!isEditing) {
      _firstNameController.text = driver.firstName;
      _lastNameController.text = driver.lastName;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Professional clean background tint
      appBar: AppBar(
        title: const Text(
          "Driver Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit_note_rounded, size: 28, color: Colors.blueAccent),
              onPressed: () => setState(() => isEditing = true),
            )
          else if (isSaving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            TextButton(
              onPressed: _handleSave,
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ProfileImageCard(isEditing: isEditing),
                    const SizedBox(height: 30),
                    
                    // Unified Card Layout for dynamic account details
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DriverDetailItem(
                            label: "First Name",
                            icon: Icons.person_outline_rounded,
                            isEditing: isEditing,
                            controller: _firstNameController,
                          ),
                          const Divider(height: 24, thickness: 0.8),
                          DriverDetailItem(
                            label: "Last Name",
                            icon: Icons.badge_outlined,
                            isEditing: isEditing,
                            controller: _lastNameController,
                          ),
                          const Divider(height: 24, thickness: 0.8),
                          DriverDetailItem(
                            label: "Phone Number",
                            icon: Icons.phone_android_rounded,
                            isEditing: false, // Locked non-editable UI presentation
                            value: driver.phone,
                          ),
                          const Divider(height: 24, thickness: 0.8),
                          DriverDetailItem(
                            label: "License Registration",
                            icon: Icons.card_membership_rounded,
                            isEditing: false, // Locked non-editable UI presentation
                            value: driver.licenceNumber,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    LogoutButton(
                      onLogout: () async {
                        await SessionService.clearSession();
                        if (mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
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