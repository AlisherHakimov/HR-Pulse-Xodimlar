class TransactionModel {
  TransactionModel({
    this.id,
    this.time,
    this.employee,
    this.type,
    this.amount,
    this.comment,
    this.createdAt,
  });

  TransactionModel.fromJson(dynamic json) {
    id = json['id'];
    time = json['time'];
    employee = json['employee'];
    type = json['type'];
    amount = json['amount'];
    comment = json['comment'];
    createdAt = json['created_at'];
  }

  String? id;
  String? time;
  String? employee;
  String? type;
  int? amount;
  String? comment;
  String? createdAt;
}
