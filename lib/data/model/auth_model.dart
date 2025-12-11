class AuthModel {
  AuthModel({required this.accessToken, required this.refreshToken});

  final String? accessToken;
  final String? refreshToken;

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json["access_token"],
      refreshToken: json["refresh_token"],
    );
  }
}
