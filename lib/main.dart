import 'package:driver_app/driverprofile/DriverProfileScreen.dart';
import 'package:driver_app/home/HomeScreen.dart';
import 'package:driver_app/home/TripUploadScreen.dart';
import 'package:driver_app/login/LoginScreen.dart';
import 'package:driver_app/provider/AppProvider.dart';
import 'package:driver_app/service/AppInitializer.dart';
import 'package:driver_app/service/SessionService.dart';
import 'package:driver_app/signup/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//allows us to navigate to different screens from anywhere in the app, even outside of the widget tree
//like a global remote control for navigation
final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {

  //tells the flutter engine to wait until all the
  //necessary services and resources are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();


  await AppInitializer.runServices(globalNavigatorKey);

  final isLoggedIn = await SessionService.restoreSession();

  runApp(
    UncontrolledProviderScope(
      container: appProviderContainer,
      child: MyApp(
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}


class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globalNavigatorKey, 
      initialRoute: isLoggedIn ? "/home" : "/login",
      routes: {
        "/login": (context) => const LoginScreen(),
        "/signup": (context) => const SignupScreen(),
        "/home": (context) => const HomeScreen(),
        "/profile": (context) => const DriverProfileScreen(),
        "/uploads": (context) => const TripUploadScreen(tripId: 0), // Placeholder tripId, replace with actual logic
      },
    );
  }
}