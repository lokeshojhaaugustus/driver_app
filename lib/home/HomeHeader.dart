import 'package:driver_app/model/Driver.dart';
import 'package:driver_app/home/OnlineOfflineToggle.dart';
import 'package:driver_app/service/LocalCacheAvatar.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatefulWidget {
  final VoidCallback onProfileClick;
  final Driver driver;

  const HomeHeader({
    super.key,
    required this.driver,
    required this.onProfileClick,
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onProfileClick,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3), width: 2),
              ),
              child: LocalCacheAvatar(
      // Safely parse your Driver ID text field into an integer for the caching rules
                radius: 22, // Size adjusted perfectly to sit inside your map header row
              ),
              // child: const CircleAvatar(
              //   radius: 22,
              //   backgroundImage: AssetImage("assets/img/defaultdriverpic.JPG"),
              // ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Hello, ${widget.driver.firstName}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  widget.driver.licenceNumber,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // Instantly renders toggle cleaner inline to make the app aesthetic balanced
          const OnlineOfflineToggle(),
        ],
      ),
    );
  }
}