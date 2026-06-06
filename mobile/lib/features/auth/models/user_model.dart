class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String currencyCode;
  final double? monthlyIncome;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.currencyCode,
    this.monthlyIncome,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      currencyCode: json['currency_code'],
      monthlyIncome: (json['monthly_income'] as num?)?.toDouble(),
    );
  }
}
