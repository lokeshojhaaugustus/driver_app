import 'package:driver_app/apiservice/AddressApiService.dart';
import 'package:driver_app/model/Address.dart';

class AddressService {

  static Future<bool> add(Address address){
    final isAdded= AddressApiService.addAddress(address);
    return isAdded;
  }
  
  static Future<Address?> getAddress(int addressId){
    final address = AddressApiService.getAddress(addressId);    
    return address;
  }

  static Future<List<Address>?> getAddresses(){
    final addresses= AddressApiService.getAddresses();
    return addresses;
  }
}