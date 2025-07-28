import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  void sendMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners(); // Notifies UI to rebuild
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
