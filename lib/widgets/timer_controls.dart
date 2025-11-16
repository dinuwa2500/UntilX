import 'package:flutter/material.dart';
import '../models/timer_model.dart';

class TimerControls extends StatefulWidget {
  final TimerModel timer;

  const TimerControls({super.key, required this.timer});

  @override
  State<TimerControls> createState() => _TimerControlsState();
}

class _TimerControlsState extends State<TimerControls> {
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _secondsController = TextEditingController();

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _setTimer() {
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    final totalSeconds = (minutes * 60) + seconds;
    
    if (totalSeconds > 0) {
      widget.timer.setDuration(totalSeconds);
      _minutesController.clear();
      _secondsController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.timer,
      builder: (context, child) {
        return Column(
          children: [
            if (!widget.timer.isRunning && widget.timer.remainingSeconds == 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minutesController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _secondsController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          labelText: 'Seconds',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!widget.timer.isRunning && widget.timer.remainingSeconds == 0)
                  FilledButton.icon(
                    onPressed: _setTimer,
                    icon: const Icon(Icons.check),
                    label: const Text('Set Timer'),
                  ),
                if (widget.timer.remainingSeconds > 0 && !widget.timer.isRunning)
                  FilledButton.icon(
                    onPressed: widget.timer.start,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                  ),
                if (widget.timer.isRunning)
                  FilledButton.icon(
                    onPressed: widget.timer.pause,
                    icon: const Icon(Icons.pause),
                    label: const Text('Pause'),
                  ),
                if (widget.timer.remainingSeconds > 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: OutlinedButton.icon(
                      onPressed: widget.timer.reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
