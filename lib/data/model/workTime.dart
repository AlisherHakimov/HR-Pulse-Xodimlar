class WorkTime {
  WorkTime({this.start, this.end});

  WorkTime.fromJson(dynamic json) {
    start = json['start'];
    end = json['end'];
  }

  String? start;
  String? end;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['start'] = start;
    map['end'] = end;
    return map;
  }
}
