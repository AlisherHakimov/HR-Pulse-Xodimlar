class ReportModel {
  ReportModel({
      String? id, 
      String? time, 
      String? employee, 
      String? type, 
      int? amount, 
      String? comment, 
      String? createdAt,}){
    _id = id;
    _time = time;
    _employee = employee;
    _type = type;
    _amount = amount;
    _comment = comment;
    _createdAt = createdAt;
}

  ReportModel.fromJson(dynamic json) {
    _id = json['id'];
    _time = json['time'];
    _employee = json['employee'];
    _type = json['type'];
    _amount = json['amount'];
    _comment = json['comment'];
    _createdAt = json['created_at'];
  }
  String? _id;
  String? _time;
  String? _employee;
  String? _type;
  int? _amount;
  String? _comment;
  String? _createdAt;

  String? get id => _id;
  String? get time => _time;
  String? get employee => _employee;
  String? get type => _type;
  int? get amount => _amount;
  String? get comment => _comment;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['time'] = _time;
    map['employee'] = _employee;
    map['type'] = _type;
    map['amount'] = _amount;
    map['comment'] = _comment;
    map['created_at'] = _createdAt;
    return map;
  }

}