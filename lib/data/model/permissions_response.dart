import 'package:hr_plus/data/model/permission_model.dart';

class PermissionsResponse {
  PermissionsResponse({
      int? count, 
      dynamic next, 
      dynamic previous, 
      int? currentPage, 
      int? pageSize, 
      List<PermissionModel>? results, 
      StatusCounts? statusCounts,}){
    _count = count;
    _next = next;
    _previous = previous;
    _currentPage = currentPage;
    _pageSize = pageSize;
    _results = results;
    _statusCounts = statusCounts;
}

  PermissionsResponse.fromJson(dynamic json) {
    _count = json['count'];
    _next = json['next'];
    _previous = json['previous'];
    _currentPage = json['current_page'];
    _pageSize = json['page_size'];
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(PermissionModel.fromJson(v));
      });
    }
    _statusCounts = json['status_counts'] != null ? StatusCounts.fromJson(json['status_counts']) : null;
  }
  int? _count;
  dynamic _next;
  dynamic _previous;
  int? _currentPage;
  int? _pageSize;
  List<PermissionModel>? _results;
  StatusCounts? _statusCounts;

  int? get count => _count;
  dynamic get next => _next;
  dynamic get previous => _previous;
  int? get currentPage => _currentPage;
  int? get pageSize => _pageSize;
  List<PermissionModel>? get results => _results;
  StatusCounts? get statusCounts => _statusCounts;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    map['next'] = _next;
    map['previous'] = _previous;
    map['current_page'] = _currentPage;
    map['page_size'] = _pageSize;
    if (_results != null) {
      map['results'] = _results?.map((v) => v.toJson()).toList();
    }
    if (_statusCounts != null) {
      map['status_counts'] = _statusCounts?.toJson();
    }
    return map;
  }

}

class StatusCounts {
  StatusCounts({
    int? approved,
    int? pending,
    int? rejected,
    int? created,
    int? aiApproved,
    int? aiRejected,
    int? review,
  }) {
    _approved = approved;
    _pending = pending;
    _rejected = rejected;
    _created = created;
    _aiApproved = aiApproved;
    _aiRejected = aiRejected;
    _review = review;
  }

  StatusCounts.fromJson(dynamic json) {
    _approved = json['APPROVED'];
    _pending = json['PENDING'];
    _rejected = json['REJECTED'];
    _created = json['CREATED'];
    _aiApproved = json['AI_APPROVED'];
    _aiRejected = json['AI_REJECTED'];
    _review = json['REVIEW'];
  }

  int? _approved;
  int? _pending;
  int? _rejected;
  int? _created;
  int? _aiApproved;
  int? _aiRejected;
  int? _review;

  int? get approved => _approved;
  int? get pending => _pending;
  int? get rejected => _rejected;
  int? get created => _created;
  int? get aiApproved => _aiApproved;
  int? get aiRejected => _aiRejected;
  int? get review => _review;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['APPROVED'] = _approved;
    map['PENDING'] = _pending;
    map['REJECTED'] = _rejected;
    map['CREATED'] = _created;
    map['AI_APPROVED'] = _aiApproved;
    map['AI_REJECTED'] = _aiRejected;
    map['REVIEW'] = _review;
    return map;
  }
}



class Employee {
  Employee({
      String? id, 
      String? name, 
      Image? image,}){
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