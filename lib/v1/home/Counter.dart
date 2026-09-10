class Counter{
  int value=0;

  final List<Function> listeners=[];

  void increment(){
    value++;
    notifyListener();
  }

  void notifyListener(){
    for(final listener in listeners){
      listener();
    }
  }
}