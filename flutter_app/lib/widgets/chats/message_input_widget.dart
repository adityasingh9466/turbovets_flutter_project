
// Updated MessageInputWidget using AppTheme and AppColors
import 'package:flutter/material.dart';
import 'package:turbovets_flutter_challange/constants/theme/colors.dart';
import 'package:turbovets_flutter_challange/constants/theme/theme.dart';

class MessageInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEmojiVisible;
  final VoidCallback onSendText;
  final VoidCallback onSendImage;
  final VoidCallback onToggleEmoji;
  final ThemeData theme;
  final bool isDark;

  const MessageInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isEmojiVisible,
    required this.onSendText,
    required this.onSendImage,
    required this.onToggleEmoji,
    required this.theme,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildActionButton(
              icon: Icons.photo_library_rounded,
              onPressed: onSendImage,
              color: Colors.purple,
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: isEmojiVisible ? Icons.keyboard : Icons.emoji_emotions,
              onPressed: onToggleEmoji,
              color: AppColors.accent,
              isActive: isEmojiVisible,
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildTextField()),
            const SizedBox(width: 8),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: AppTheme.inputContainerDecoration(
        isDark: isDark,
        hasFocus: focusNode.hasFocus,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: 5,
        minLines: 1,
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(
          color: isDark ? AppColors.textDark : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Type a message...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.textSecondary : Colors.grey[500],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
        onSubmitted: (_) => onSendText(),
      ),
    );
  }

  Widget _buildSendButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onSendText,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    bool isActive = false,
  }) {
    return Material(
      color: isActive ? color.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isActive ? Border.all(color: color.withOpacity(0.3)) : null,
          ),
          child: Icon(
            icon,
            color: isActive 
                ? color 
                : (isDark ? AppColors.textSecondary : Colors.grey[600]),
            size: 22,
          ),
        ),
      ),
    );
  }
}
