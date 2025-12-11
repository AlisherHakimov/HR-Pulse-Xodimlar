import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(Function action) {
    _timer?.cancel(); // Cancel the previous timer
    _timer = Timer(delay, action as void Function());
  }
}
