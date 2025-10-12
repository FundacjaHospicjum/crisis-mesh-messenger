// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversationAdapter extends TypeAdapter<Conversation> {
  @override
  final int typeId = 2;

  @override
  Conversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Conversation(
      id: fields[0] as String,
      peerId: fields[1] as String,
      peerName: fields[2] as String,
      lastMessageTime: fields[3] as DateTime,
      lastMessagePreview: fields[4] as String,
      unreadCount: fields[5] as int,
      isPinned: fields[6] as bool,
      isMuted: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Conversation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.peerId)
      ..writeByte(2)
      ..write(obj.peerName)
      ..writeByte(3)
      ..write(obj.lastMessageTime)
      ..writeByte(4)
      ..write(obj.lastMessagePreview)
      ..writeByte(5)
      ..write(obj.unreadCount)
      ..writeByte(6)
      ..write(obj.isPinned)
      ..writeByte(7)
      ..write(obj.isMuted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
