import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _targetDateKey = 'target_date';

  /// Save target date as YYYY-MM-DD string
  static Future<bool> saveTargetDate(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateString =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return await prefs.setString(_targetDateKey, dateString);
    } catch (e) {
      return false;
    }
  }

  /// Load target date from storage and return as DateTime at midnight
  static Future<DateTime?> loadTargetDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateString = prefs.getString(_targetDateKey);

      if (dateString == null) {
        return null;
      }

      // Parse YYYY-MM-DD format
      final parts = dateString.split('-');
      if (parts.length != 3) {
        return null;
      }

      final year = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final day = int.tryParse(parts[2]);

      if (year == null || month == null || day == null) {
        return null;
      }

      // Return date at midnight (00:00:00)
      final targetDate = DateTime(year, month, day);

      // Validate: if date is in the past (before today's midnight), clear it
      final today = DateTime.now();
      final todayMidnight = DateTime(today.year, today.month, today.day);

      if (targetDate.isBefore(todayMidnight)) {
        await clearTargetDate();
        return null;
      }

      return targetDate;
    } catch (e) {
      return null;
    }
  }

  /// Clear saved target date
  static Future<bool> clearTargetDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_targetDateKey);
    } catch (e) {
      return false;
    }
  }

  /// Check if a saved date exists
  static Future<bool> hasTargetDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_targetDateKey);
    } catch (e) {
      return false;
    }
  }
}
