import 'package:flutter/material.dart';

class LoginTextBUttons extends StatelessWidget {
  const LoginTextBUttons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: (
            //
          ){}, 
          child: Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.blue.shade300,
              decoration: TextDecoration.underline,
            ),
          )
        ),
        TextButton(
          onPressed: (){}, 
          child: Text(
            "Forgot Password",
            style: TextStyle(
              color: Colors.blue.shade300,
              decoration: TextDecoration.underline,
            ),
          ))
      ],
    );
  }
}