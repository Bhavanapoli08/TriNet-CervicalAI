import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const CervicAIApp());
}

class CervicAIApp extends StatefulWidget {
  const CervicAIApp({super.key});

  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

  @override
  State<CervicAIApp> createState() => _CervicAIAppState();
}

class _CervicAIAppState extends State<CervicAIApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: CervicAIApp.themeNotifier,
      builder: (BuildContext context, ThemeMode currentMode, Widget? child) {
        return MaterialApp(
          title: 'CervicAI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          // home: const Scaffold(
          //     body: Center(
          //         child: Text("CervicAI Setup Complete")
          //     )
          // ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
