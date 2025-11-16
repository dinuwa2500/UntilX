import '../models/countdown_data.dart';

class CountdownCalculator {
  /// Calculates the remaining time between now and the target DateTime (at midnight)
  static Duration calculateRemaining(DateTime target) {
    // Set target to midnight (00:00:00) of the selected date
    final targetMidnight = DateTime(target.year, target.month, target.day);
    return targetMidnight.difference(DateTime.now());
  }

  /// Converts a Duration into a CountdownData model with days, weeks, hours, minutes, and seconds
  static CountdownData getCountdownData(DateTime target) {
    final diff = calculateRemaining(target);

    // Check if countdown is finished
    if (diff.isNegative || diff.inSeconds <= 0) {
      return CountdownData.zero();
    }

    // Extract time components
    final days = diff.inDays;
    final weeks = (diff.inDays / 7).floor();
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    return CountdownData(
      days: days,
      weeks: weeks,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      isFinished: false,
    );
  }

  /// Helper method to format countdown data as a readable string
  static String formatCountdown(CountdownData data) {
    if (data.isFinished) {
      return "Time's up!";
    }

    if (data.days > 0) {
      return '${data.days}d ${data.hours}h ${data.minutes}m ${data.seconds}s';
    } else if (data.hours > 0) {
      return '${data.hours}h ${data.minutes}m ${data.seconds}s';
    } else if (data.minutes > 0) {
      return '${data.minutes}m ${data.seconds}s';
    } else {
      return '${data.seconds}s';
    }
  }
}
