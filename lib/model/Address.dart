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

  Map<String, dynamic> toJson(){
    return{
      "addressId": addressId,
      "streetLine1": streetLine1,
      "city": city,
      "state": state,
      "pincode": pincode,
      "latitude": latitude,
      "longitude": longitude
    };
  }

  factory Address.fromJson(Map<String, dynamic> json){
    return Address(
      addressId: json["addressId"], 
      streetLine1: json["streetLine1"], 
      city: json["city"], 
      state: json["state"], 
      pincode: json["pincode"], 
      latitude: json["latitude"], 
      longitude: json["longitude"]
    );
  }


}