
// lib/utils/haptic_helper.dart
import 'package:flutter/services.dart';

class HapticHelper {
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionClick() {
    HapticFeedback.selectionClick();
  }

  static void vibrate() {
    HapticFeedback.vibrate();
  }
}

// lib/constants/app_constants.dart
class AppConstants {
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Auto reply delays
  static const Duration firstReplyDelay = Duration(milliseconds: 800);
  static const Duration secondReplyDelay = Duration(seconds: 20, milliseconds: 800);
  static const Duration typingDuration = Duration(milliseconds: 1500);
  
  // UI Constants
  static const double fabScrollThreshold = 100.0;
  static const double emojiPickerHeight = 250.0;
  static const int maxMessageLines = 5;
  static const int emojiColumns = 8;
  static const double emojiMaxSize = 28.0;
  
  // Storage keys
  static const String chatBoxName = 'chatMessages';
}
