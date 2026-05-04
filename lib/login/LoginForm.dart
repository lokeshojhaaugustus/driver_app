import 'package:driver_app/data/DriverMockData.dart';
import 'package:driver_app/login/LoginButton.dart';
import 'package:driver_app/login/LoginTextButtons.dart';
import 'package:driver_app/login/LoginTextField.dart';
import 'package:driver_app/login/SocialButtons.dart';
import 'package:driver_app/service/AppPersistenceService.dart';
import 'package:driver_app/state/AppState.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(
        left:20,
        right:20
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoginTextField(
            hint: "email/phone", 
            isPassword: false, 
            controller: widget.emailController,
          ),
          SizedBox(
            height:10,
          ),
          LoginTextField(
            hint: "password", 
            isPassword: true, 
            controller: widget.passwordController
          ),
          SizedBox(
            height: 10,
          ),
          LoginButton(
            onLogin: () async {
              final driver=DriverMockData.login(
                emailOrPhone: widget.emailController.text, 
                password: widget.passwordController.text
              );

              if(driver==null){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Invalid Credentials"))
                );
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Login Successful"))
                );
                await AppPersistenceService.saveDriver(driver.driverId);
                AppState.currentDriver=driver;
                Navigator.of(context).pushNamed("/home");
              }
            },
          ),
          LoginTextBUttons(),
          SocialButtons()
        ],
      ),
    );
  }
}