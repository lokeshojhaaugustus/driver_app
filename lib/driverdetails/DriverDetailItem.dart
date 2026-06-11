import 'package:flutter/material.dart';

class DriverDetailItem extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final bool isEditing;
  final TextEditingController? controller;

  const DriverDetailItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isEditing,
    this.value,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isEditing ? Colors.blue.withOpacity(0.08) : Colors.grey.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: isEditing ? Colors.blueAccent : Colors.black45, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black38, letterSpacing: 0.5),
              ),
              const SizedBox(height: 4),
              isEditing && controller != null
                  ? TextFormField(
                      controller: controller,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 6),
                        border: InputBorder.none,
                        hintText: "Enter value",
                      ),
                    )
                  : Text(
                      value ?? controller?.text ?? '',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}