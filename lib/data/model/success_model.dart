class SuccessModel {
  SuccessModel({required this.detail});

  final String? detail;

  factory SuccessModel.fromJson(Map<String, dynamic> json) {
    return SuccessModel(detail: json["detail"]);
  }
}
