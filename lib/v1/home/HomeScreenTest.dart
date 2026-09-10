import 'package:driver_app/v1/home/CounterController.dart';
//import 'package:driver_app/v1/home/Counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreenTest extends ConsumerWidget {
  const HomeScreenTest({super.key});

  @override
  Widget build(
    BuildContext context, 
    WidgetRef ref) {
    
    final counter=ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              counter.toString()
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: ()=>{
                ref.read(counterProvider.notifier).increament()
                
              }, 
              child: Text("+")
            )
          ],
        ),
      ),
    );
  }
}


