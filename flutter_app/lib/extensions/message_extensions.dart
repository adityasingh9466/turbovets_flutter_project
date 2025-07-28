
// lib/extensions/message_extensions.dart
import '../models/chat_message.dart';
import '../constants/enums.dart';

extension ChatMessageExtensions on ChatMessage {
  bool get hasReply => replyTo != null;
  
  bool get hasReaction => reaction != null && reaction!.isNotEmpty;
  
  bool get isImageMessage => type == MessageType.image;
  
  bool get isTextMessage => type == MessageType.text;
  
  String get displayContent {
    if (isImageMessage && content.contains('||CAPTION||')) {
      return content.split('||CAPTION||').last;
    }
    return content;
  }
  
  String? get imageBase64 {
    if (isImageMessage) {
      return content.split('||CAPTION||').first;
    }
    return null;
  }
  
  String? get imageCaption {
    if (isImageMessage && content.contains('||CAPTION||')) {
      final parts = content.split('||CAPTION||');
      return parts.length > 1 ? parts.last : null;
    }
    return null;
  }
}
