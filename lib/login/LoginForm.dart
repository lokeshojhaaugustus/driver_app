import 'package:driver_app/controller/DriverController.dart';
import 'package:driver_app/dto/LoginDto.dart';
import 'package:driver_app/login/LoginButton.dart';
import 'package:driver_app/login/LoginTextButtons.dart';
import 'package:driver_app/login/LoginTextField.dart';
import 'package:driver_app/login/SocialButtons.dart';
import 'package:driver_app/service/LoginService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoginTextField(
              hint: "Email or Phone Number",
              isPassword: false,
              controller: widget.emailController,
            ),
            const SizedBox(height: 18),
            LoginTextField(
              hint: "Password",
              isPassword: true,
              controller: widget.passwordController,
            ),
            const SizedBox(height: 24),
            _isLoading 
              ? const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()))
              : LoginButton(
                  onLogin: () async {
                    if (_isLoading) return;
                    setState(() => _isLoading = true);
                    try {
                      final email = widget.emailController.text.trim();
                      final password = widget.passwordController.text;
                      final driver = await LoginService.login(
                        LoginDto(emailOrPhone: email, password: password),
                      );

                      if (!context.mounted) return;

                      if (driver == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid Credentials"), backgroundColor: Colors.redAccent),
                        );
                      } else {
                        ref.read(driverControllerProvider.notifier).setDriver(driver);
                        Navigator.of(context).pushReplacementNamed("/home");
                      }
                    } catch (_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Unable to connect to backend"), backgroundColor: Colors.orangeAccent),
                      );
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                ),
            const SizedBox(height: 16),
            const LoginTextButtons(),
            const SocialButtons(),
          ],
        ),
      ),
    );
  }
}