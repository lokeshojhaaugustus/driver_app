// import 'dart:convert';

// import 'package:driver_app/apiservice/ApiConfig.dart';
// import 'package:driver_app/model/Address.dart';
// import 'package:http/http.dart' as http;

// class AddressApiService {
//   static Future<Address?> getAddress(int addressId) async {
//     final response = await http.get(ApiConfig.uri("/address/get/$addressId"));

//     if (response.statusCode == 200 && response.body.isNotEmpty) {
//       return Address.fromJson(jsonDecode(response.body));
//     }

//     return null;
//   }

//   static Future<List<Address>> getAddresses() async {
//     final response = await http.get(ApiConfig.uri("/address/get/all"));

//     if (response.statusCode == 200 && response.body.isNotEmpty) {
//       final List data = jsonDecode(response.body);
//       return data.map((item) => Address.fromJson(item)).toList();
//     }

//     return [];
//   }

//   static Future<bool> addAddress(Address address) async {
//     final response=await http.post(
//       ApiConfig.uri("/address/add"),
//       headers: ApiConfig.jsonHeaders,
//       body: jsonEncode(address.toJson()),
//     );
//     return response.statusCode >= 200 && response.statusCode < 300;
//   }

//   static Future<bool> deleteAddress(int addressId) async {
//     final response=await http.delete(ApiConfig.uri("/address/delete/$addressId"));
//     return response.statusCode >= 200 && response.statusCode < 300;
//   }
// }
