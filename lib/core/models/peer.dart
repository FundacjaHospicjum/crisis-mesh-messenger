import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'peer.g.dart';

/// Connection status of a peer
enum PeerStatus {
  online,      // Currently connected
  nearby,      // Detected but not connected
  offline,     // Last seen some time ago
  connecting,  // Connection in progress
}

/// A peer device in the mesh network
@HiveType(typeId: 1)
class Peer extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String deviceType;

  @HiveField(3)
  final DateTime lastSeen;

  @HiveField(4)
  final PeerStatus status;

  @HiveField(5)
  final int signalStrength; // RSSI or similar

  @HiveField(6)
  final String? publicKey; // For encryption

  @HiveField(7)
  final bool isTrusted; // Manually verified contact

  @HiveField(8)
  final int messageCount; // Total messages exchanged

  @HiveField(9)
  final int relayCount; // Messages relayed through this peer

  const Peer({
    required this.id,
    required this.name,
    this.deviceType = 'Unknown',
    required this.lastSeen,
    this.status = PeerStatus.nearby,
    this.signalStrength = 0,
    this.publicKey,
    this.isTrusted = false,
    this.messageCount = 0,
    this.relayCount = 0,
  });

  /// Create a copy with updated fields
  Peer copyWith({
    String? id,
    String? name,
    String? deviceType,
    DateTime? lastSeen,
    PeerStatus? status,
    int? signalStrength,
    String? publicKey,
    bool? isTrusted,
    int? messageCount,
    int? relayCount,
  }) {
    return Peer(
      id: id ?? this.id,
      name: name ?? this.name,
      deviceType: deviceType ?? this.deviceType,
      lastSeen: lastSeen ?? this.lastSeen,
      status: status ?? this.status,
      signalStrength: signalStrength ?? this.signalStrength,
      publicKey: publicKey ?? this.publicKey,
      isTrusted: isTrusted ?? this.isTrusted,
      messageCount: messageCount ?? this.messageCount,
      relayCount: relayCount ?? this.relayCount,
    );
  }

  /// Check if peer is currently available
  bool get isAvailable => status == PeerStatus.online || status == PeerStatus.nearby;

  /// Get connection quality (0-100)
  int get connectionQuality {
    if (status == PeerStatus.offline) return 0;
    if (signalStrength > -50) return 100;
    if (signalStrength > -70) return 75;
    if (signalStrength > -85) return 50;
    if (signalStrength > -95) return 25;
    return 10;
  }

  /// Convert to JSON for network transmission
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'deviceType': deviceType,
        'publicKey': publicKey,
      };

  /// Create from JSON
  factory Peer.fromJson(Map<String, dynamic> json) {
    return Peer(
      id: json['id'] as String,
      name: json['name'] as String,
      deviceType: json['deviceType'] as String? ?? 'Unknown',
      publicKey: json['publicKey'] as String?,
      lastSeen: DateTime.now(),
      status: PeerStatus.nearby,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        deviceType,
        lastSeen,
        status,
        signalStrength,
        publicKey,
        isTrusted,
        messageCount,
        relayCount,
      ];

  @override
  String toString() => 'Peer(id: $id, name: $name, status: $status)';
}
