
// lib/services/chat_service.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/chat_message.dart';
import '../constants/enums.dart';

class ChatService {
  static const String _boxName = 'chatMessages';
  late final Box<ChatMessage> _chatBox;

  ChatService() {
    _chatBox = Hive.box<ChatMessage>(_boxName);
  }

  Box<ChatMessage> get chatBox => _chatBox;

  List<ChatMessage> getAllMessages() {
    return _chatBox.values.toList();
  }

  void addMessage(ChatMessage message) {
    _chatBox.add(message);
  }

  void updateMessage(ChatMessage message) {
    final key = message.key;
    _chatBox.put(key, message);
  }

  void deleteMessage(String messageId) {
    final messages = _chatBox.values.toList();
    final index = messages.indexWhere((msg) => msg.id == messageId);
    if (index != -1) {
      _chatBox.deleteAt(index);
    }
  }

  void clearAllMessages() {
    _chatBox.clear();
  }

  ChatMessage createTextMessage({
    required String content,
    required bool isMe,
    String? replyTo,
    MessageType? replyToType,
  }) {
    final finalContent = replyTo != null ? '↪️ $replyTo\n$content' : content;
    
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: finalContent,
      timestamp: DateTime.now(),
      isMe: isMe,
      type: MessageType.text,
      replyTo: replyTo,
      replyToType: replyToType,
    );
  }

  ChatMessage createImageMessage({
    required Uint8List imageBytes,
    String? caption,
    required bool isMe,
    String? replyTo,
    MessageType? replyToType,
  }) {
    final base64Image = base64Encode(imageBytes);
    final content = (caption != null && caption.isNotEmpty)
        ? '$base64Image||CAPTION||$caption'
        : base64Image;

    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      timestamp: DateTime.now(),
      isMe: isMe,
      type: MessageType.image,
      replyTo: replyTo,
      replyToType: replyToType,
    );
  }
}
