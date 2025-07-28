import 'package:hive/hive.dart';

import '../constants/enums.dart';

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 1; // ⚠️ Must be unique across your app

  @override
  MessageType read(BinaryReader reader) {
    return MessageType.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    writer.writeByte(obj.index);
  }
}
