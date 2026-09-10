class DriverCurrentLocationDto{
  final double latitude;
  final double longitude;

  DriverCurrentLocationDto({
    required this.latitude,
    required this.longitude
  });

  Map<String, dynamic> toJson(){
    return {
      "latitude": latitude,
      "longitude": longitude
    };
  }
}