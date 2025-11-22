import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/constants.dart';
import '../utils/countdown_calculator.dart';
import '../utils/storage_service.dart';
import '../models/countdown_data.dart';
import 'home_screen.dart';

class CountdownScreen extends StatefulWidget {
  final DateTime targetDate;

  const CountdownScreen({super.key, required this.targetDate});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late Timer _timer;
  CountdownData _countdownData = CountdownData.zero();

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateCountdown();
    });
  }

  void _updateCountdown() {
    final duration = CountdownCalculator.calculateRemaining(widget.targetDate);

    if (duration.inSeconds <= 0) {
      setState(() {
        _countdownData = CountdownData.zero();
      });
      _timer.cancel();
      // Clear saved date when countdown completes
      StorageService.clearTargetDate();
    } else {
      setState(() {
        _countdownData =
            CountdownCalculator.getCountdownData(widget.targetDate);
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _changeDate() async {
    // Clear saved date
    await StorageService.clearTargetDate();

    if (!mounted) return;

    // Navigate back to HomeScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
            onPressed: _changeDate,
            icon: const Icon(Icons.edit_outlined,
                color: Color(0xFF4A6CF7), size: 20),
            label: const Text(
              'Change Date',
              style: TextStyle(
                color: Color(0xFF4A6CF7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? AppPadding.md : AppPadding.lg,
              vertical: AppPadding.xxl,
            ),
            child: _countdownData.isFinished
                ? _buildCompletedState()
                : _buildCountdownState(isSmallScreen),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: const Icon(
                Icons.celebration_outlined,
                size: 100,
                color: Color(0xFF4A6CF7),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        Text(
          'The day has arrived!',
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCountdownState(bool isSmallScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Large bold "X Days"
        AnimatedSwitcher(
          duration: AppDurations.fast,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: Text(
            key: ValueKey(_countdownData.days),
            '${_countdownData.days} ${_countdownData.days == 1 ? "Day" : "Days"}',
            style: TextStyle(
              fontSize: isSmallScreen ? 56 : 72,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 12),

        // Sub text: "Until [DATE]"
        Text(
          'Until ${_formatTargetDate()}',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 22,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // "X Months" subtitle
        if (_countdownData.days >= 30)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${(_countdownData.days / 30).floor()} ${(_countdownData.days / 30).floor() == 1 ? "Month" : "Months"}',
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        
        // "X Weeks" subtitle
        if (_countdownData.weeks > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              '${_countdownData.weeks} ${_countdownData.weeks == 1 ? "Week" : "Weeks"}',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w400,
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        // Digital countdown for H:M:S
        _buildDigitalTimer(isSmallScreen),
      ],
    );
  }

  Widget _buildDigitalTimer(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? AppPadding.lg : AppPadding.xl,
        vertical: isSmallScreen ? AppPadding.lg : AppPadding.xl,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF4A6CF7).withOpacity(0.05),
        borderRadius: AppRadius.radiusLG,
        border: Border.all(
          color: const Color(0xFF4A6CF7).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeSegment(_countdownData.hours, 'Hou', isSmallScreen),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              ':',
              style: TextStyle(
                fontSize: isSmallScreen ? 28 : 36,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A6CF7),
              ),
            ),
          ),
          _buildTimeSegment(_countdownData.minutes, 'Min', isSmallScreen),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              ':',
              style: TextStyle(
                fontSize: isSmallScreen ? 28 : 36,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A6CF7),
              ),
            ),
          ),
          _buildTimeSegment(_countdownData.seconds, 'Sec', isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildTimeSegment(int value, String label, bool isSmallScreen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            key: ValueKey('$label-$value'),
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: isSmallScreen ? 32 : 40,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A6CF7),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        SizedBox(height: AppPadding.xs),
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 11 : 12,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  String _formatTargetDate() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final month = months[widget.targetDate.month - 1];
    final day = widget.targetDate.day;
    final year = widget.targetDate.year;

    return '$month $day, $year';
  }
}
