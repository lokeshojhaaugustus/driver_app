import 'package:driver_app/model/Address.dart';

class AddressMockData{

  static List<Address> addresses=[

      Address(
        addressId: 1, 
        streetLine1: "Delhi",
        city: "Delhi", 
        state: "Delhi", 
        pincode: "110001",
        latitude: 28.704059,
        longitude: 77.102490,
      ),

      Address(
        addressId: 2, 
        streetLine1: "Agra",
        city: "Agra", 
        state: "Agra", 
        pincode: "282001",
        latitude: 27.176670,
        longitude: 78.008074,
      ),

      Address(
        addressId: 3, 
        streetLine1: "Dehradun", 
        city: "Dehradun", 
        state: "Dehradun", 
        pincode: "248001",
        latitude: 30.316495,
        longitude: 78.032192
      ),

      Address(
        addressId: 4, 
        streetLine1: "Mumbai",
        city: "Mumbai", 
        state: "Mumbai", 
        pincode: "400001",
        latitude: 18.958235,
        longitude: 72.831951
      ),

      Address(
        addressId: 5, 
        streetLine1: "Hyderabad",
        city: "Hyderabad", 
        state: "Hyderabad", 
        pincode: "500001",
        latitude: 17.406498,
        longitude: 78.477244
      )];

}