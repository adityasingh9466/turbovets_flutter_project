// lib/screens/chat/chat_controller.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:turbovets_flutter_challange/services/local_notification.dart';

import '../../constants/enums.dart';
import '../../models/chat_message.dart';

class ChatController {
  final VoidCallback? onNewMessage;
  final VoidCallback onStateChanged;
  final bool Function() isMounted; // Add this function to check mounted state
  final VoidCallback? onScrollToBottom; // Add callback for scrolling to bottom

  late final Box<ChatMessage> chatBox;

  bool _isTyping = false;
  String? _replyPreview;
  MessageType? _replyType;
  bool _isEmojiVisible = false;
  String? _reactionPickerMessageId;
  bool _showFab = false;
  bool _isPageVisible = true;

  final List<String> _autoReplies = [
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

  ChatController({
    required this.onNewMessage,
    required this.onStateChanged,
    required this.isMounted, // Add this parameter
    this.onScrollToBottom, // Add optional scroll callback
  }) {
    chatBox = Hive.box<ChatMessage>('chatMessages');
  }

  // Getters
  bool get isTyping => _isTyping;
  String? get replyPreview => _replyPreview;
  MessageType? get replyType => _replyType;
  bool get isEmojiVisible => _isEmojiVisible;
  String? get reactionPickerMessageId => _reactionPickerMessageId;
  bool get showFab => _showFab;
  bool get isPageVisible => _isPageVisible;

  // State management methods
  void setPageVisibility(bool isVisible) {
    _isPageVisible = isVisible;
  }

  void setShowFab(bool show) {
    if (!isMounted()) return; // Check if mounted before updating state
    _showFab = show;
    onStateChanged();
  }

  void showEmoji() {
    if (!isMounted()) return;
    _isEmojiVisible = true;
    onStateChanged();
  }

  void hideEmoji() {
    if (!isMounted()) return;
    _isEmojiVisible = false;
    onStateChanged();
  }

  void setReplyPreview(String content, MessageType type) {
    if (!isMounted()) return;
    _replyPreview = content;
    _replyType = type;
    onStateChanged();
  }

  void clearReplyPreview() {
    if (!isMounted()) return;
    _replyPreview = null;
    _replyType = null;
    onStateChanged();
  }

  void showReactionPicker(String messageId) {
    if (!kIsWeb && isMounted()) {
      HapticFeedback.mediumImpact();
      _reactionPickerMessageId = messageId;
      onStateChanged();
    }
  }

  void clearReactionPicker() {
    if (!isMounted()) return;
    _reactionPickerMessageId = null;
    onStateChanged();
  }

  // Message operations
  void sendTextMessage(String text) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _replyPreview != null ? '↪️ $_replyPreview\n$text' : text,
      timestamp: DateTime.now(),
      isMe: true,
      type: MessageType.text,
      replyTo: _replyPreview,
      replyToType: _replyType,
    );

    chatBox.add(message);
    clearReplyPreview();
    _scheduleAutoReplies();

    // Scroll to bottom after sending message
    if (onScrollToBottom != null) {
      onScrollToBottom!();
    }
  }

  void sendImageMessage(Map<String, dynamic> imageData) {
    final base64Image = base64Encode(imageData['bytes']);
    final caption = (imageData['caption'] as String?)?.trim();
    final content = (caption != null && caption.isNotEmpty)
        ? '$base64Image||CAPTION||$caption'
        : base64Image;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      isMe: true,
      type: MessageType.image,
      replyTo: _replyPreview,
      replyToType: _replyType,
    );

    chatBox.add(message);
    clearReplyPreview();
    _scheduleAutoReplies();

    // Scroll to bottom after sending image
    if (onScrollToBottom != null) {
      onScrollToBottom!();
    }
  }

  void addReaction(ChatMessage msg, String emoji) {
    if (!isMounted()) return;
    final key = msg.key;
    final updated = msg.copyWith(reaction: emoji);
    chatBox.put(key, updated);
    clearReactionPicker();
  }

  void _scheduleAutoReplies() {
    Future.delayed(
        const Duration(milliseconds: 800), () => _simulateAutoReply(1));
    Future.delayed(const Duration(seconds: 20, milliseconds: 800),
        () => _simulateAutoReply(2));
  }

  void _simulateAutoReply(int replyNumber) {
    print("_simulate $_isPageVisible");
    _isTyping = true;
    // Check if mounted before starting typing animation
    if (_isPageVisible) {
      onStateChanged();
      onScrollToBottom!();
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      // Check if still mounted before processing the reply
      if (!_isPageVisible) {
        LocalNotification().showLocalNotification();
      }

      final reply = (List.from(_autoReplies)..shuffle()).first;

      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: reply,
        timestamp: DateTime.now(),
        isMe: false,
        type: MessageType.text,
      );

      chatBox.add(message);
      // if (!isMounted()) return;
      if (!_isPageVisible && onNewMessage != null) {
        onNewMessage!();
      }
      ;
      if (!_isPageVisible) return;

      // Final mounted check before updating state
      if (!isMounted()) return;
      _isTyping = false;
      onStateChanged();

      // Always scroll to bottom after receiving auto reply, with a small delay
      // to ensure the message is rendered first
      if (onScrollToBottom != null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (isMounted()) {
            onScrollToBottom!();
          }
        });
      }
    });
  }

  void dispose() {
    // Clean up any resources if needed
  }
}
