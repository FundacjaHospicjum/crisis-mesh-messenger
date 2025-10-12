import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/models/message.dart';
import '../../core/services/mesh_network_service.dart';
import '../../core/services/message_storage_service.dart';
import '../../core/di/service_locator.dart';
import '../widgets/message_bubble.dart';

/// Chat screen for messaging with a specific peer
class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerName;

  const ChatScreen({
    required this.peerId,
    required this.peerName,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _storageService = getIt<MessageStorageService>();
  final _uuid = const Uuid();
  
  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupMessageListener();
  }

  void _loadMessages() {
    final meshService = context.read<MeshNetworkService>();
    final deviceId = meshService.deviceId ?? '';
    
    setState(() {
      _messages = _storageService.getMessagesForConversation(
        widget.peerId,
        deviceId,
      );
    });

    // Mark conversation as read
    final conversation = _storageService.getConversationByPeer(widget.peerId);
    if (conversation != null) {
      _storageService.markConversationAsRead(conversation.id);
    }
  }

  void _setupMessageListener() {
    final meshService = context.read<MeshNetworkService>();
    meshService.onMessageReceived = (message) {
      if (message.senderId == widget.peerId) {
        setState(() {
          _messages.add(message);
        });
        _scrollToBottom();
        
        // Save message
        _storageService.saveMessage(message);
        _storageService.updateConversationWithMessage(
          message,
          meshService.deviceId ?? '',
          widget.peerName,
        );
      }
    };
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final meshService = context.read<MeshNetworkService>();
    final deviceId = meshService.deviceId ?? '';

    final message = Message(
      id: _uuid.v4(),
      senderId: deviceId,
      recipientId: widget.peerId,
      content: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    setState(() {
      _messages.add(message);
    });

    _messageController.clear();
    _scrollToBottom();

    // Send through mesh network
    meshService.sendMessage(message).then((success) {
      if (success) {
        final updatedMessage = message.copyWith(status: MessageStatus.sent);
        setState(() {
          final index = _messages.indexWhere((m) => m.id == message.id);
          if (index != -1) {
            _messages[index] = updatedMessage;
          }
        });
        _storageService.saveMessage(updatedMessage);
      } else {
        final updatedMessage = message.copyWith(status: MessageStatus.failed);
        setState(() {
          final index = _messages.indexWhere((m) => m.id == message.id);
          if (index != -1) {
            _messages[index] = updatedMessage;
          }
        });
        _storageService.saveMessage(updatedMessage);
      }
    });

    // Update conversation
    _storageService.updateConversationWithMessage(
      message,
      deviceId,
      widget.peerName,
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final meshService = context.watch<MeshNetworkService>();
    final peer = meshService.peers.where((p) => p.id == widget.peerId).firstOrNull;
    final isOnline = peer?.isAvailable ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.peerName),
            Text(
              isOnline ? 'Online' : 'Offline',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isOnline ? Colors.green : Colors.grey,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showPeerInfo(peer);
            },
            tooltip: 'Peer Info',
          ),
        ],
      ),
      body: Column(
        children: [
          if (!isOnline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              color: Colors.orange.withOpacity(0.2),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Peer is offline. Messages will be delivered when they come online.',
                      style: TextStyle(
                        color: Colors.orange[900],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No messages yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start the conversation!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                  ),
            ),
          ],
        ),
      );
    }

    final meshService = context.read<MeshNetworkService>();
    final currentUserId = meshService.deviceId ?? '';

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isMe = message.senderId == currentUserId;
        
        return MessageBubble(
          message: message,
          isMe: isMe,
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            tooltip: 'Send',
          ),
        ],
      ),
    );
  }

  void _showPeerInfo(dynamic peer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.peerName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('ID', widget.peerId),
            _infoRow('Status', peer?.status.name ?? 'Unknown'),
            _infoRow('Device', peer?.deviceType ?? 'Unknown'),
            if (peer != null) ...[
              _infoRow('Signal', '${peer.connectionQuality}%'),
              _infoRow('Messages', '${_messages.length}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
