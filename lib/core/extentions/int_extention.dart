extension DurationFormatExt on int {
  String get formatDuration {
    Duration duration = Duration(seconds: this);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours == 0) {
      // If duration is less than an hour, return only minutes and seconds
      return '$twoDigitMinutes:$twoDigitSeconds';
    } else {
      // If duration is an hour or more, return hours, minutes, and seconds
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    }
  }
}
