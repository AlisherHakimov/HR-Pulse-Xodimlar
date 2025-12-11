class PermissionRequest {
  PermissionRequest({
    String? mode,
    String? start,
    String? end,
    String? comment,
    String? reason,
  }) {
    _mode = mode;
    _start = start;
    _end = end;
    _comment = comment;
    _reason = reason;
  }

  String? _mode;
  String? _start;
  String? _end;
  String? _comment;
  String? _reason;

  String? get mode => _mode;

  String? get start => _start;

  String? get end => _end;

  String? get comment => _comment;

  String? get reason => _reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mode'] = _mode;
    map['start'] = _start;
    map['end'] = _end;
    map['comment'] = _comment;
    map['reason'] = _reason;

    return map;
  }
}
