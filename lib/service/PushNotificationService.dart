import 'package:driver_app/apiservice/RideRequestApiService.dart';
import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/ridedetails/RideDetailsScreen.dart';
import 'package:driver_app/controller/RideRequestsController.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static GlobalKey<NavigatorState>? _navigatorKey;
  
  // ⚡ A simple, clean reference to your active Riverpod Ref
  static Ref? _ref;

  static Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    _navigatorKey = navigatorKey;
    await _setupNotificationChannels();
    await _setupInteractedMessages();
    await subscribeToDriverNotifications();
  }

  // ⚡ Call this from your UI view once to link the notification stream to Riverpod!
  static void setRef(Ref ref) {
    _ref = ref;
  }

  static Future<void> subscribeToDriverNotifications() async {
    await FirebaseMessaging.instance.subscribeToTopic("drivers");
  }

  static Future<void> _setupNotificationChannels() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', 
      'High Importance Notifications', 
      importance: Importance.high, 
      playSound: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _setupInteractedMessages() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _processNotificationRoute(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_processNotificationRoute);
    
    // ⚡ YOUR CHOSEN WAY: Foreground packet interceptor
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("⚡ Foreground notification packet intercepted!");

      if (message.data.containsKey('rideRequestId')) {
        try {
          final int rideId = int.parse(message.data['rideRequestId']!);
          debugPrint("Calling API to fetch full RideRequest structure for ID: $rideId");

          // 1. Fetch the absolute source of truth directly from backend database
          RideRequest? realRideRequest = await RideRequestApiService.fetchRideById(rideId);

          // 2. Safely add it to your StateNotifier state list directly using the injected _ref
          if (realRideRequest != null && _ref != null) {
            debugPrint("🎯 Success! Injecting full object into controller state.");
            _ref!.read(rideRequestsControllerProvider.notifier).addRideRequest(realRideRequest);
          }
        } catch (e) {
          debugPrint("Error fetching foreground ride request details: $e");
        }
      }
    });
  }

  static void _processNotificationRoute(RemoteMessage message) async {
    if (_navigatorKey == null || !message.data.containsKey('rideRequestId')) return;
    String rideId = message.data['rideRequestId']!;
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_navigatorKey!.currentContext == null) return;
      try {
        showDialog(
          context: _navigatorKey!.currentContext!,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        int rideIdInt = int.parse(rideId);
        RideRequest? realRideRequest = await RideRequestApiService.fetchRideById(rideIdInt);
        _navigatorKey!.currentState?.pop(); // Close loader

        if (realRideRequest != null) {
          _navigatorKey!.currentState?.push(
            MaterialPageRoute(
              builder: (context) => RideDetailsScreen(
                rideRequest: realRideRequest,
                onAccept: () => debugPrint("Accepted ride $rideId"),
                onReject: () => debugPrint("Rejected ride $rideId"),
              ),
            ),
          );
        }
      } catch (e) {
        if (Navigator.canPop(_navigatorKey!.currentContext!)) _navigatorKey!.currentState?.pop();
        debugPrint("ERROR DURING ROUTING: $e");
      }
    });
  }
}

// 1. A simple provider that bridges Riverpod to your static service class
final pushNotificationSyncProvider = Provider<void>((ref) {
  PushNotificationService.setRef(ref);
});