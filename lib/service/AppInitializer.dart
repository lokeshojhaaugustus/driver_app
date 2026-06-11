import 'package:driver_app/service/PushNotificationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AppInitializer {
  static Future<void> runServices(GlobalKey<NavigatorState> navigatorKey) async {
    try {
      await Firebase.initializeApp();
      debugPrint("Firebase core initialized successfully.");
      
      // Reverted: Only passes the navigatorKey now
      await PushNotificationService.initialize(navigatorKey);
      debugPrint("PushNotificationService initialized successfully.");
    } catch(e) {
      debugPrint("Error during Firebase setup: $e");
    }
  }
}