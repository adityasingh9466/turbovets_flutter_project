
// lib/screens/chat/chat_animations.dart
import 'package:flutter/material.dart';

class ChatAnimations {
  final TickerProvider vsync;
  
  late final AnimationController _fabController;
  late final AnimationController _emojiController;
  late final AnimationController _replyController;
  late final AnimationController _messageController;

  late final Animation<double> fabAnimation;
  late final Animation<Offset> emojiSlideAnimation;
  late final Animation<double> replyAnimation;
  late final Animation<double> messageAnimation;

  ChatAnimations({required this.vsync}) {
    _setupAnimations();
  }

  void _setupAnimations() {
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    _emojiController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: vsync,
    );

    _replyController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    _messageController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );

    emojiSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _emojiController, curve: Curves.easeOutBack));

    replyAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _replyController, curve: Curves.elasticOut),
    );

    messageAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _messageController, curve: Curves.easeOut),
    );
  }

  void toggleFab(bool show) {
    if (show) {
      _fabController.forward();
    } else {
      _fabController.reverse();
    }
  }

  void showEmoji() {
    _emojiController.forward();
  }

  void hideEmoji() {
    _emojiController.reverse();
  }

  void showReplyPreview() {
    _replyController.forward();
  }

  void hideReplyPreview() {
    _replyController.reverse();
  }

  void playMessageAnimation() {
    _messageController.forward().then((_) => _messageController.reset());
  }

  void dispose() {
    _fabController.dispose();
    _emojiController.dispose();
    _replyController.dispose();
    _messageController.dispose();
  }
}