import 'dart:convert';
import 'dart:developer';

import 'package:driver_app/apiservice/ApiConfig.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/service/SessionService.dart';
import 'package:driver_app/service/SharedPreferenceService.dart';
import 'package:driver_app/model/Driver.dart';

abstract class GoogleAuthState {
  const GoogleAuthState();
}

class GoogleAuthInitial extends GoogleAuthState {
  const GoogleAuthInitial();
}

class GoogleAuthLoading extends GoogleAuthState {
  const GoogleAuthLoading();
}

class GoogleAuthSuccess extends GoogleAuthState {
  final bool isRegistered;
  final String? email;
  final String? googleId;
  final String? firstName;
  final String? lastName;

  const GoogleAuthSuccess({
    required this.isRegistered,
    this.email,
    this.googleId,
    this.firstName,
    this.lastName,
  });
}

class GoogleAuthFailure extends GoogleAuthState {
  final String errorMessage;
  const GoogleAuthFailure(this.errorMessage);
}

final googleAuthProvider = StateNotifierProvider<GoogleAuthNotifier, GoogleAuthState>((ref) {
  return GoogleAuthNotifier(ref);
});

class GoogleAuthNotifier extends StateNotifier<GoogleAuthState> {
  final Ref _ref;
  
  
  static const String _serverClientId = "214772662079-goa3d5n9ts1phuhhdjhuadh00tm7p7qk.apps.googleusercontent.com";

  GoogleAuthNotifier(this._ref) : super(const GoogleAuthInitial());

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> signInWithGoogle() async {
    state = const GoogleAuthLoading();

    try {
      await _googleSignIn.initialize(serverClientId: _serverClientId);
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();
      
      if (googleUser == null) {
        state = const GoogleAuthInitial();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      //print("::: Id Token ::: -- ::: ${idToken} :::");
      log("::: Id Token ::: -- ::: ${idToken} :::");
      if (idToken == null) {
        state = const GoogleAuthFailure("Google Security Token could not be fetched.");
        return;
      }

      final response = await http.post(
        ApiConfig.uri("/api/v1/auth/google"),
        //Uri.parse("http://192.168.1.42:8080/api/v1/auth/google"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final bool isNewUser = data['isNewUser'] ?? true;

        if (!isNewUser) {
          
          final String appJwt = data['token'];
          final int returnedDriverId = int.parse(data['driverId'].toString());
          final Driver driver = Driver.fromJson(data['driver']);

          await _secureStorage.write(key: "auth_jwt_token", value: appJwt);
          await SharedPreferenceService.saveDriverId(returnedDriverId);

          _ref.read(driverControllerProvider.notifier).setDriver(driver);
          await SessionService.restoreDriverTrip(returnedDriverId);

          state = const GoogleAuthSuccess(isRegistered: true);
        } else {
          // 🟡 NEW DRIVER PRE-PARSE
          final String fullCombinedName = data['name'] ?? googleUser.displayName ?? "";
          
          
          String parsedFirstName = "";
          String parsedLastName = "";
          List<String> parts = fullCombinedName.split(" ");
          if (parts.isNotEmpty) parsedFirstName = parts.first;
          if (parts.length > 1) parsedLastName = parts.sublist(1).join(" ");

          state = GoogleAuthSuccess(
            isRegistered: false,
            googleId: data['googleId'],
            email: data['email'] ?? googleUser.email,
            firstName: parsedFirstName,
            lastName: parsedLastName,
          );
        }
      } else {
        state = GoogleAuthFailure("Server authentication rejected: ${response.statusCode}");
      }
    } catch (e) {
      state = GoogleAuthFailure("Authentication failure detected: $e");
    }
  }
}