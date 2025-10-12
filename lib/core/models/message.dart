import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'message.g.dart';

/// Status of a message in the mesh network
enum MessageStatus {
  sending,    // Message is being sent
  sent,       // Message sent to at least one node
  delivered,  // Message delivered to recipient
  failed,     // Message failed to send
  relayed,    // Message is being relayed (not for us)
}

/// A message in the mesh network
@HiveType(typeId: 0)
class Message extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String senderId;

  @HiveField(2)
  final String recipientId;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final MessageStatus status;

  @HiveField(6)
  final int hopCount;

  @HiveField(7)
  final int maxHops;

  @HiveField(8)
  final List<String> routePath; // Track path through mesh

  @HiveField(9)
  final String? encryptedContent; // Encrypted version of content

  @HiveField(10)
  final bool isEncrypted;

  const Message({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.timestamp,
    this.status = MessageStatus.sending,
    this.hopCount = 0,
    this.maxHops = 10,
    this.routePath = const [],
    this.encryptedContent,
    this.isEncrypted = false,
  });

  /// Create a copy with updated fields
  Message copyWith({
    String? id,
    String? senderId,
    String? recipientId,
    String? content,
    DateTime? timestamp,
    MessageStatus? status,
    int? hopCount,
    int? maxHops,
    List<String>? routePath,
    String? encryptedContent,
    bool? isEncrypted,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      hopCount: hopCount ?? this.hopCount,
      maxHops: maxHops ?? this.maxHops,
      routePath: routePath ?? this.routePath,
      encryptedContent: encryptedContent ?? this.encryptedContent,
      isEncrypted: isEncrypted ?? this.isEncrypted,
    );
  }

  /// Check if message should still be forwarded
  bool get canForward => hopCount < maxHops;

  /// Increment hop count for forwarding
  Message incrementHop(String nodeId) {
    return copyWith(
      hopCount: hopCount + 1,
      routePath: [...routePath, nodeId],
    );
  }

  /// Convert to JSON for transmission
  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'recipientId': recipientId,
        'content': encryptedContent ?? content,
        'timestamp': timestamp.toIso8601String(),
        'hopCount': hopCount,
        'maxHops': maxHops,
        'routePath': routePath,
        'isEncrypted': isEncrypted,
      };

  /// Create from JSON received over network
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      recipientId: json['recipientId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      hopCount: json['hopCount'] as int? ?? 0,
      maxHops: json['maxHops'] as int? ?? 10,
      routePath: (json['routePath'] as List?)?.cast<String>() ?? [],
      encryptedContent: json['isEncrypted'] == true ? json['content'] as String : null,
      isEncrypted: json['isEncrypted'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        senderId,
        recipientId,
        content,
        timestamp,
        status,
        hopCount,
        maxHops,
        routePath,
        encryptedContent,
        isEncrypted,
      ];

  @override
  String toString() => 'Message(id: $id, from: $senderId, to: $recipientId, hops: $hopCount)';
}
