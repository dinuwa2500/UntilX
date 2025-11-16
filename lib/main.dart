import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/countdown_screen.dart';
import 'utils/storage_service.dart';

void main() {
  runApp(const CountdownTimerApp());
}

class CountdownTimerApp extends StatelessWidget {
  const CountdownTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UntilX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const SplashLoader(),
    );
  }
}

class SplashLoader extends StatefulWidget {
  const SplashLoader({super.key});

  @override
  State<SplashLoader> createState() => _SplashLoaderState();
}

class _SplashLoaderState extends State<SplashLoader> {
  @override
  void initState() {
    super.initState();
    _loadSavedDate();
  }

  Future<void> _loadSavedDate() async {
    // Check if a saved target date exists
    final savedDate = await StorageService.loadTargetDate();

    if (!mounted) return;

    if (savedDate != null) {
      // Navigate directly to CountdownScreen with saved date
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CountdownScreen(targetDate: savedDate),
        ),
      );
    } else {
      // No saved date, show HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simple loading screen
    return const Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF4A6CF7),
        ),
      ),
    );
  }
}
