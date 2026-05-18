import 'package:driver_app/model/Address.dart';
import 'package:driver_app/state/DriverState.dart';

class Driver {
  final int? driverId;
  String firstName;
  String lastName;
  final String email;
  final String phone;
  Address? address;
  String? password;
  final String licenceNumber;
  DriverState driverState;

  Driver({
    this.driverId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.address,
    required this.password,
    required this.licenceNumber,
    this.driverState = DriverState.offline,
  });

  Map<String, dynamic> toJson() {
    return {
      "driverId": driverId,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "password": password,
      "licenceNumber": licenceNumber,
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      driverId: _toIntOrNull(json["driverId"]),
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      address: json["address"] == null
          ? null
          : Address.fromJson(json["address"]),
      password: json["password"],
      licenceNumber: json["licenceNumber"] ?? json["licenseNumber"] ?? "",
      driverState: _driverStateFromJson(json["driverState"]),
    );
  }

  static DriverState _driverStateFromJson(dynamic value) {
    if (value == null) return DriverState.offline;

    final normalized = _normalizeEnum(value);
    return DriverState.values.firstWhere(
      (state) => _normalizeEnum(state.name) == normalized,
      orElse: () => DriverState.offline,
    );
  }

  static String _normalizeEnum(dynamic value) {
    return value.toString().toLowerCase().replaceAll(RegExp(r"[^a-z0-9]"), "");
  }

  static int? _toIntOrNull(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
