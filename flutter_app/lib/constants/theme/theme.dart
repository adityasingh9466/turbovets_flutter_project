// Enhanced AppTheme with better integration and modern UI
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class AppTheme {
  // Enhanced light theme with proper color scheme integration
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    
    // Enhanced AppBar theme with glassmorphism effect
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 24,
      ),
    ),
    
    // Enhanced color scheme with modern colors
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.background,
      background: AppColors.background,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      onBackground: AppColors.textPrimary,
      onError: Colors.white,
      outline: AppColors.border,
    ),
    
    // Enhanced input decoration theme with modern styling
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(
          color: AppColors.border.withOpacity(0.5),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: AppColors.primary, 
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      hintStyle: const TextStyle(
        color: AppColors.inputPlaceholder,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    
    // Enhanced floating action button theme with modern shadow
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: CircleBorder(),
    ),
    
    // Enhanced text theme with better typography
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        color: AppColors.textTertiary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.4,
      ),
    ),
    
    // Enhanced card theme
    cardTheme: CardTheme(
      elevation: 2,
      shadowColor: AppColors.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.background,
    ),
    
    // Enhanced divider theme
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
      space: 1,
    ),
  );

  // Enhanced dark theme with proper color scheme integration
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    
    // Enhanced AppBar theme for dark mode with glassmorphism
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 24,
      ),
    ),
    
    // Enhanced dark color scheme with modern colors
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.darkSurface,
      background: AppColors.darkBackground,
      error: AppColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textDark,
      onBackground: AppColors.textDark,
      onError: Colors.white,
      outline: AppColors.borderDark,
    ),
    
    // Enhanced input decoration theme for dark mode with modern styling
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackgroundDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(
          color: AppColors.borderDark.withOpacity(0.5),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: AppColors.primary, 
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      hintStyle: const TextStyle(
        color: AppColors.inputPlaceholderDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    
    // Enhanced floating action button theme for dark mode with modern shadow
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: CircleBorder(),
    ),
    
    // Enhanced text theme for dark mode with better typography
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppColors.textDark,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.15,
        height: 1.3,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textDarkSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.4,
      ),
      bodySmall: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.4,
      ),
    ),
    
    // Enhanced card theme for dark mode
    cardTheme: CardTheme(
      elevation: 4,
      shadowColor: AppColors.shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppColors.darkSurface,
    ),
    
    // Enhanced divider theme for dark mode
    dividerTheme: const DividerThemeData(
      color: AppColors.borderDark,
      thickness: 1,
      space: 1,
    ),
  );
  
  // Enhanced helper method for chat bubbles with modern design
  static BoxDecoration chatBubbleDecoration({
    required bool isMe,
    required bool isDark,
    bool isHovered = false,
  }) {
    if (isMe) {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.9),
            AppColors.primaryDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.7, 1.0],
        ),
        borderRadius: _getBubbleBorderRadius(isMe),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(isHovered ? 0.4 : 0.25),
            blurRadius: isHovered ? 12 : 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          // Inner highlight for depth
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 1,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      );
    } else {
      return BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.darkSurface,
                  AppColors.darkSurfaceLight,
                  const Color(0xFF2A3441),
                ]
              : [
                  Colors.white,
                  const Color(0xFFFCFCFC),
                  const Color(0xFFF8FAFC),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: _getBubbleBorderRadius(isMe),
        border: Border.all(
          color: isDark 
              ? AppColors.borderDark.withOpacity(0.3)
              : AppColors.border.withOpacity(0.4),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : Colors.grey).withOpacity(
              isHovered ? 0.12 : 0.08,
            ),
            blurRadius: isHovered ? 12 : 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          // Subtle inner shadow for depth
          BoxShadow(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.02),
            blurRadius: 1,
            offset: const Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      );
    }
  }
  
  // Enhanced helper method for border radius (unchanged signature)
  static BorderRadius _getBubbleBorderRadius(bool isMe) {
    return BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: isMe ? const Radius.circular(20) : const Radius.circular(6),
      bottomRight: isMe ? const Radius.circular(6) : const Radius.circular(20),
    );
  }
  
  // Enhanced helper method for input container with modern design
  static BoxDecoration inputContainerDecoration({
    required bool isDark,
    required bool hasFocus,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [
                AppColors.inputBackgroundDark,
                AppColors.darkSurface,
              ]
            : [
                AppColors.inputBackground,
                const Color(0xFFFCFCFC),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: hasFocus
            ? AppColors.primary.withOpacity(0.6)
            : isDark
                ? AppColors.borderDark.withOpacity(0.3)
                : AppColors.border.withOpacity(0.4),
        width: hasFocus ? 2 : 1,
      ),
      boxShadow: [
        if (hasFocus)
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        // Subtle shadow for depth
        BoxShadow(
          color: (isDark ? Colors.black : Colors.grey).withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    );
  }
  
  // Enhanced helper method for reaction picker with modern design
  static BoxDecoration reactionPickerDecoration(bool isDark) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isDark 
            ? [
                const Color(0xFF2A3441),
                const Color(0xFF1E2936),
              ]
            : [
                Colors.white,
                const Color(0xFFFCFCFC),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: isDark 
            ? AppColors.borderDark.withOpacity(0.4)
            : AppColors.border.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: (isDark ? Colors.black : Colors.grey).withOpacity(
            isDark ? 0.4 : 0.15,
          ),
          blurRadius: 16,
          offset: const Offset(0, 6),
          spreadRadius: 0,
        ),
        // Inner highlight for modern look
        BoxShadow(
          color: (isDark ? Colors.white : Colors.white).withOpacity(0.05),
          blurRadius: 1,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ],
    );
  }
}