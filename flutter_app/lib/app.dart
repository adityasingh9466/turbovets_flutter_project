// app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/theme/theme.dart';
import 'providers/theme_provider.dart';
import 'screens/welcome_screen.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'TurboVets Flutter Project',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      home:
          const WelcomeScreen(), // Changed from AppNavigation to WelcomeScreen
    );
  }
}
