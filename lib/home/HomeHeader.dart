import 'package:driver_app/model/Driver.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatefulWidget {

  final VoidCallback onProfileClick;
  final Driver driver;
  
  const HomeHeader({
    super.key,
    required this.driver,
    required this.onProfileClick
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 40
      ),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.driver.firstName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              SizedBox(
                height:10
              ),
              Text(
                widget.driver.licenceNumber,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70
                ),
              )
            ],
          ),

          GestureDetector(
            onTap: widget.onProfileClick,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage("assets/img/defaultdriverpic.jpg"),
            ),
          )
        ],
      ),
    
    );
  }
}