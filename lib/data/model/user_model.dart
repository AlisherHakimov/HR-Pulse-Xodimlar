class UserModel {
  UserModel({
      String? id, 
      String? name, 
      String? phoneNumber, 
      Job? job, 
      Department? department, 
      Image? image, 
      Attendance? attendance, 
      bool? isAdmin, 
      bool? manageAdmins, 
      bool? notifications, 
      bool? permissionEdit, 
      bool? permissionAttendance, 
      bool? permissionFinance, 
      bool? permissionEditData, 
      bool? permissionEditWt, 
      bool? permissionEditSalary, 
      bool? permissionEditWtTable, 
      bool? permissionDownloadStats, 
      bool? permissionDelete, 
      bool? removeLunchTimeFromWtTime, 
      int? bonus, 
      int? fine, 
      String? salaryMode, 
      int? salary, 
      String? wtMode, 
      WtMonday? wtMonday, 
      WtTuesday? wtTuesday, 
      WtWednesday? wtWednesday, 
      WtThursday? wtThursday, 
      WtFriday? wtFriday, 
      WtSaturday? wtSaturday, 
      WtSunday? wtSunday, 
      String? lunchMode, 
      LunchTime? lunchTime, 
      String? lunchDuration, 
      List<Shifts>? shifts,}){
    _id = id;
    _name = name;
    _phoneNumber = phoneNumber;
    _job = job;
    _department = department;
    _image = image;
    _attendance = attendance;
    _isAdmin = isAdmin;
    _manageAdmins = manageAdmins;
    _notifications = notifications;
    _permissionEdit = permissionEdit;
    _permissionAttendance = permissionAttendance;
    _permissionFinance = permissionFinance;
    _permissionEditData = permissionEditData;
    _permissionEditWt = permissionEditWt;
    _permissionEditSalary = permissionEditSalary;
    _permissionEditWtTable = permissionEditWtTable;
    _permissionDownloadStats = permissionDownloadStats;
    _permissionDelete = permissionDelete;
    _removeLunchTimeFromWtTime = removeLunchTimeFromWtTime;
    _bonus = bonus;
    _fine = fine;
    _salaryMode = salaryMode;
    _salary = salary;
    _wtMode = wtMode;
    _wtMonday = wtMonday;
    _wtTuesday = wtTuesday;
    _wtWednesday = wtWednesday;
    _wtThursday = wtThursday;
    _wtFriday = wtFriday;
    _wtSaturday = wtSaturday;
    _wtSunday = wtSunday;
    _lunchMode = lunchMode;
    _lunchTime = lunchTime;
    _lunchDuration = lunchDuration;
    _shifts = shifts;
}

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _phoneNumber = json['phone_number'];
    _job = json['job'] != null ? Job.fromJson(json['job']) : null;
    _department = json['department'] != null ? Department.fromJson(json['department']) : null;
    _image = json['image'] != null ? Image.fromJson(json['image']) : null;
    _attendance = json['attendance'] != null ? Attendance.fromJson(json['attendance']) : null;
    _isAdmin = json['is_admin'];
    _manageAdmins = json['manage_admins'];
    _notifications = json['notifications'];
    _permissionEdit = json['permission_edit'];
    _permissionAttendance = json['permission_attendance'];
    _permissionFinance = json['permission_finance'];
    _permissionEditData = json['permission_edit_data'];
    _permissionEditWt = json['permission_edit_wt'];
    _permissionEditSalary = json['permission_edit_salary'];
    _permissionEditWtTable = json['permission_edit_wt_table'];
    _permissionDownloadStats = json['permission_download_stats'];
    _permissionDelete = json['permission_delete'];
    _removeLunchTimeFromWtTime = json['remove_lunch_time_from_wt_time'];
    _bonus = json['bonus'];
    _fine = json['fine'];
    _salaryMode = json['salary_mode'];
    _salary = json['salary'];
    _wtMode = json['wt_mode'];
    _wtMonday = json['wt_monday'] != null ? WtMonday.fromJson(json['wt_monday']) : null;
    _wtTuesday = json['wt_tuesday'] != null ? WtTuesday.fromJson(json['wt_tuesday']) : null;
    _wtWednesday = json['wt_wednesday'] != null ? WtWednesday.fromJson(json['wt_wednesday']) : null;
    _wtThursday = json['wt_thursday'] != null ? WtThursday.fromJson(json['wt_thursday']) : null;
    _wtFriday = json['wt_friday'] != null ? WtFriday.fromJson(json['wt_friday']) : null;
    _wtSaturday = json['wt_saturday'] != null ? WtSaturday.fromJson(json['wt_saturday']) : null;
    _wtSunday = json['wt_sunday'] != null ? WtSunday.fromJson(json['wt_sunday']) : null;
    _lunchMode = json['lunch_mode'];
    _lunchTime = json['lunch_time'] != null ? LunchTime.fromJson(json['lunch_time']) : null;
    _lunchDuration = json['lunch_duration'];
    if (json['shifts'] != null) {
      _shifts = [];
      json['shifts'].forEach((v) {
        _shifts?.add(Shifts.fromJson(v));
      });
    }
  }
  String? _id;
  String? _name;
  String? _phoneNumber;
  Job? _job;
  Department? _department;
  Image? _image;
  Attendance? _attendance;
  bool? _isAdmin;
  bool? _manageAdmins;
  bool? _notifications;
  bool? _permissionEdit;
  bool? _permissionAttendance;
  bool? _permissionFinance;
  bool? _permissionEditData;
  bool? _permissionEditWt;
  bool? _permissionEditSalary;
  bool? _permissionEditWtTable;
  bool? _permissionDownloadStats;
  bool? _permissionDelete;
  bool? _removeLunchTimeFromWtTime;
  int? _bonus;
  int? _fine;
  String? _salaryMode;
  int? _salary;
  String? _wtMode;
  WtMonday? _wtMonday;
  WtTuesday? _wtTuesday;
  WtWednesday? _wtWednesday;
  WtThursday? _wtThursday;
  WtFriday? _wtFriday;
  WtSaturday? _wtSaturday;
  WtSunday? _wtSunday;
  String? _lunchMode;
  LunchTime? _lunchTime;
  String? _lunchDuration;
  List<Shifts>? _shifts;

  String? get id => _id;
  String? get name => _name;
  String? get phoneNumber => _phoneNumber;
  Job? get job => _job;
  Department? get department => _department;
  Image? get image => _image;
  Attendance? get attendance => _attendance;
  bool? get isAdmin => _isAdmin;
  bool? get manageAdmins => _manageAdmins;
  bool? get notifications => _notifications;
  bool? get permissionEdit => _permissionEdit;
  bool? get permissionAttendance => _permissionAttendance;
  bool? get permissionFinance => _permissionFinance;
  bool? get permissionEditData => _permissionEditData;
  bool? get permissionEditWt => _permissionEditWt;
  bool? get permissionEditSalary => _permissionEditSalary;
  bool? get permissionEditWtTable => _permissionEditWtTable;
  bool? get permissionDownloadStats => _permissionDownloadStats;
  bool? get permissionDelete => _permissionDelete;
  bool? get removeLunchTimeFromWtTime => _removeLunchTimeFromWtTime;
  int? get bonus => _bonus;
  int? get fine => _fine;
  String? get salaryMode => _salaryMode;
  int? get salary => _salary;
  String? get wtMode => _wtMode;
  WtMonday? get wtMonday => _wtMonday;
  WtTuesday? get wtTuesday => _wtTuesday;
  WtWednesday? get wtWednesday => _wtWednesday;
  WtThursday? get wtThursday => _wtThursday;
  WtFriday? get wtFriday => _wtFriday;
  WtSaturday? get wtSaturday => _wtSaturday;
  WtSunday? get wtSunday => _wtSunday;
  String? get lunchMode => _lunchMode;
  LunchTime? get lunchTime => _lunchTime;
  String? get lunchDuration => _lunchDuration;
  List<Shifts>? get shifts => _shifts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['phone_number'] = _phoneNumber;
    if (_job != null) {
      map['job'] = _job?.toJson();
    }
    if (_department != null) {
      map['department'] = _department?.toJson();
    }
    if (_image != null) {
      map['image'] = _image?.toJson();
    }
    if (_attendance != null) {
      map['attendance'] = _attendance?.toJson();
    }
    map['is_admin'] = _isAdmin;
    map['manage_admins'] = _manageAdmins;
    map['notifications'] = _notifications;
    map['permission_edit'] = _permissionEdit;
    map['permission_attendance'] = _permissionAttendance;
    map['permission_finance'] = _permissionFinance;
    map['permission_edit_data'] = _permissionEditData;
    map['permission_edit_wt'] = _permissionEditWt;
    map['permission_edit_salary'] = _permissionEditSalary;
    map['permission_edit_wt_table'] = _permissionEditWtTable;
    map['permission_download_stats'] = _permissionDownloadStats;
    map['permission_delete'] = _permissionDelete;
    map['remove_lunch_time_from_wt_time'] = _removeLunchTimeFromWtTime;
    map['bonus'] = _bonus;
    map['fine'] = _fine;
    map['salary_mode'] = _salaryMode;
    map['salary'] = _salary;
    map['wt_mode'] = _wtMode;
    if (_wtMonday != null) {
      map['wt_monday'] = _wtMonday?.toJson();
    }
    if (_wtTuesday != null) {
      map['wt_tuesday'] = _wtTuesday?.toJson();
    }
    if (_wtWednesday != null) {
      map['wt_wednesday'] = _wtWednesday?.toJson();
    }
    if (_wtThursday != null) {
      map['wt_thursday'] = _wtThursday?.toJson();
    }
    if (_wtFriday != null) {
      map['wt_friday'] = _wtFriday?.toJson();
    }
    if (_wtSaturday != null) {
      map['wt_saturday'] = _wtSaturday?.toJson();
    }
    if (_wtSunday != null) {
      map['wt_sunday'] = _wtSunday?.toJson();
    }
    map['lunch_mode'] = _lunchMode;
    if (_lunchTime != null) {
      map['lunch_time'] = _lunchTime?.toJson();
    }
    map['lunch_duration'] = _lunchDuration;
    if (_shifts != null) {
      map['shifts'] = _shifts?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Shifts {
  Shifts({
      String? shift, 
      bool? mandatory, 
      int? salary,}){
    _shift = shift;
    _mandatory = mandatory;
    _salary = salary;
}

  Shifts.fromJson(dynamic json) {
    _shift = json['shift'];
    _mandatory = json['mandatory'];
    _salary = json['salary'];
  }
  String? _shift;
  bool? _mandatory;
  int? _salary;

  String? get shift => _shift;
  bool? get mandatory => _mandatory;
  int? get salary => _salary;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['shift'] = _shift;
    map['mandatory'] = _mandatory;
    map['salary'] = _salary;
    return map;
  }

}

class LunchTime {
  LunchTime({
      dynamic start, 
      dynamic end,}){
    _start = start;
    _end = end;
}

  LunchTime.fromJson(dynamic json) {
    _start = json['start'];
    _end = json['end'];
  }
  dynamic _start;
  dynamic _end;

  dynamic get start => _start;
  dynamic get end => _end;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['start'] = _start;
    map['end'] = _end;
    return map;
  }

}

class WtSunday {
  WtSunday({
      String? start, 
      String? end,}){
    _start = start;
    _end = end;
}

  WtSunday.fromJson(dynamic json) {
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

class WtSaturday {
  WtSaturday({
      String? start, 
      String? end,}){
    _start = start;
    _end = end;
}

  WtSaturday.fromJson(dynamic json) {
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

class WtFriday {
  WtFriday({
      String? start, 
      String? end,}){
    _start = start;
    _end = end;
}

  WtFriday.fromJson(dynamic json) {
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

class WtThursday {
  WtThursday({
      String? start, 
      String? end,}){
    _start = start;
    _end = end;
}

  WtThursday.fromJson(dynamic json) {
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

class WtWednesday {
  WtWednesday({
      String? start, 
      String? end,}){
    _start = start;
    _end = end;
}

  WtWednesday.fromJson(dynamic json) {
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

class WtTuesday {
  WtTuesday({
      String? start, 
      String? end,}){
    _start = start;
    _end = end;
}

  WtTuesday.fromJson(dynamic json) {
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

class WtMonday {
  WtMonday({
      String? start, 
      String? end,}){
    _start = start;
    _end = end;
}

  WtMonday.fromJson(dynamic json) {
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
      String? wtStart, 
      String? wtEnd, 
      dynamic checkIn, 
      dynamic checkOut, 
      bool? skipWorkday,}){
    _id = id;
    _date = date;
    _wtStart = wtStart;
    _wtEnd = wtEnd;
    _checkIn = checkIn;
    _checkOut = checkOut;
    _skipWorkday = skipWorkday;
}

  Attendance.fromJson(dynamic json) {
    _id = json['id'];
    _date = json['date'];
    _wtStart = json['wt_start'];
    _wtEnd = json['wt_end'];
    _checkIn = json['check_in'];
    _checkOut = json['check_out'];
    _skipWorkday = json['skip_workday'];
  }
  String? _id;
  String? _date;
  String? _wtStart;
  String? _wtEnd;
  dynamic _checkIn;
  dynamic _checkOut;
  bool? _skipWorkday;

  String? get id => _id;
  String? get date => _date;
  String? get wtStart => _wtStart;
  String? get wtEnd => _wtEnd;
  dynamic get checkIn => _checkIn;
  dynamic get checkOut => _checkOut;
  bool? get skipWorkday => _skipWorkday;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['date'] = _date;
    map['wt_start'] = _wtStart;
    map['wt_end'] = _wtEnd;
    map['check_in'] = _checkIn;
    map['check_out'] = _checkOut;
    map['skip_workday'] = _skipWorkday;
    return map;
  }

}

class Image {
  Image({
      String? id, 
      String? file, 
      String? preview,}){
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

class Department {
  Department({
      String? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Department.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  String? _id;
  String? _name;

  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}

class Job {
  Job({
      String? id, 
      String? name, 
      dynamic lateTolerance, 
      dynamic earlyGoneTolerance,}){
    _id = id;
    _name = name;
    _lateTolerance = lateTolerance;
    _earlyGoneTolerance = earlyGoneTolerance;
}

  Job.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _lateTolerance = json['late_tolerance'];
    _earlyGoneTolerance = json['early_gone_tolerance'];
  }
  String? _id;
  String? _name;
  dynamic _lateTolerance;
  dynamic _earlyGoneTolerance;

  String? get id => _id;
  String? get name => _name;
  dynamic get lateTolerance => _lateTolerance;
  dynamic get earlyGoneTolerance => _earlyGoneTolerance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['late_tolerance'] = _lateTolerance;
    map['early_gone_tolerance'] = _earlyGoneTolerance;
    return map;
  }

}