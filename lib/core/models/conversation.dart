import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'message.dart';

part 'conversation.g.dart';

/// A conversation with a peer
@HiveType(typeId: 2)
class Conversation extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String peerId;

  @HiveField(2)
  final String peerName;

  @HiveField(3)
  final DateTime lastMessageTime;

  @HiveField(4)
  final String lastMessagePreview;

  @HiveField(5)
  final int unreadCount;

  @HiveField(6)
  final bool isPinned;

  @HiveField(7)
  final bool isMuted;

  const Conversation({
    required this.id,
    required this.peerId,
    required this.peerName,
    required this.lastMessageTime,
    required this.lastMessagePreview,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isMuted = false,
  });

  /// Create a copy with updated fields
  Conversation copyWith({
    String? id,
    String? peerId,
    String? peerName,
    DateTime? lastMessageTime,
    String? lastMessagePreview,
    int? unreadCount,
    bool? isPinned,
    bool? isMuted,
  }) {
    return Conversation(
      id: id ?? this.id,
      peerId: peerId ?? this.peerId,
      peerName: peerName ?? this.peerName,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      unreadCount: unreadCount ?? this.unreadCount,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  /// Update conversation with new message
  Conversation updateWithMessage(Message message, String currentUserId) {
    final isIncoming = message.recipientId == currentUserId;
    return copyWith(
      lastMessageTime: message.timestamp,
      lastMessagePreview: message.content.length > 50 
          ? '${message.content.substring(0, 50)}...' 
          : message.content,
      unreadCount: isIncoming ? unreadCount + 1 : unreadCount,
    );
  }

  /// Mark all messages as read
  Conversation markAsRead() => copyWith(unreadCount: 0);

  @override
  List<Object?> get props => [
        id,
        peerId,
        peerName,
        lastMessageTime,
        lastMessagePreview,
        unreadCount,
        isPinned,
        isMuted,
      ];

  @override
  String toString() => 'Conversation(peer: $peerName, unread: $unreadCount)';
}
