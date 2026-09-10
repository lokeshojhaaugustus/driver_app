import 'dart:convert';

import 'package:driver_app/otpLogin/OtpVerificationResponseDto.dart';
import 'package:http/http.dart' as http;
import 'package:driver_app/apiservice/ApiConfig.dart';

class OtpApiService{

  static Future<bool> sendOtp({required String email, required String phone}) async{
    final url= ApiConfig.uri("/otp/send", {"email": email, "phone": phone});
    try{
      final response= await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "targetEmail": email, 
            "targetPhone": phone
        }),
      );
      return response.statusCode==200;
    }
    catch(e){
      print("Error in sending Otp: $e");
      return false;
    }
  }

  static Future<OtpVerificationResponseDto> verifyOtp({required String targetPhone, required String otp}) async{
    final url= ApiConfig.uri("/otp/verify");
    try{
      final response= await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "targetPhone": targetPhone, 
            "otp": otp
        }),
      );
      if(response.statusCode==200){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return OtpVerificationResponseDto.fromJson(responseData);
      }
      else{
        return OtpVerificationResponseDto(
          isOtpVerified: false,
          isRegistered: false,
          driver: null
        );
      }
    }
    catch(e){
      print("Error in verifying Otp: $e");
      return OtpVerificationResponseDto(
          isOtpVerified: false,
          isRegistered: false,
          driver: null
        );
    }
  }
}