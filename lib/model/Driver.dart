import 'package:driver_app/model/Address.dart';

class Driver{

  final int driverId;
  String firstName;
  String lastName;
  final String email;
  final String phone;
  Address? address;
  String password;
  final String licenceNumber;
  bool isAvailable;

  Driver({
    required this.driverId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.address,
    required this.password,
    required this.licenceNumber,
    this.isAvailable=true,
  }
  );

}