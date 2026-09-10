import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/driverprofile/FullScreenProfilePicture.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/service/LocalCacheAvatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <--- 1. MAKE SURE THIS IMPORT IS HERE


class DriverProfileHeader extends ConsumerWidget {
  final Driver driver;
  const DriverProfileHeader({super.key, required this.driver});

  @override

  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)], 
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Driver Console",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: false,
                          barrierDismissible: true,
                          pageBuilder: (context, _, _) => FullScreenProfilePicture(
                            driver: driver,
                            onImageUpdated: (String newUrl) {
                              
                              driver.profilePicUrl = "$newUrl?t=${DateTime.now().millisecondsSinceEpoch}";

                              
                              final notifier = ref.read(driverControllerProvider.notifier);
                              
                              notifier.setDriver(driver); 
                            },
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                          child: Hero(
                            tag: 'avatar-profile-hero',
                            child: LocalCacheAvatar(
                              radius: 42,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                          child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          driver.firstName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12), 
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.card_membership_rounded, color: Colors.white70, size: 13),
                              const SizedBox(width: 6),
                              Text(
                                driver.licenceNumber.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 12, 
                                  color: Colors.grey.shade200, 
                                  fontWeight: FontWeight.w600, 
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}