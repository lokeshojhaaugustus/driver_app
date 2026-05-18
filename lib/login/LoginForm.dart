import 'package:driver_app/dto/LoginDto.dart';
import 'package:driver_app/login/LoginButton.dart';
import 'package:driver_app/login/LoginTextButtons.dart';
import 'package:driver_app/login/LoginTextField.dart';
import 'package:driver_app/login/SocialButtons.dart';
import 'package:driver_app/service/LoginService.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoginTextField(
            hint: "email/phone",
            isPassword: false,
            controller: widget.emailController,
          ),
          SizedBox(height: 10),
          LoginTextField(
            hint: "password",
            isPassword: true,
            controller: widget.passwordController,
          ),
          SizedBox(height: 10),
          LoginButton(
            onLogin: () async {
              if (_isLoading) return;

              setState(() {
                _isLoading = true;
              });

              try {
                final email = widget.emailController.text;
                final password = widget.passwordController.text;
                final driver = await LoginService.login(
                  LoginDto(emailOrPhone: email, password: password),
                );

                if (!context.mounted) return;

                if (driver == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invalid Credentials")),
                  );
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Login Successful")));
                  Navigator.of(context).pushReplacementNamed("/home");
                }
              } catch (_) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Unable to connect to backend")),
                );
              } finally {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
          ),
          LoginTextBUttons(),
          SocialButtons(),
        ],
      ),
    );
  }
}
