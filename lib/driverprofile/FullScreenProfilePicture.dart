import 'package:flutter/material.dart';

class FullScreenProfilePicture extends StatelessWidget {
  const FullScreenProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: Image.asset("assets/img/defaultdriverpic.jpg"),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right:20,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){}, 
                    child: Text("Edit")
                  )
                ),
                SizedBox(
                  width: 10
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red
                    ),
                    child: Text("Delete")
                  )
                )
              ],
            )
          )
        ],
      ),
    );
  }
}