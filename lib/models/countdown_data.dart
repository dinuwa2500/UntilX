class CountdownData {
  final int days;
  final int weeks;
  final int hours;
  final int minutes;
  final int seconds;
  final bool isFinished;

  CountdownData({
    required this.days,
    required this.weeks,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.isFinished,
  });

  factory CountdownData.zero() {
    return CountdownData(
      days: 0,
      weeks: 0,
      hours: 0,
      minutes: 0,
      seconds: 0,
      isFinished: true,
    );
  }
}
