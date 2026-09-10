import 'package:driver_app/model/Driver.dart';

class OtpVerificationResponseDto{
  bool isOtpVerified;
  bool isRegistered;
  Driver? driver;

  OtpVerificationResponseDto({
    required this.isOtpVerified,
    required this.isRegistered,
    this.driver,
  }); 

  factory OtpVerificationResponseDto.fromJson(Map<String, dynamic> json){
    return OtpVerificationResponseDto(
      isOtpVerified: json["otpVerified"],
      isRegistered: json["registered"],
      driver: json["driver"] != null ? Driver.fromJson(json["driver"]) : null
    );
  }
}