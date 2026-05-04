import 'package:driver_app/data/DriverMockData.dart';
import 'package:driver_app/model/Driver.dart';

class DriverService{

  static String add(Driver d){
    List<Driver> drivers=DriverMockData.drivers;
    String email=d.email;
    String phone=d.phone;

    for(Driver d in drivers){
      if(d.email==email || d.phone==phone){
        return "Driver Already Exist.";
      }
    }
    drivers.add(d);
    return "Driver Successfully Added.";

  }
  
  static Driver? find(int id){
    List<Driver> drivers=DriverMockData.drivers;
    for(Driver d in drivers){
      if(d.driverId==id) {
        return d;
      }
    }
    return null;
  }

  static List<Driver> findAll(){
    return DriverMockData.drivers;
  }

  static String update(int driverId, Driver driver){
    List<Driver> drivers=DriverMockData.drivers;

    for(int i=0;i<drivers.length;i++){
      if(drivers[i].driverId==driverId){
        drivers[i]=driver;
        return "Updated Successfully.";
      }
    }

    return "Driver Not Found.";
  }
}