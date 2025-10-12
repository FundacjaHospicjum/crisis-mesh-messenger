// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 0;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      id: fields[0] as String,
      senderId: fields[1] as String,
      recipientId: fields[2] as String,
      content: fields[3] as String,
      timestamp: fields[4] as DateTime,
      status: fields[5] as MessageStatus,
      hopCount: fields[6] as int,
      maxHops: fields[7] as int,
      routePath: (fields[8] as List).cast<String>(),
      encryptedContent: fields[9] as String?,
      isEncrypted: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.recipientId)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.hopCount)
      ..writeByte(7)
      ..write(obj.maxHops)
      ..writeByte(8)
      ..write(obj.routePath)
      ..writeByte(9)
      ..write(obj.encryptedContent)
      ..writeByte(10)
      ..write(obj.isEncrypted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageStatusAdapter extends TypeAdapter<MessageStatus> {
  @override
  final int typeId = 3;

  @override
  MessageStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageStatus.sending;
      case 1:
        return MessageStatus.sent;
      case 2:
        return MessageStatus.delivered;
      case 3:
        return MessageStatus.failed;
      case 4:
        return MessageStatus.relayed;
      default:
        return MessageStatus.sending;
    }
  }

  @override
  void write(BinaryWriter writer, MessageStatus obj) {
    switch (obj) {
      case MessageStatus.sending:
        writer.writeByte(0);
        break;
      case MessageStatus.sent:
        writer.writeByte(1);
        break;
      case MessageStatus.delivered:
        writer.writeByte(2);
        break;
      case MessageStatus.failed:
        writer.writeByte(3);
        break;
      case MessageStatus.relayed:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
