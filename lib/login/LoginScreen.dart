import 'package:driver_app/login/LoginBackground.dart';
import 'package:driver_app/login/LoginForm.dart';
import 'package:driver_app/login/LoginText.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LoginBackground(),
          LoginText(),
          LoginForm(
            emailController: emailController,
            passwordController: passwordController,
          ),
        ],
      ),
    );
  }
}
