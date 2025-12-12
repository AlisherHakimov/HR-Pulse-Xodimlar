class PermissionModel {
  PermissionModel({
    String? id,
    Employee? employee,
    ProcessedBy? processedBy,
    Reason? reason,
    String? createdAt,
    String? updatedAt,
    String? mode,
    String? start,
    String? end,
    bool? paySalary,
    String? comment,
    String? status,
    String? processComment,
    String? aiExplanation,
    dynamic createdBy,
  }) {
    _id = id;
    _employee = employee;
    _processedBy = processedBy;
    _reason = reason;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _mode = mode;
    _start = start;
    _end = end;
    _paySalary = paySalary;
    _comment = comment;
    _status = status;
    _processComment = processComment;
    _aiExplanation = aiExplanation;
    _createdBy = createdBy;
  }

  PermissionModel.fromJson(dynamic json) {
    _id = json['id'];
    _employee = json['employee'] != null
        ? Employee.fromJson(json['employee'])
        : null;
    _processedBy = json['processed_by'] != null
        ? ProcessedBy.fromJson(json['processed_by'])
        : null;
    _reason = json['reason'] != null ? Reason.fromJson(json['reason']) : null;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _mode = json['mode'];
    _start = json['start'];
    _end = json['end'];
    _paySalary = json['pay_salary'];
    _comment = json['comment'];
    _status = json['status'];
    _processComment = json['process_comment'];
    _aiExplanation = json['ai_explanation'];
    _createdBy = json['created_by'];
  }

  String? _id;
  Employee? _employee;
  ProcessedBy? _processedBy;
  Reason? _reason;
  String? _createdAt;
  String? _updatedAt;
  String? _mode;
  String? _start;
  String? _end;
  bool? _paySalary;
  String? _comment;
  String? _status;
  String? _processComment;
  String? _aiExplanation;
  dynamic _createdBy;

  String? get id => _id;

  Employee? get employee => _employee;

  ProcessedBy? get processedBy => _processedBy;

  Reason? get reason => _reason;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get mode => _mode;

  String? get start => _start;

  String? get end => _end;

  bool? get paySalary => _paySalary;

  String? get comment => _comment;

  String? get status => _status;

  String? get processComment => _processComment;

  String? get aiExplanation => _aiExplanation;

  dynamic get createdBy => _createdBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_employee != null) {
      map['employee'] = _employee?.toJson();
    }
    if (_processedBy != null) {
      map['processed_by'] = _processedBy?.toJson();
    }
    if (_reason != null) {
      map['reason'] = _reason?.toJson();
    }
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['mode'] = _mode;
    map['start'] = _start;
    map['end'] = _end;
    map['pay_salary'] = _paySalary;
    map['comment'] = _comment;
    map['status'] = _status;
    map['process_comment'] = _processComment;
    map['ai_explanation'] = _aiExplanation;
    map['created_by'] = _createdBy;
    return map;
  }
}

class Reason {
  Reason({String? id, String? name, String? shortName, bool? isDefault}) {
    _id = id;
    _name = name;
    _shortName = shortName;
    _isDefault = isDefault;
  }

  Reason.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _shortName = json['short_name'];
    _isDefault = json['is_default'];
  }

  String? _id;
  String? _name;
  String? _shortName;
  bool? _isDefault;

  String? get id => _id;

  String? get name => _name;

  String? get shortName => _shortName;

  bool? get isDefault => _isDefault;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['short_name'] = _shortName;
    map['is_default'] = _isDefault;
    return map;
  }
}

class ProcessedBy {
  ProcessedBy({String? id, String? name, Image? image}) {
    _id = id;
    _name = name;
    _image = image;
  }

  ProcessedBy.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'] != null ? Image.fromJson(json['image']) : null;
  }

  String? _id;
  String? _name;
  Image? _image;

  String? get id => _id;

  String? get name => _name;

  Image? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    if (_image != null) {
      map['image'] = _image?.toJson();
    }
    return map;
  }
}

class Image {
  Image({String? id, String? file, String? preview}) {
    _id = id;
    _file = file;
    _preview = preview;
  }

  Image.fromJson(dynamic json) {
    _id = json['id'];
    _file = json['file'];
    _preview = json['preview'];
  }

  String? _id;
  String? _file;
  String? _preview;

  String? get id => _id;

  String? get file => _file;

  String? get preview => _preview;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['file'] = _file;
    map['preview'] = _preview;
    return map;
  }
}

class Employee {
  Employee({String? id, String? name, Image? image}) {
    _id = id;
    _name = name;
    _image = image;
  }

  Employee.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'] != null ? Image.fromJson(json['image']) : null;
  }

  String? _id;
  String? _name;
  Image? _image;

  String? get id => _id;

  String? get name => _name;

  Image? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    if (_image != null) {
      map['image'] = _image?.toJson();
    }
    return map;
  }
}
