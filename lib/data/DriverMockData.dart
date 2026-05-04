import 'package:driver_app/data/AddressMockData.dart';
import 'package:driver_app/model/Address.dart';
import 'package:driver_app/model/Driver.dart';

class DriverMockData{

  static Address add1=AddressMockData.addresses[0];
  static Address add2=AddressMockData.addresses[2];

  static List<Driver> drivers=[

    Driver(
      driverId: 1, 
      firstName: "Lokesh", 
      lastName: "ojha", 
      email: "lokesh@gmail.com", 
      phone: "8171422287", 
      password: "lokesh", 
      licenceNumber: "uk07bt",
      address: add2
    ),

    Driver(
      driverId: 2, 
      firstName: "mohan", 
      lastName: "sharma", 
      email: "mohan@gmail.com", 
      phone: "7017173594", 
      password: "mohan", 
      licenceNumber: "up16xy",
      address: add1
    ),



  ];

  static Driver? login({
    required String emailOrPhone,
    required String password
  }){
    for(var d in drivers){
      if((d.email==emailOrPhone || d.phone==emailOrPhone)
        && d.password==password){
          return d;
      }
    }
    return null;
  }


  static Driver? register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required String licence,
  }){

    bool phoneAlreadyExist = drivers.any(
      (d) => d.phone==phone
    );

    bool emailAlreadyExist = drivers.any(
      (d) => d.email==email
    );

    if(phoneAlreadyExist || emailAlreadyExist){
      return null;
    }

    final newDriver=Driver(
      driverId: drivers.length+1, 
      firstName: firstName, 
      lastName: lastName, 
      email: email, 
      phone: phone, 
      password: password, 
      licenceNumber: licence
    );

    drivers.add(newDriver);
    return newDriver;

  }

}