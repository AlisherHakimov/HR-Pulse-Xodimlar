import 'notification_model.dart';

class NotificationsResponse {
  NotificationsResponse({
    int? count,
    String? next,
    dynamic previous,
    int? currentPage,
    int? pageSize,
    List<NotificationModel>? results,
    int? unreadCount,
  }) {
    _count = count;
    _next = next;
    _previous = previous;
    _currentPage = currentPage;
    _pageSize = pageSize;
    _results = results;
    _unreadCount = unreadCount;
  }

  NotificationsResponse.fromJson(dynamic json) {
    _count = json['count'];
    _next = json['next'];
    _previous = json['previous'];
    _currentPage = json['current_page'];
    _pageSize = json['page_size'];
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(NotificationModel.fromJson(v));
      });
    }
    _unreadCount = json['unread_count'];
  }

  int? _count;
  String? _next;
  dynamic _previous;
  int? _currentPage;
  int? _pageSize;
  List<NotificationModel>? _results;
  int? _unreadCount;

  int? get count => _count;

  String? get next => _next;

  dynamic get previous => _previous;

  int? get currentPage => _currentPage;

  int? get pageSize => _pageSize;

  List<NotificationModel>? get results => _results;

  int? get unreadCount => _unreadCount;

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
    map['unread_count'] = _unreadCount;
    return map;
  }
}
