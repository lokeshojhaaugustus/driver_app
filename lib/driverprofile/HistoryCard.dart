import 'package:driver_app/history/HistoryScreen.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {

  final Driver driver;

  const HistoryCard({
    super.key,
    required this.driver
  });

  @override
  Widget build(BuildContext context){
    
    return GestureDetector(
      onTap: () {
        final driverId=driver.driverId;
        if(driverId==null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryScreen(
              driverId: driverId,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          children: [
            Icon(Icons.history_outlined),
            SizedBox(width: 10),
      
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Trip History",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "View All Past Trips & Earnings"
                  )
                ],
              ),
            ),
      
            Icon(Icons.arrow_forward_outlined, size: 18,)
          ],
        ),
      ),
    );
  }
}