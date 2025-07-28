// Enhanced AppColors with modern color palette and utility functions
import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors - Modern Blue Palette
  static const Color primary = Color(0xFF3B82F6); // Modern blue
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryExtraLight = Color(0xFF93C5FD);

  // Secondary/Accent Colors - Vibrant Purple
  static const Color accent = Color(0xFF8B5CF6); // Purple
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF7C3AED);
  static const Color accentExtraLight = Color(0xFFC4B5FD);

  // Background Colors - Clean and Modern
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFFAFBFC);
  static const Color backgroundSecondary = Color(0xFFF8FAFC);
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkSurfaceLight = Color(0xFF334155); // Slate 700
  static const Color replyColor = Color(0xFF8B5CF6);

  // Text Colors - Better Contrast
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400
  static const Color textDark = Color(0xFFF1F5F9); // Slate 100
  static const Color textDarkSecondary = Color(0xFFCBD5E1); // Slate 300

  // Status Colors - Modern and Accessible
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  static const Color info = Color(0xFF3B82F6); // Blue 500
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // Chat Specific Colors
  static const Color chatBubbleMe = primary;
  static const Color chatBubbleMeGradientStart = Color(0xFF3B82F6);
  static const Color chatBubbleMeGradientEnd = Color(0xFF1D4ED8);

  static const Color chatBubbleOther = Color(0xFFF1F5F9); // Slate 100
  static const Color chatBubbleOtherDark = Color(0xFF2D3748);
  static const Color chatBubbleOtherGradientStart = Color(0xFFF8FAFC);
  static const Color chatBubbleOtherGradientEnd = Color(0xFFE2E8F0);

  // Interactive Elements
  static const Color interactive = primary;
  static const Color interactiveHover = primaryDark;
  static const Color interactivePressed = Color(0xFF1E3A8A);
  static const Color interactiveDisabled = Color(0xFFE2E8F0);

  // Overlay and Modal Colors
  static const Color overlay = Color(0x80000000);
  static const Color modalBackground = Color(0xFFFEFEFE);
  static const Color modalBackgroundDark = Color(0xFF1A202C);

  // Border Colors
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color borderLight = Color(0xFFF1F5F9); // Slate 100
  static const Color borderDark = Color(0xFF334155); // Slate 700
  static const Color borderFocus = primary;

  // Input and Form Colors
  static const Color inputBackground = Color(0xFFF8FAFC);
  static const Color inputBackgroundDark = Color(0xFF2D3748);
  static const Color inputBorder = Color(0xFFE2E8F0);
  static const Color inputBorderFocused = primary;
  static const Color inputPlaceholder = Color(0xFF94A3B8);
  static const Color inputPlaceholderDark = Color(0xFF718096);

  // Reaction and Interaction Colors
  static const Color reactionBackground = Color(0xFFF0F4F8);
  static const Color reactionBackgroundDark = Color(0xFF2D3748);
  static const Color reactionBorder = Color(0xFFE2E8F0);
  static const Color reactionBorderDark = Color(0xFF4A5568);

  // Gradient Definitions
  static const List<Color> primaryGradient = [
    Color(0xFF3B82F6),
    Color(0xFF1D4ED8),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF8B5CF6),
    Color(0xFF7C3AED),
  ];

  static const List<Color> successGradient = [
    Color(0xFF10B981),
    Color(0xFF059669),
  ];

  static const List<Color> warningGradient = [
    Color(0xFFF59E0B),
    Color(0xFFD97706),
  ];

  static const List<Color> errorGradient = [
    Color(0xFFEF4444),
    Color(0xFFDC2626),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF0F172A),
    Color(0xFF1E293B),
  ];

  // Glass morphism colors
  static const Color glassLight = Color(0x1AFFFFFF);
  static const Color glassDark = Color(0x1A000000);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassBorderDark = Color(0x33000000);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);

  // Utility Methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color adjustSaturation(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final newSaturation = (hsl.saturation + amount).clamp(0.0, 1.0);
    return hsl.withSaturation(newSaturation).toColor();
  }

  static Color blend(Color color1, Color color2, double ratio) {
    return Color.lerp(color1, color2, ratio) ?? color1;
  }

  // Context-aware color getters
  static Color surfaceColor(bool isDark) {
    return isDark ? darkSurface : background;
  }

  static Color textColor(bool isDark) {
    return isDark ? textDark : textPrimary;
  }

  static Color secondaryTextColor(bool isDark) {
    return isDark ? textDarkSecondary : textSecondary;
  }

  static Color borderColor(bool isDark) {
    return isDark ? borderDark : border;
  }

  static Color inputBackgroundColor(bool isDark) {
    return isDark ? inputBackgroundDark : inputBackground;
  }

  static Color chatBubbleColor(bool isMe, bool isDark) {
    if (isMe) return chatBubbleMe;
    return isDark ? chatBubbleOtherDark : chatBubbleOther;
  }

  // Material 3 Compatible Color Scheme
  static ColorScheme lightColorScheme = const ColorScheme.light(
    primary: primary,
    onPrimary: Colors.white,
    secondary: accent,
    onSecondary: Colors.white,
    surface: background,
    onSurface: textPrimary,
    background: background,
    onBackground: textPrimary,
    error: error,
    onError: Colors.white,
    outline: border,
    shadow: shadowLight,
  );

  static ColorScheme darkColorScheme = const ColorScheme.dark(
    primary: primary,
    onPrimary: Colors.white,
    secondary: accent,
    onSecondary: Colors.white,
    surface: darkSurface,
    onSurface: textDark,
    background: darkBackground,
    onBackground: textDark,
    error: error,
    onError: Colors.white,
    outline: borderDark,
    shadow: shadowDark,
  );
}
