import 'package:driver_app/controller/DriverController.dart';

import 'package:driver_app/controller/TripController.dart';

import 'package:driver_app/home/HomeHeader.dart';

import 'package:driver_app/home/OfflineScreen.dart';

import 'package:driver_app/home/OnlineScreen.dart';

import 'package:driver_app/state/DriverState.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';



class HomeScreen extends ConsumerStatefulWidget {

  const HomeScreen({super.key});



  @override

  ConsumerState<HomeScreen> createState() => _HomeScreenState();

}



class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override

  Widget build(BuildContext context) {

    final driver = ref.watch(driverControllerProvider);



    if (driver == null) {

      WidgetsBinding.instance.addPostFrameCallback((_) {

        Navigator.of(context).pushReplacementNamed("/login");

      });



      return const Scaffold(

        body: Center(

          child: CircularProgressIndicator(),

        ),

      );

    }



    final isOnline = driver.driverState == DriverState.online;

    final currentTrip = ref.watch(tripControllerProvider);



    // Sync native system notification bar appearance smoothly

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(

      statusBarColor: Colors.transparent,

      statusBarIconBrightness: isOnline ? Brightness.dark : Brightness.light,

      statusBarBrightness: isOnline ? Brightness.light : Brightness.dark,

    ));



    return Scaffold(

      backgroundColor: const Color(0xFF0F172A),

      body: Stack(

        children: [

          // -------------------------------------------------------------

          // Dynamic Stack Layer Ordering

          // -------------------------------------------------------------

         

          // Primary View: When online, OnlineScreen stands on top.

          // When offline, it moves underneath OfflineScreen while remaining alive.

          if (isOnline) ...[

            Positioned.fill(

              child: OnlineScreen(showRideRequests: currentTrip == null),

            ),

            const Positioned.fill(

              child: Visibility(

                visible: false,

                maintainState: true, // Holds state initialization references alive

                child: OfflineScreen(),

              ),

            ),

          ] else ...[

            Positioned.fill(

              child: OnlineScreen(showRideRequests: currentTrip == null),

            ),

            const Positioned.fill(

              child: OfflineScreen(), // Completely covers the Online view layers

            ),

          ],



          // -------------------------------------------------------------

          // Shared Interactive Navigation Header (Always Highest Z-Index)

          // -------------------------------------------------------------

          SafeArea(

            child: Align(

              alignment: Alignment.topCenter,

              child: Padding(

                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

                child: HomeHeader(

                  driver: driver,

                  onProfileClick: () {

                    Navigator.of(context).pushNamed("/profile");

                  },

                ),

              ),

            ),

          ),

        ],

      ),

    );

  }

}

