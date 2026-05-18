class LoginDto {
  String emailOrPhone;
  String password;

  LoginDto({required this.emailOrPhone, required this.password});

  Map<String, dynamic> toJson() {
    return {"emailOrPhone": emailOrPhone, "password": password};
  }
}
