class ActionModel {
  ActionModel({
      String? type, 
      String? start, 
      String? end,}){
    _type = type;
    _start = start;
    _end = end;
}

  ActionModel.fromJson(dynamic json) {
    _type = json['type'];
    _start = json['start'];
    _end = json['end'];
  }
  String? _type;
  String? _start;
  String? _end;

  String? get type => _type;
  String? get start => _start;
  String? get end => _end;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['start'] = _start;
    map['end'] = _end;
    return map;
  }

}