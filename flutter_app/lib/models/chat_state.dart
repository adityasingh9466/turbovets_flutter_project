
// lib/models/chat_state.dart
import '../constants/enums.dart';

class ChatState {
  final bool isTyping;
  final String? replyPreview;
  final MessageType? replyType;
  final bool isEmojiVisible;
  final String? reactionPickerMessageId;
  final bool showFab;
  final bool isPageVisible;

  const ChatState({
    this.isTyping = false,
    this.replyPreview,
    this.replyType,
    this.isEmojiVisible = false,
    this.reactionPickerMessageId,
    this.showFab = false,
    this.isPageVisible = true,
  });

  ChatState copyWith({
    bool? isTyping,
    String? replyPreview,
    MessageType? replyType,
    bool? isEmojiVisible,
    String? reactionPickerMessageId,
    bool? showFab,
    bool? isPageVisible,
    bool clearReply = false,
    bool clearReactionPicker = false,
  }) {
    return ChatState(
      isTyping: isTyping ?? this.isTyping,
      replyPreview: clearReply ? null : (replyPreview ?? this.replyPreview),
      replyType: clearReply ? null : (replyType ?? this.replyType),
      isEmojiVisible: isEmojiVisible ?? this.isEmojiVisible,
      reactionPickerMessageId: clearReactionPicker ? null : (reactionPickerMessageId ?? this.reactionPickerMessageId),
      showFab: showFab ?? this.showFab,
      isPageVisible: isPageVisible ?? this.isPageVisible,
    );
  }
}

// lib/utils/date_helper.dart (Updated version)
class DateHelper {
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return formatTime(dateTime);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return "Yesterday ${formatTime(dateTime)}";
    } else {
      return "${dateTime.day}/${dateTime.month} ${formatTime(dateTime)}";
    }
  }

  static String formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  static String formatTimestamp(DateTime timestamp) {
    return formatTime(timestamp);
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }
}