import 'package:driver_app/v1/home/counter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider= NotifierProvider<CounterController,int>(
  CounterController.new
);

class CounterController extends Notifier<int>{
  
  @override
  int build(){
    return 0;
  }
  
  void increament(){
    state++;
  }

  void decrement(){
    if(state>0){
      state--;
    }
  }

  void reset(){
    state=0;
  }
}

