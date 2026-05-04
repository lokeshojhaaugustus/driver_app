import 'package:driver_app/data/AddressMockData.dart';
import 'package:driver_app/model/Address.dart';

class AddressAervice {

  static String add(Address address){
    List<Address> addresses=AddressMockData.addresses;
    double latitude=address.latitude;
    double longitude=address.longitude;

    for(Address a in addresses){
      if(a.latitude==latitude && a.longitude==longitude){
        return "Address Already Exist.";
      }
    }
    addresses.add(address);
    return "Address Successfully Added.";

  }
  
  static Address? find(int id){
    List<Address> drivers=AddressMockData.addresses;
    for(Address a in drivers){
      if(a.addressId==id) {
        return a;
      }
    }
    return null;
  }

  static List<Address> findAll(){
    return AddressMockData.addresses;
  }

  // static String update(int driverId, Driver driver){
  //   List<Driver> drivers=DriverMockData.drivers;

  //   for(int i=0;i<drivers.length;i++){
  //     if(drivers[i].driverId==driverId){
  //       drivers[i]=driver;
  //       return "Updated Successfully.";
  //     }
  //   }

  //   return "Driver Not Found.";
  // }
}