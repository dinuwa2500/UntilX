import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerModel extends ChangeNotifier {
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  bool get isRunning => _isRunning;

  void setDuration(int seconds) {
    if (!_isRunning) {
      _totalSeconds = seconds;
      _remainingSeconds = seconds;
      notifyListeners();
    }
  }

  void start() {
    if (_remainingSeconds > 0 && !_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          notifyListeners();
        } else {
          stop();
        }
      });
      notifyListeners();
    }
  }

  void pause() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void reset() {
    _isRunning = false;
    _timer?.cancel();
    _remainingSeconds = _totalSeconds;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void stop() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }
}
