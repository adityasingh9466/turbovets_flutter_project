
// lib/utils/auto_reply_service.dart
import 'dart:math';

class AutoReplyService {
  static const List<String> _replies = [
    "How can I help you today? 😊",
    "Sure! Let me check that for you. 🔍",
    "Can you provide more details? 🤔",
    "I'll get back to you shortly! ⏰",
    "That's interesting! Tell me more. 💭",
    "Perfect! I understand what you need. ✨",
    "Let me think about that for a moment. 🤔",
    "Great question! Here's what I think. 💡",
    "I appreciate you sharing that with me. 🙏",
    "Is there anything else you'd like to know? 🤓",
  ];

  static String getRandomReply() {
    final random = Random();
    return _replies[random.nextInt(_replies.length)];
  }

  static List<String> getAllReplies() {
    return List.from(_replies);
  }
}
