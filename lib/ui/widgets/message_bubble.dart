import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/message.dart';

/// A chat message bubble
class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({
    required this.message,
    required this.isMe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isMe ? colorScheme.onPrimary : colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    color: isMe
                        ? colorScheme.onPrimary.withOpacity(0.7)
                        : colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(colorScheme),
                ],
                if (message.hopCount > 0) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.repeat,
                    size: 12,
                    color: isMe
                        ? colorScheme.onPrimary.withOpacity(0.7)
                        : colorScheme.onSurface.withOpacity(0.6),
                  ),
                  Text(
                    ' ${message.hopCount}',
                    style: TextStyle(
                      color: isMe
                          ? colorScheme.onPrimary.withOpacity(0.7)
                          : colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(ColorScheme colorScheme) {
    switch (message.status) {
      case MessageStatus.sending:
        return Icon(
          Icons.access_time,
          size: 12,
          color: colorScheme.onPrimary.withOpacity(0.7),
        );
      case MessageStatus.sent:
        return Icon(
          Icons.check,
          size: 12,
          color: colorScheme.onPrimary.withOpacity(0.7),
        );
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all,
          size: 12,
          color: colorScheme.onPrimary.withOpacity(0.7),
        );
      case MessageStatus.failed:
        return Icon(
          Icons.error_outline,
          size: 12,
          color: Colors.red[300],
        );
      case MessageStatus.relayed:
        return const SizedBox.shrink();
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    } else {
      return DateFormat('HH:mm').format(timestamp);
    }
  }
}
