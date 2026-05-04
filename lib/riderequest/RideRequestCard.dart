import 'package:driver_app/model/RideRequest.dart';
import 'package:driver_app/ridedetails/RideDetailsScreen.dart';
import 'package:flutter/material.dart';

class RideRequestCard extends StatelessWidget {

  final VoidCallback onAccept;
  final VoidCallback onReject;
  final RideRequest rideRequest;

  const RideRequestCard({
    super.key,
    required this.rideRequest,
    required this.onAccept,
    required this.onReject
  });

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RideDetailsScreen(rideRequest: rideRequest)
          )
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8
        ),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: Offset(0, 3)
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.my_location, 
                  color: Colors.green
                ),
                SizedBox(
                  width:8
                ),
                Expanded(
                  child: Text(
                    rideRequest.pickupLocation,
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ), 
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on, 
                  color: Colors.red
                ),
                SizedBox(
                  width:8
                ),
                Expanded(
                  child: Text(
                    rideRequest.dropLocation,
                    style: TextStyle(
                      fontSize: 15
                    ),
                  ), 
                )
              ],
            ),
            SizedBox(
              height:5
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ETA: ${rideRequest.eta}"),
                Text("${rideRequest.distance} Km"),
                Text("\$'${rideRequest.amount}")
              ],
            ),
            SizedBox(
              height: 8
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject, 
                    child: Text("Reject")
                  )
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onAccept, 
                    child: Text("Accept")
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}