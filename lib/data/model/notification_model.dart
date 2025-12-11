class NotificationModel {
  NotificationModel({
      String? id, 
      String? employee, 
      String? kind, 
      String? titleUz, 
      String? titleRu, 
      String? contentUz, 
      String? contentRu, 
      dynamic image, 
      bool? unread, 
      String? targetObject, 
      dynamic attendance, 
      dynamic schedule, 
      String? createdAt,}){
    _id = id;
    _employee = employee;
    _kind = kind;
    _titleUz = titleUz;
    _titleRu = titleRu;
    _contentUz = contentUz;
    _contentRu = contentRu;
    _image = image;
    _unread = unread;
    _targetObject = targetObject;
    _attendance = attendance;
    _schedule = schedule;
    _createdAt = createdAt;
}

  NotificationModel.fromJson(dynamic json) {
    _id = json['id'];
    _employee = json['employee'];
    _kind = json['kind'];
    _titleUz = json['title_uz'];
    _titleRu = json['title_ru'];
    _contentUz = json['content_uz'];
    _contentRu = json['content_ru'];
    _image = json['image'];
    _unread = json['unread'];
    _targetObject = json['target_object'];
    _attendance = json['attendance'];
    _schedule = json['schedule'];
    _createdAt = json['created_at'];
  }
  String? _id;
  String? _employee;
  String? _kind;
  String? _titleUz;
  String? _titleRu;
  String? _contentUz;
  String? _contentRu;
  dynamic _image;
  bool? _unread;
  String? _targetObject;
  dynamic _attendance;
  dynamic _schedule;
  String? _createdAt;

  String? get id => _id;
  String? get employee => _employee;
  String? get kind => _kind;
  String? get titleUz => _titleUz;
  String? get titleRu => _titleRu;
  String? get contentUz => _contentUz;
  String? get contentRu => _contentRu;
  dynamic get image => _image;
  bool? get unread => _unread;
  String? get targetObject => _targetObject;
  dynamic get attendance => _attendance;
  dynamic get schedule => _schedule;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['employee'] = _employee;
    map['kind'] = _kind;
    map['title_uz'] = _titleUz;
    map['title_ru'] = _titleRu;
    map['content_uz'] = _contentUz;
    map['content_ru'] = _contentRu;
    map['image'] = _image;
    map['unread'] = _unread;
    map['target_object'] = _targetObject;
    map['attendance'] = _attendance;
    map['schedule'] = _schedule;
    map['created_at'] = _createdAt;
    return map;
  }

}