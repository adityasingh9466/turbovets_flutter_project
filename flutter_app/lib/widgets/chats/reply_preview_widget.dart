// Updated ReplyPreviewWidget using AppTheme and AppColors
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turbovets_flutter_challange/constants/theme/colors.dart';

import '../../constants/enums.dart';

class ReplyPreviewWidget extends StatelessWidget {
  final String content;
  final MessageType type;
  final VoidCallback onClose;

  const ReplyPreviewWidget({
    super.key,
    required this.content,
    required this.type,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      decoration: BoxDecoration(
        color: AppColors.replyColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.replyColor.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.replyColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.reply,
                  color: AppColors.replyColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _buildContent()),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: onClose,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.replyColor.withOpacity(0.1),
                  foregroundColor: AppColors.replyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Replying to',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.replyColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        type == MessageType.image ? _buildImagePreview() : _buildTextPreview(),
      ],
    );
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 60,
        width: 80,
        child: Image.memory(
          base64Decode(content.split('||CAPTION||').first),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTextPreview() {
    return Text(
      content,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
    );
  }
}
