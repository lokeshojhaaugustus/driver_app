import 'package:driver_app/driverprofile/FullScreenProfilePicture.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:flutter/material.dart';

class DriverProfileHeader extends StatelessWidget {
  final Driver driver;
  const DriverProfileHeader({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  driver.firstName,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          Text(driver.licenceNumber, style: TextStyle(color: Colors.black)),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (_, _, _) => FullScreenProfilePicture(),
                ),
              );
            },
            child: CircleAvatar(
              radius: 135,
              backgroundImage: AssetImage("assets/img/defaultdriverpic.JPG"),
            ),
          ),
        ],
      ),
    );
  }
}
