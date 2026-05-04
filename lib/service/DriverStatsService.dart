import 'package:driver_app/data/DriverStatsMockData.dart';
import 'package:driver_app/model/DriverStats.dart';

class DriverStatsService{

  static String add(DriverStats driverStats){
    List<DriverStats> driverStatsList=DriverStatsMockData.driverStats;
    for(DriverStats d in driverStatsList){
      if(driverStats.driver.driverId == d.driver.driverId){
        return "Driver Stat Already Exists.";
      }
    }
    driverStatsList.add(driverStats);
    return "Driver Stat Added Successfully.";
  }

  static DriverStats? find(int id){
    List<DriverStats> driverStatsList=DriverStatsMockData.driverStats;
    for(DriverStats d in driverStatsList){
      if(d.driver.driverId==id){
        return d;
      }
    }
    return null;
  }

  static List<DriverStats> findAll(){
    return DriverStatsMockData.driverStats;
  }

  static String update(int id, DriverStats driverStats){
    List<DriverStats> driverStatsList=DriverStatsMockData.driverStats;
    for(int i=0;i<driverStatsList.length;i++){
      if(driverStatsList[i].driver.driverId==id){
        driverStatsList[i]=driverStats;
        return "Driver Stat Updated Successfully.";
      }
    }

    return "Driver Not Found.";
  }

}