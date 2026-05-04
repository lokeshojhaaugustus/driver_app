

class Address {

  final int addressId;
  final String streetLine1;
  final String city;
  final String state;
  final String pincode;
  final double latitude;
  final double longitude;

  Address({
    required this.addressId,
    required this.streetLine1,
    required this.city, 
    required this.state, 
    required this.pincode,
    required this.latitude,
    required this.longitude
  });
}