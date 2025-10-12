// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PeerAdapter extends TypeAdapter<Peer> {
  @override
  final int typeId = 1;

  @override
  Peer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Peer(
      id: fields[0] as String,
      name: fields[1] as String,
      deviceType: fields[2] as String,
      lastSeen: fields[3] as DateTime,
      status: fields[4] as PeerStatus,
      signalStrength: fields[5] as int,
      publicKey: fields[6] as String?,
      isTrusted: fields[7] as bool,
      messageCount: fields[8] as int,
      relayCount: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Peer obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.deviceType)
      ..writeByte(3)
      ..write(obj.lastSeen)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.signalStrength)
      ..writeByte(6)
      ..write(obj.publicKey)
      ..writeByte(7)
      ..write(obj.isTrusted)
      ..writeByte(8)
      ..write(obj.messageCount)
      ..writeByte(9)
      ..write(obj.relayCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PeerStatusAdapter extends TypeAdapter<PeerStatus> {
  @override
  final int typeId = 4;

  @override
  PeerStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PeerStatus.online;
      case 1:
        return PeerStatus.nearby;
      case 2:
        return PeerStatus.offline;
      case 3:
        return PeerStatus.connecting;
      default:
        return PeerStatus.nearby;
    }
  }

  @override
  void write(BinaryWriter writer, PeerStatus obj) {
    switch (obj) {
      case PeerStatus.online:
        writer.writeByte(0);
        break;
      case PeerStatus.nearby:
        writer.writeByte(1);
        break;
      case PeerStatus.offline:
        writer.writeByte(2);
        break;
      case PeerStatus.connecting:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeerStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
