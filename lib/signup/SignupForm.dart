import 'package:driver_app/data/DriverMockData.dart';
import 'package:driver_app/signup/SignupButton.dart';
import 'package:driver_app/signup/SignupProfileSelector.dart';
import 'package:driver_app/signup/SignupTextField.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.licenceController
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController licenceController;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(
        left: 20,
        right: 20,
        top:120,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SignupProfileSelector(),
          SizedBox(
            height: 10,
          ),
          SignupTextField(
            hint: "First Name", 
            isPassword: false, 
            controller: widget.firstNameController
          ),
          SizedBox(
            height: 10,
          ),
          SignupTextField(
            hint: "Last Name", 
            isPassword: false, 
            controller: widget.lastNameController
          ),
          SizedBox(
            height: 10,
          ),
          SignupTextField(
            hint: "Email", 
            isPassword: false, 
            controller: widget.emailController
          ),
          SizedBox(
            height: 10,
          ),
          SignupTextField(
            hint: "Phone", 
            isPassword: false, 
            controller: widget.phoneController
          ),
          SizedBox(
            height: 10,
          ),
          SignupTextField(
            hint: "Password", 
            isPassword: false, 
            controller: widget.passwordController
          ),
          SizedBox(
            height: 10,
          ),
          SignupTextField(
            hint: "Licence", 
            isPassword: false, 
            controller: widget.licenceController
          ),
          SizedBox(
            height:10
          ),
          SignupButton(
            onSignup: (){
              final driver=DriverMockData.register(
                firstName: widget.firstNameController.text, 
                lastName: widget.lastNameController.text, 
                email: widget.emailController.text, 
                phone: widget.phoneController.text, 
                password: widget.passwordController.text, 
                licence: widget.licenceController.text
              );

              if(driver==null){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Email or Phone Already Exist!"))
                );
              }
              else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Signup Successful!"))
                );
                Navigator.of(context).pushNamed("/login");
              }
            },
          )
        ],
      ),
    );
  }
}