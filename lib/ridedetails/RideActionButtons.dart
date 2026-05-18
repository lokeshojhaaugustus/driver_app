import 'package:flutter/material.dart';

class RideActionButtons extends StatelessWidget {
  final VoidCallback onReject;
  final VoidCallback onAccept;
  const RideActionButtons({
    super.key,
    required this.onReject,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onReject,
              child: const Text("Reject"),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onAccept,
              child: const Text("Accept"),
            ),
          ),
        ],
      ),
    );
  }
}
