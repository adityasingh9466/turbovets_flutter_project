
// Updated EmojiPickerWidget using AppTheme and AppColors
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:turbovets_flutter_challange/constants/theme/colors.dart';

class EmojiPickerWidget extends StatelessWidget {
  final Function(String) onEmojiSelected;

  const EmojiPickerWidget({
    super.key,
    required this.onEmojiSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
        ),
      ),
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) => onEmojiSelected(emoji.emoji),
        config: Config(
          emojiViewConfig: EmojiViewConfig(
            emojiSizeMax: 28,
            columns: 8,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.background,
          ),
          categoryViewConfig: CategoryViewConfig(
            iconColorSelected: AppColors.primary,
            indicatorColor: AppColors.primary,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
          ),
          bottomActionBarConfig: BottomActionBarConfig(
            showBackspaceButton: true,
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundLight,
          ),
        ),
      ),
    );
  }
}