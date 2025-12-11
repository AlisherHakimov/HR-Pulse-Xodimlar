class RegisterModel {
  RegisterModel({
    required this.session,
    required this.otp,
    required this.remainingAttempts,
    required this.phoneNumber,
    required this.name,
  });

  final String? session;
  final int? otp;
  final int? remainingAttempts;
  final String? phoneNumber;
  final String? name;

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      session: json["session"],
      otp: json["otp"],
      remainingAttempts: json["remaining_attempts"],
      phoneNumber: json["phone_number"],
      name: json["name"],
    );
  }
}
