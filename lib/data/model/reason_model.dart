class ReasonModel {
  ReasonModel({
      String? id, 
      String? name, 
      String? shortName,}){
    _id = id;
    _name = name;
    _shortName = shortName;
}

  ReasonModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _shortName = json['short_name'];
  }
  String? _id;
  String? _name;
  String? _shortName;

  String? get id => _id;
  String? get name => _name;
  String? get shortName => _shortName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['short_name'] = _shortName;
    return map;
  }

}