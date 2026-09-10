import 'package:flutter/material.dart';


class SignupTextField extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool readOnly;

  const SignupTextField({
    super.key,
    required this.hint,
    required this.isPassword,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.readOnly = false,
  });

  @override
  State<SignupTextField> createState() => _SignupTextFieldState();
}

class _SignupTextFieldState extends State<SignupTextField> {
  bool _obscureText = true;
  
  IconData _getPrefixIcon() {
    if (widget.isPassword) {
      return Icons.lock_outline_rounded;
    }
    if (widget.hint.contains("First") || widget.hint.contains("Last")){
      return Icons.person_outline_rounded;
    }
    if (widget.hint.contains("Email")) {
      return Icons.mail_outline_rounded;
    } 
    if (widget.hint.contains("Phone")) {
      return Icons.phone_android_rounded;
    }
    return Icons.badge_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      style: const TextStyle(fontSize: 15, color: Colors.black87),
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        fillColor: widget.readOnly ? const Color(0xFFE2E8F0) : const Color(0xFFF1F5F9),
        filled: true,
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        prefixIcon: Icon(_getPrefixIcon(), color: Colors.black45, size: 20),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(_obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: Colors.black45),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2A5298), width: 1.5),
        ),
      ),
    );
  }
}