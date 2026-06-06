class RegisterFormData {
  final String email;
  final String password;
  final String fullName;
  final String? currencyCode;

  RegisterFormData({
    required this.email,
    required this.password,
    required this.fullName,
    this.currencyCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'full_name': fullName,
      'currency_code': currencyCode ?? 'INR',
    };
  }
}
