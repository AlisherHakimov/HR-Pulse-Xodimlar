class AttendanceModel {
  AttendanceModel({
    String? date,
    Attendance? attendance,
    String? status,
    WorkTime? workTime,
  }) {
    _date = date;
    _attendance = attendance;
    _status = status;
    _workTime = workTime;
  }

  AttendanceModel.fromJson(dynamic json) {
    _date = json['date'];
    _attendance = json['attendance'] != null
        ? Attendance.fromJson(json['attendance'])
        : null;
    _status = json['status'];
    _workTime = json['work_time'] != null
        ? WorkTime.fromJson(json['work_time'])
        : null;
  }

  String? _date;
  Attendance? _attendance;
  String? _status;
  WorkTime? _workTime;

  String? get date => _date;

  Attendance? get attendance => _attendance;

  String? get status => _status;

  WorkTime? get workTime => _workTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = _date;
    if (_attendance != null) {
      map['attendance'] = _attendance?.toJson();
    }
    map['status'] = _status;
    if (_workTime != null) {
      map['work_time'] = _workTime?.toJson();
    }
    return map;
  }
}

class WorkTime {
  WorkTime({String? start, String? end}) {
    _start = start;
    _end = end;
  }

  WorkTime.fromJson(dynamic json) {
    _start = json['start'];
    _end = json['end'];
  }

  String? _start;
  String? _end;

  String? get start => _start;

  String? get end => _end;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['start'] = _start;
    map['end'] = _end;
    return map;
  }
}

class Attendance {
  Attendance({
    String? id,
    String? date,
    bool? late,
    String? checkIn,
    dynamic checkOut,
    bool? notMarked,
    bool? closed,
    WorkTime? workTime,
  }) {
    _id = id;
    _date = date;
    _late = late;
    _checkIn = checkIn;
    _checkOut = checkOut;
    _notMarked = notMarked;
    _closed = closed;
    _workTime = workTime;
  }

  Attendance.fromJson(dynamic json) {
    _id = json['id'];
    _date = json['date'];
    _late = json['late'];
    _checkIn = json['check_in'];
    _checkOut = json['check_out'];
    _notMarked = json['not_marked'];
    _closed = json['closed'];
    _workTime = json['work_time'] != null
        ? WorkTime.fromJson(json['work_time'])
        : null;
  }

  String? _id;
  String? _date;
  bool? _late;
  String? _checkIn;
  dynamic _checkOut;
  bool? _notMarked;
  bool? _closed;
  WorkTime? _workTime;

  String? get id => _id;

  String? get date => _date;

  bool? get late => _late;

  String? get checkIn => _checkIn;

  dynamic get checkOut => _checkOut;

  bool? get notMarked => _notMarked;

  bool? get closed => _closed;

  WorkTime? get workTime => _workTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['date'] = _date;
    map['late'] = _late;
    map['check_in'] = _checkIn;
    map['check_out'] = _checkOut;
    map['not_marked'] = _notMarked;
    map['closed'] = _closed;
    if (_workTime != null) {
      map['work_time'] = _workTime?.toJson();
    }
    return map;
  }
}
