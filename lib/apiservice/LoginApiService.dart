import 'dart:convert';

import 'package:driver_app/dto/LoginDto.dart';
import 'package:driver_app/model/Driver.dart';
import 'package:http/http.dart' as http;

class LoginApiService{

  static Future<Driver?> login(LoginDto loginDto) async{
    final response= await http.post(
      Uri.parse("http://10.0.2.2:8080/driver/login"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(loginDto.toJson())
    );

    if(response.statusCode==200){
      return Driver.fromJson(
        jsonDecode(response.body)
      );
    }
    return null;
  }

}