import 'package:hive/hive.dart';
import '../constants/enums.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final DateTime timestamp;
  @HiveField(3)
  final bool isMe;
  @HiveField(4)
  final MessageType type;
  @HiveField(5)
  final String? replyTo;
  @HiveField(6)
  final MessageType? replyToType;
  @HiveField(7)
  final String? reaction;

  ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isMe,
    required this.type,
    this.replyTo,
    this.replyToType,
    this.reaction,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    DateTime? timestamp,
    bool? isMe,
    MessageType? type,
    String? replyTo,
    MessageType? replyToType,
    String? reaction,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
      type: type ?? this.type,
      replyTo: replyTo ?? this.replyTo,
      replyToType: replyToType ?? this.replyToType,
      reaction: reaction ?? this.reaction,
    );
  }
}
