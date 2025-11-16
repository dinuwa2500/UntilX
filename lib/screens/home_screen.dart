import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/storage_service.dart';
import 'countdown_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _selectedDate;
  String? _errorMessage;

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.radiusMD,
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF4A6CF7),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.text,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _errorMessage = null;
      });
    }
  }

  bool _validateDate() {
    if (_selectedDate == null) {
      _showError(context, 'Please select a date');
      setState(() {
        _errorMessage = 'Please select a date';
      });
      return false;
    }

    // Target is midnight of selected date
    final targetMidnight =
        DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);

    // Compare with today's midnight (allow today or future dates)
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);

    if (targetMidnight.isBefore(todayMidnight)) {
      _showError(context, 'Choose a future date');
      setState(() {
        _errorMessage = 'Choose a future date';
      });
      return false;
    }

    return true;
  }

  void _showCountdown() async {
    if (_validateDate()) {
      // Save the target date to storage
      await StorageService.saveTargetDate(_selectedDate!);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CountdownScreen(targetDate: _selectedDate!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? AppPadding.md : AppPadding.lg,
              vertical: AppPadding.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isSmallScreen ? AppPadding.md : AppPadding.lg),
                Text(
                  'How many days until?',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppPadding.sm),
                Text(
                  'Select a date to begin countdown',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppPadding.xl),

                // Date Picker Card
                _buildCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'Select Date',
                  value: _selectedDate != null
                      ? _formatDate(_selectedDate!)
                      : 'No date selected',
                  onTap: _pickDate,
                  isSelected: _selectedDate != null,
                ),

                SizedBox(height: AppPadding.md),

                if (_errorMessage != null)
                  AnimatedContainer(
                    duration: AppDurations.normal,
                    margin: EdgeInsets.only(top: AppPadding.md),
                    padding: AppPadding.paddingMD,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: AppRadius.radiusLG,
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        SizedBox(width: AppPadding.sm),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                SizedBox(height: AppPadding.xxl),

                // Start Button
                AnimatedContainer(
                  duration: AppDurations.normal,
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _showCountdown,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6CF7),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.radiusLG,
                      ),
                      elevation: AppElevation.sm,
                      shadowColor: const Color(0xFF4A6CF7).withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow_rounded,
                            color: Colors.white),
                        SizedBox(width: AppPadding.sm),
                        Text(
                          'Show Countdown',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.radiusLG,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        padding: AppPadding.paddingLG,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.radiusLG,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4A6CF7).withOpacity(0.3)
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppPadding.sm + 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4A6CF7).withOpacity(0.1),
                borderRadius: AppRadius.radiusMD,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF4A6CF7),
                size: 24,
              ),
            ),
            SizedBox(width: AppPadding.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppPadding.xs),
                  Text(
                    value,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color:
                          isSelected ? AppColors.text : AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textTertiary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
