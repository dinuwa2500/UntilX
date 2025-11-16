import 'package:flutter/material.dart';
import '../models/timer_model.dart';
import '../utils/time_formatter.dart';

class CountdownDisplay extends StatelessWidget {
  final TimerModel timer;

  const CountdownDisplay({super.key, required this.timer});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: timer,
      builder: (context, child) {
        final timeString = TimeFormatter.formatSeconds(timer.remainingSeconds);
        final progress = timer.totalSeconds > 0
            ? timer.remainingSeconds / timer.totalSeconds
            : 0.0;

        return Column(
          children: [
            SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Text(
                    timeString,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
