// Updated ChatBubble using AppTheme and AppColors - No gradient, fixed dark mode text
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turbovets_flutter_challange/constants/theme/colors.dart';
import 'package:turbovets_flutter_challange/constants/theme/theme.dart';

import '../../constants/enums.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final String timestamp;
  final bool isMe;
  final MessageType type;
  final MessageType? replyType;
  final String? replyText;
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;
  final VoidCallback? scrollCallback;
  final String? reaction;
  final Function(String emoji)? onReactionSelected;

  const ChatBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isMe,
    required this.type,
    this.replyType,
    this.replyText,
    this.onLongPress,
    this.onSecondaryTap,
    this.scrollCallback,
    this.reaction,
    this.onReactionSelected,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with TickerProviderStateMixin {
  bool _isHoveringMessage = false;
  bool _isHoveringEmojis = false;
  bool _showReactionsMobile = false;

  late AnimationController _scaleController;
  late AnimationController _flyingEmojiController;
  late AnimationController _slideController;

  late Animation<double> _scaleAnimation;
  late Animation<Offset> _flyingEmojiAnimation;
  late Animation<double> _flyingEmojiOpacity;
  late Animation<double> _flyingEmojiScale;
  late Animation<Offset> _slideAnimation;

  String? _flyingEmoji;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _flyingEmojiController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _flyingEmojiAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -2),
    ).animate(CurvedAnimation(
      parent: _flyingEmojiController,
      curve: Curves.easeOutCubic,
    ));

    _flyingEmojiOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _flyingEmojiController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    _flyingEmojiScale = Tween<double>(begin: 1, end: 1.5).animate(
      CurvedAnimation(
        parent: _flyingEmojiController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    // Start slide animation
    _slideController.forward();
  }

  void _handleLongPress() {
    HapticFeedback.mediumImpact();
    if (!kIsWeb) {
      setState(() => _showReactionsMobile = true);
    }
    widget.onLongPress?.call();
  }

  void _selectReaction(String emoji) {
    HapticFeedback.lightImpact();
    setState(() => _flyingEmoji = emoji);
    _flyingEmojiController.forward().then((_) {
      _flyingEmojiController.reset();
      setState(() => _flyingEmoji = null);
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      widget.onReactionSelected?.call(emoji);
    });

    setState(() {
      _showReactionsMobile = false;
      _isHoveringMessage = false;
      _isHoveringEmojis = false;
    });
  }

  void _setMessageHovered(bool hovered) {
    if (mounted && _isHoveringMessage != hovered) {
      setState(() => _isHoveringMessage = hovered);
    }
  }

  bool get _shouldShowReactions => _isHoveringMessage || _showReactionsMobile;

  // Custom decoration without gradient
  BoxDecoration _getChatBubbleDecoration({
    required bool isMe,
    required bool isDark,
    required bool isHovered,
  }) {
    Color backgroundColor;

    if (isMe) {
      // My messages - solid primary color
      backgroundColor = AppColors.primary;
    } else {
      // Incoming messages - different colors for light/dark mode
      backgroundColor = isDark
          ? AppColors.darkSurface // Dark surface for dark mode
          : Colors.grey[100]!; // Light grey for light mode
    }

    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(18),
        bottomLeft: Radius.circular(isMe ? 18 : 4),
        bottomRight: Radius.circular(isMe ? 4 : 18),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
          blurRadius: isHovered ? 8 : 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _flyingEmojiController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final alignment =
        widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    String mainContent = widget.message;
    if (widget.type == MessageType.text && widget.message.startsWith('↪️')) {
      final parts = widget.message.split('\n');
      if (parts.length > 1) {
        mainContent = parts.sublist(1).join('\n');
      }
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.replyText != null && widget.replyType != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.isMe
                  ? AppColors.withOpacity(Colors.white, 0.2)
                  : AppColors.withOpacity(AppColors.textSecondary, 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border(
                left: BorderSide(
                  color: widget.isMe ? Colors.white : AppColors.primary,
                  width: 3,
                ),
              ),
            ),
            child: widget.replyType == MessageType.image
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: Image.memory(
                        base64Decode(
                            widget.replyText!.split('||CAPTION||').first),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Text(
                    widget.replyText!,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: widget.isMe
                          ? AppColors.withOpacity(Colors.white, 0.8)
                          : AppColors.textSecondary,
                    ),
                  ),
          ),
        if (widget.type == MessageType.image)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'image-${widget.message}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.memory(
                      base64Decode(widget.message.split('||CAPTION||').first),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      frameBuilder: (context, child, frame, wasSyncLoaded) {
                        if (wasSyncLoaded || frame != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            widget.scrollCallback?.call();
                          });
                          return child;
                        } else {
                          return Container(
                            color: isDark
                                ? AppColors.darkSurface
                                : Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              if (widget.message.contains('||CAPTION||')) ...[
                const SizedBox(height: 8),
                Text(
                  widget.message.split('||CAPTION||')[1],
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isMe
                        ? Colors.white
                        : (isDark ? Colors.white : AppColors.textPrimary),
                  ),
                ),
              ],
            ],
          )
        else
          Text(
            mainContent,
            style: TextStyle(
              fontSize: 16,
              color: widget.isMe
                  ? Colors.white
                  : (isDark
                      ? Colors.white
                      : AppColors.textPrimary), // Fixed dark mode text color
              height: 1.4,
            ),
          ),
      ],
    );

    Widget reactionRow = AnimatedOpacity(
      opacity: _shouldShowReactions ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Visibility(
        visible: _shouldShowReactions,
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          decoration: AppTheme.reactionPickerDecoration(isDark),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: ['❤️', '😂', '👍', '🎉', '😮', '😢'].map((emoji) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _selectReaction(emoji),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child:
                            Text(emoji, style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );

    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        child: GestureDetector(
          onLongPress: _handleLongPress,
          onSecondaryTap: widget.onSecondaryTap,
          child: MouseRegion(
            onEnter: (_) {
              if (kIsWeb) _setMessageHovered(true);
            },
            onExit: (_) {
              if (kIsWeb) _setMessageHovered(false);
            },
            child: Column(
              crossAxisAlignment: alignment,
              children: [
                if (_shouldShowReactions) reactionRow,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: widget.isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!widget.isMe) ...[
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primary,
                              child: const Icon(
                                Icons.support_agent,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBackground
                                      : Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        transform: Matrix4.identity()
                          ..scale(_isHoveringMessage ? 1.02 : 1.0),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: _getChatBubbleDecoration(
                            isMe: widget.isMe,
                            isDark: isDark,
                            isHovered: _isHoveringMessage,
                          ),
                          child: content,
                        ),
                      ),
                    ),
                    if (widget.isMe) const SizedBox(width: 8),
                  ],
                ),
                if (widget.reaction != null)
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 300),
                    tween: Tween(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (0.2 * value),
                        child: Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(isDark ? 0.3 : 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.reaction!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 4),
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.isMe ? 0 : 44,
                    right: widget.isMe ? 8 : 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: widget.isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.timestamp,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (widget.isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.done_all,
                          size: 14,
                          color: AppColors.primary.withOpacity(0.7),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
