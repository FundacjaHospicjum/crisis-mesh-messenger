import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/mesh_network_service.dart';
import '../../core/services/message_storage_service.dart';
import '../../core/di/service_locator.dart';
import '../widgets/conversation_list_item.dart';
import '../widgets/network_status_banner.dart';
import 'chat_screen.dart';
import 'network_status_screen.dart';

/// Main screen showing conversation list
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storageService = getIt<MessageStorageService>();
  
  @override
  void initState() {
    super.initState();
    _initializeMeshNetwork();
  }

  Future<void> _initializeMeshNetwork() async {
    final meshService = context.read<MeshNetworkService>();
    
    // Initialize with device info
    // TODO: Get real device ID and name
    final deviceId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final deviceName = 'My Device'; // TODO: Let user set this
    
    await meshService.initialize(deviceId, deviceName);
    
    // Start scanning and advertising
    await meshService.startScanning();
    await meshService.startAdvertising();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crisis Mesh'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NetworkStatusScreen(),
                ),
              );
            },
            tooltip: 'Network Status',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings coming soon')),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          const NetworkStatusBanner(),
          Expanded(
            child: _buildConversationList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewConversationDialog,
        icon: const Icon(Icons.message),
        label: const Text('New Message'),
      ),
    );
  }

  Widget _buildConversationList() {
    final conversations = _storageService.getAllConversations();
    
    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the button below to start messaging',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return ConversationListItem(
          conversation: conversation,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  peerId: conversation.peerId,
                  peerName: conversation.peerName,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNewConversationDialog() {
    final meshService = context.read<MeshNetworkService>();
    final peers = meshService.peers;

    if (peers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No nearby devices found. Make sure both devices have the app open.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Conversation'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: peers.length,
            itemBuilder: (context, index) {
              final peer = peers[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(peer.name[0].toUpperCase()),
                ),
                title: Text(peer.name),
                subtitle: Text(peer.status.name),
                trailing: Icon(
                  peer.isAvailable ? Icons.circle : Icons.circle_outlined,
                  color: peer.isAvailable ? Colors.green : Colors.grey,
                  size: 12,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        peerId: peer.id,
                        peerName: peer.name,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    final meshService = context.read<MeshNetworkService>();
    meshService.stopScanning();
    meshService.stopAdvertising();
    super.dispose();
  }
}
