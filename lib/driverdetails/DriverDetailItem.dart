import 'package:flutter/material.dart';

class DriverDetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditing;
  final Function(String) onChanged;

  const DriverDetailItem({
    super.key,
    required this.label,
    required this.value,
    required this.isEditing,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),

          const SizedBox(height: 5),

          isEditing
              ? TextFormField(
                  initialValue: value,
                  onChanged: onChanged,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                )
              : Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
