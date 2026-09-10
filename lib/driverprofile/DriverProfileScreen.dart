import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/driverprofile/DriverDetailButton.dart';
import 'package:driver_app/driverprofile/DriverProfileHeader.dart';
import 'package:driver_app/driverprofile/DriverStatsSection.dart';
import 'package:driver_app/driverprofile/HistoryCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class DriverProfileScreen extends ConsumerWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverState = ref.watch(driverControllerProvider);
    final driver= driverState.driver;

    if (driver == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF6F8FA),
        body: Center(
          child: Text(
            "No Active Driver Session Found.",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black45),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Premium subtle off-white background
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          
          SliverToBoxAdapter(
            child: DriverProfileHeader(driver: driver),
          ),

          
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                
                DriverStatsSection(driverId: driver.driverId),
                const SizedBox(height: 24),

                
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    "ACCOUNT MANAGEMENT",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const DriverDetailButton(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(height: 1, thickness: 0.6, color: Colors.grey.shade100),
                      ),
                      HistoryCard(driver: driver),
                                  // ElevatedButton(
                                  //   onPressed: () async {
                                  //     try {
                                  //       String? token = await FirebaseMessaging.instance.getToken();
                                  //       print("====================================");
                                  //       print("MANUAL FCM TOKEN FETCH:");
                                  //       print(token);
                                  //       print("====================================");
                                  //     } catch (e) {
                                  //       print("Error fetching token manually: $e");
                                  //     }
                                  //   },
                                  //   child: const Text("Get Firebase Token"),
                                  // )
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}