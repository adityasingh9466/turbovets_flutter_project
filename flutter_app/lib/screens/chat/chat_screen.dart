// lib/screens/chat/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turbovets_flutter_challange/models/chat_state.dart';
import 'package:turbovets_flutter_challange/screens/chat/chat_animations.dart';
import 'package:turbovets_flutter_challange/screens/chat/chat_controller.dart';
import 'package:turbovets_flutter_challange/screens/image_preview_screen.dart';
import 'package:turbovets_flutter_challange/widgets/chats/chat_bubble.dart';
import 'package:turbovets_flutter_challange/widgets/chats/emoji_picker_widget.dart';
import 'package:turbovets_flutter_challange/widgets/chats/message_input_widget.dart';
import 'package:turbovets_flutter_challange/widgets/chats/reply_preview_widget.dart';
import 'package:turbovets_flutter_challange/widgets/typing_indicator.dart';

import '../../../constants/enums.dart';
import '../../../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final VoidCallback? onNewMessage;

  const ChatScreen({super.key, this.onNewMessage});

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late final ChatController _controller;
  late final ChatAnimations _animations;
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _controller = ChatController(
      onNewMessage: widget.onNewMessage,
      onStateChanged: () => setState(() {}),
      isMounted: () => mounted, // Pass the mounted check function
      onScrollToBottom: () =>
          _scrollToBottomForNewMessage(), // Use new message scroll method
    );
    _animations = ChatAnimations(vsync: this);

    _setupScrollListener();
    _focusNode.addListener(_onFocusChange);

    // Scroll to bottom after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
      _isInitialLoad = false;
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Check if user is at the bottom (with small tolerance)
      final isAtBottom = _scrollController.offset >=
          (_scrollController.position.maxScrollExtent - 50);

      // Show FAB only when user scrolled up more than 100px AND not at bottom
      final shouldShowFab = _scrollController.offset > 100 && !isAtBottom;

      if (shouldShowFab != _controller.showFab) {
        _controller.setShowFab(shouldShowFab);
        _animations.toggleFab(shouldShowFab);
      }
    });
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && _controller.isEmojiVisible) {
      _controller.hideEmoji();
      _animations.hideEmoji();
    }
  }

  void setPageVisibility(bool isVisible) {
    _controller.setPageVisibility(isVisible);

    // When page becomes visible, scroll to bottom to show latest messages
    if (isVisible) {
      // Small delay to ensure the page is fully loaded
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom(animated: false);
      });
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    HapticFeedback.lightImpact();
    _controller.sendTextMessage(text);
    _textController.clear();
    _animations.playMessageAnimation();
    // Scroll is now handled in the controller
  }

  Future<void> _sendImageMessage() async {
    HapticFeedback.mediumImpact();

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final result = await _navigateToImagePreview(bytes);

      if (result != null) {
        _controller.sendImageMessage(result);
        _animations.playMessageAnimation();
        // Scroll is now handled in the controller
      }
    }
  }

  Future<Map<String, dynamic>?> _navigateToImagePreview(Uint8List bytes) {
    return Navigator.push<Map<String, dynamic>>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ImagePreviewScreen(imageBytes: bytes),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (animated && !_isInitialLoad) {
        _scrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(maxScroll);
      }
    });
  }

  void _scrollToBottomForNewMessage() {
    // Immediate scroll for new messages with a small delay to ensure rendering
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      final maxScroll = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        maxScroll,
        duration: const Duration(
            milliseconds: 300), // Faster animation for new messages
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _onSwipeToReply(String content, MessageType type) {
    HapticFeedback.mediumImpact();
    _controller.setReplyPreview(content, type);
    _animations.showReplyPreview();
    _focusNode.requestFocus();
  }

  void _onReactionSelected(ChatMessage msg, String emoji) {
    HapticFeedback.lightImpact();
    _controller.addReaction(msg, emoji);
  }

  void _toggleEmoji() {
    HapticFeedback.selectionClick();
    if (_controller.isEmojiVisible) {
      _controller.hideEmoji();
      _animations.hideEmoji();
      _focusNode.requestFocus();
    } else {
      _controller.showEmoji();
      _animations.showEmoji();
      _focusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _animations.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ValueListenableBuilder(
      valueListenable: _controller.chatBox.listenable(),
      builder: (context, box, _) {
        final messages = box.values.toList();

        return Scaffold(
          backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
          body: Stack(
            children: [
              _buildBackground(isDark),
              _buildMainContent(messages, theme, isDark),
              _buildFloatingActionButton(theme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackground(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [Colors.grey[900]!, Colors.grey[850]!]
              : [Colors.blue[50]!, Colors.white],
          stops: const [0.0, 0.3],
        ),
      ),
    );
  }

  Widget _buildMainContent(
      List<ChatMessage> messages, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: () {
        _controller.clearReactionPicker();
        if (_controller.isEmojiVisible) {
          _controller.hideEmoji();
          _animations.hideEmoji();
        }
      },
      child: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _animations.messageAnimation,
              builder: (context, child) {
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: messages.length + (_controller.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_controller.isTyping && index == messages.length) {
                      return _buildTypingIndicator();
                    }
                    return _buildMessageItem(messages[index], index);
                  },
                );
              },
            ),
          ),
          _buildReplyPreview(),
          _buildInputArea(theme, isDark),
          _buildEmojiPicker(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.support_agent,
                        size: 16, color: Colors.white),
                  ),
                  SizedBox(width: 12),
                  TypingIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(ChatMessage msg, int index) {
    return TweenAnimationBuilder<double>(
      duration:
          Duration(milliseconds: 150 + (index * 25)), // Much faster animation
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 15 * (1 - value)), // Reduced offset distance
          child: Opacity(
            opacity: value,
            child: Dismissible(
              key: ValueKey('dismiss-${msg.id}'),
              direction: DismissDirection.startToEnd,
              confirmDismiss: (_) async {
                _onSwipeToReply(msg.content, msg.type);
                return false;
              },
              background: _buildSwipeBackground(),
              child: ChatBubble(
                message: msg.content,
                timestamp: DateHelper.format(msg.timestamp),
                isMe: msg.isMe,
                type: msg.type,
                replyText: msg.replyTo,
                replyType: msg.replyToType,
                reaction: msg.reaction,
                onReactionSelected: (emoji) => _onReactionSelected(msg, emoji),
                onLongPress: () => _controller.showReactionPicker(msg.id),
                onSecondaryTap: () {},
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwipeBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.reply, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Text(
            'Reply',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyPreview() {
    return AnimatedBuilder(
      animation: _animations.replyAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animations.replyAnimation.value,
          child: _controller.replyPreview != null
              ? ReplyPreviewWidget(
                  content: _controller.replyPreview!,
                  type: _controller.replyType!,
                  onClose: () {
                    _controller.clearReplyPreview();
                    _animations.hideReplyPreview();
                  },
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildInputArea(ThemeData theme, bool isDark) {
    return MessageInputWidget(
      controller: _textController,
      focusNode: _focusNode,
      isEmojiVisible: _controller.isEmojiVisible,
      onSendText: _sendMessage,
      onSendImage: _sendImageMessage,
      onToggleEmoji: _toggleEmoji,
      theme: theme,
      isDark: isDark,
    );
  }

  Widget _buildEmojiPicker() {
    return SlideTransition(
      position: _animations.emojiSlideAnimation,
      child: _controller.isEmojiVisible
          ? EmojiPickerWidget(
              onEmojiSelected: (emoji) {
                _textController.text += emoji;
                _textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _textController.text.length),
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildFloatingActionButton(ThemeData theme) {
    return Positioned(
      right: 16,
      bottom: 100 + (_controller.isEmojiVisible ? 250 : 0),
      child: ScaleTransition(
        scale: _animations.fabAnimation,
        child: _controller.showFab
            ? FloatingActionButton.small(
                onPressed: () => _scrollToBottom(),
                backgroundColor: theme.primaryColor,
                child:
                    const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
