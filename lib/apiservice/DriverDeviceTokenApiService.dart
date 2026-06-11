import 'dart:convert';

import 'package:driver_app/apiservice/ApiConfig.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class DriverDeviceTokenApiService {

  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  static Future<void> setDeviceToken(int driverId) async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized){
        String? token = await _firebaseMessaging.getToken();
        print("token ::::::::::::::: $token");
        if(token != null){
          final response= await 
                    http.post(
                      ApiConfig.uri("/driverdevicetoken/set"),
                      headers: ApiConfig.jsonHeaders,
                      body: jsonEncode({
                        "driverId": driverId,
                        "deviceToken": token,
                      }),
                    );
          if(response.statusCode >= 200 && response.statusCode < 300){
            print("Device token set successfully.");
          }
          else {
          print("Failed to get device token.");
          } 
        }
      }
    }
    catch (e) {
        print("Error while setting device token: $e");
      }
  }
}