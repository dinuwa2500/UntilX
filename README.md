# UntilX - Countdown Timer App

A clean and responsive countdown timer application built with Flutter that helps you track the days, weeks, hours, minutes, and seconds until your important dates.

## 📱 Screenshots

<div align="center">
  <img src="https://res.cloudinary.com/dinuwapvt/image/upload/v1763316799/WhatsApp_Image_2025-11-16_at_23.35.35_21b674f4_n5bhgi.jpg" alt="Home Screen" width="200" style="margin: 10px;">
  <img src="https://res.cloudinary.com/dinuwapvt/image/upload/v1763316799/WhatsApp_Image_2025-11-16_at_23.35.36_a92b1854_koddlj.jpg" alt="Date Selection" width="200" style="margin: 10px;">
  <img src="https://res.cloudinary.com/dinuwapvt/image/upload/v1763316799/WhatsApp_Image_2025-11-16_at_23.35.35_31503d7b_fvaugf.jpg" alt="Countdown Display" width="200" style="margin: 10px;">
  <img src="https://res.cloudinary.com/dinuwapvt/image/upload/v1763316799/WhatsApp_Image_2025-11-16_at_23.35.34_d3845569_ucdhxc.jpg" alt="Digital Timer" width="200" style="margin: 10px;">
  <img src="https://res.cloudinary.com/dinuwapvt/image/upload/v1763316799/WhatsApp_Image_2025-11-16_at_23.35.34_07252c04_m4paew.jpg" alt="Completed State" width="200" style="margin: 10px;">
</div>

## ✨ Features

- **📅 Date Selection**: Intuitive date picker to select your target date
- **⏱️ Real-time Countdown**: Live updates every second showing days, weeks, hours, minutes, and seconds
- **💾 Persistent Storage**: Your countdown is saved and restored even after closing the app
- **📱 Responsive Design**: Optimized for both small and large screens
- **🎨 Modern UI**: Clean Material Design 3 interface with smooth animations
- **🎉 Completion Celebration**: Special animation when your countdown reaches zero
- **🔄 Easy Date Changes**: Quickly change your target date with a single tap

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android SDK / Xcode (for iOS)
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/dinuwa2500/UntilX
   cd countdown-timer-app/CountdownTimerApp
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK**:

```bash
flutter build apk --release
```

**Android App Bundle**:

```bash
flutter build appbundle --release
```

**iOS**:

```bash
flutter build ios --release
```

## 📱 Usage

1. **Launch the app** - You'll see the home screen asking "How many days until?"
2. **Select a date** - Tap on the date picker card and choose your target date
3. **Start countdown** - Click "Show Countdown" to begin tracking
4. **View progress** - Watch the real-time countdown with days, weeks, hours, minutes, and seconds
5. **Change date** - Use the "Change Date" button to select a new target date
6. **Celebrate** - When the countdown reaches zero, enjoy the completion animation!

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point and splash loader
├── models/
│   └── countdown_data.dart   # Countdown data model
├── screens/
│   ├── home_screen.dart      # Date selection screen
│   └── countdown_screen.dart  # Countdown display screen
├── utils/
│   ├── constants.dart         # App constants (colors, styles, etc.)
│   ├── countdown_calculator.dart # Countdown calculation logic
│   └── storage_service.dart   # Local storage management
└── widgets/                  # Reusable UI components
```

## 🛠️ Tech Stack

- **Flutter** - Cross-platform mobile development framework
- **Dart** - Programming language
- **Material Design 3** - UI design system
- **Shared Preferences** - Local data persistence

## 📦 Dependencies

- `flutter`: Flutter framework
- `cupertino_icons`: iOS-style icons
- `shared_preferences`: Local storage for saving countdown dates
- `flutter_lints`: Code linting rules
- `flutter_launcher_icons`: App icon generation

## 🎨 Design System

The app follows a consistent design system with:

- **Primary Color**: `#4A6CF7` (Blue)
- **Background**: `#FAFAFA` (Light gray)
- **Typography**: System fonts with consistent sizing
- **Spacing**: Standardized padding and margins
- **Animations**: Smooth transitions and micro-interactions

## 🔧 Configuration

### App Icon

Replace `assets/logo.jpg` with your app logo and update the path in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/logo.jpg"
```

### App ID

Update the application ID in `android/app/build.gradle.kts`:

```kotlin
defaultConfig {
    applicationId = "com.yourcompany.untilx"
}
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design guidelines
- All contributors who help improve this project

## 📞 Support

If you have any questions or feedback, feel free to:

- Open an issue on GitHub
- Reach out via email
- Check the [Flutter documentation](https://flutter.dev/docs)

---

**Built with ❤️ using Flutter**
