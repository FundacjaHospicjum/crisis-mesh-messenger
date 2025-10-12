import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import '../models/peer.dart';
import '../models/message.dart';

/// Service managing the mesh network connections and discovery
class MeshNetworkService extends ChangeNotifier {
  final Logger _logger = Logger();
  
  // Current state
  final Map<String, Peer> _peers = {};
  final Map<String, DateTime> _lastPeerUpdate = {};
  bool _isScanning = false;
  bool _isAdvertising = false;
  String? _deviceId;
  String? _deviceName;

  // Callbacks
  Function(Message)? onMessageReceived;
  Function(Peer)? onPeerDiscovered;
  Function(String)? onPeerDisconnected;

  // Getters
  List<Peer> get peers => _peers.values.toList();
  List<Peer> get onlinePeers => 
      _peers.values.where((p) => p.status == PeerStatus.online).toList();
  bool get isScanning => _isScanning;
  bool get isAdvertising => _isAdvertising;
  String? get deviceId => _deviceId;
  String? get deviceName => _deviceName;

  /// Initialize the mesh network service
  Future<void> initialize(String deviceId, String deviceName) async {
    _deviceId = deviceId;
    _deviceName = deviceName;
    _logger.i('Mesh network initialized: $deviceName ($deviceId)');
  }

  /// Start scanning for nearby peers
  Future<void> startScanning() async {
    if (_isScanning) return;
    
    _logger.i('Starting peer discovery...');
    _isScanning = true;
    notifyListeners();

    // TODO: Implement platform-specific discovery
    // Android: Nearby Connections API, WiFi Direct
    // iOS: Multipeer Connectivity
    
    // Simulate peer discovery for now
    _simulatePeerDiscovery();
  }

  /// Stop scanning for peers
  Future<void> stopScanning() async {
    if (!_isScanning) return;
    
    _logger.i('Stopping peer discovery...');
    _isScanning = false;
    notifyListeners();
  }

  /// Start advertising this device
  Future<void> startAdvertising() async {
    if (_isAdvertising) return;
    
    _logger.i('Starting advertising: $_deviceName');
    _isAdvertising = true;
    notifyListeners();

    // TODO: Implement platform-specific advertising
  }

  /// Stop advertising this device
  Future<void> stopAdvertising() async {
    if (!_isAdvertising) return;
    
    _logger.i('Stopping advertising');
    _isAdvertising = false;
    notifyListeners();
  }

  /// Connect to a specific peer
  Future<bool> connectToPeer(String peerId) async {
    _logger.i('Connecting to peer: $peerId');
    
    final peer = _peers[peerId];
    if (peer == null) {
      _logger.w('Peer not found: $peerId');
      return false;
    }

    // Update peer status
    _updatePeer(peer.copyWith(status: PeerStatus.connecting));

    // TODO: Implement platform-specific connection
    
    // Simulate connection
    await Future.delayed(const Duration(seconds: 1));
    _updatePeer(peer.copyWith(status: PeerStatus.online));
    
    return true;
  }

  /// Disconnect from a peer
  Future<void> disconnectFromPeer(String peerId) async {
    _logger.i('Disconnecting from peer: $peerId');
    
    final peer = _peers[peerId];
    if (peer != null) {
      _updatePeer(peer.copyWith(status: PeerStatus.offline));
    }

    // TODO: Implement platform-specific disconnection
  }

  /// Send a message through the mesh network
  Future<bool> sendMessage(Message message) async {
    _logger.i('Sending message: ${message.id} to ${message.recipientId}');

    // Check if recipient is directly connected
    final recipient = _peers[message.recipientId];
    if (recipient?.status == PeerStatus.online) {
      return await _sendDirectMessage(message, recipient!);
    }

    // Otherwise, use epidemic routing - send to all connected peers
    return await _broadcastMessage(message);
  }

  /// Send message directly to a connected peer
  Future<bool> _sendDirectMessage(Message message, Peer peer) async {
    try {
      // TODO: Implement platform-specific message sending
      // final messageJson = jsonEncode(message.toJson());
      // Use messageJson when implementing real network transmission
      
      _logger.d('Sending direct message to ${peer.name}: ${message.content}');
      
      // Simulate sending
      await Future.delayed(const Duration(milliseconds: 100));
      
      return true;
    } catch (e) {
      _logger.e('Failed to send message: $e');
      return false;
    }
  }

  /// Broadcast message to all connected peers (epidemic routing)
  Future<bool> _broadcastMessage(Message message) async {
    if (!message.canForward) {
      _logger.w('Message has reached max hops: ${message.id}');
      return false;
    }

    final onlinePeersList = onlinePeers;
    if (onlinePeersList.isEmpty) {
      _logger.w('No peers available to relay message');
      return false;
    }

    _logger.i('Broadcasting message to ${onlinePeersList.length} peers');
    
    int successCount = 0;
    for (final peer in onlinePeersList) {
      final forwarded = message.incrementHop(_deviceId!);
      if (await _sendDirectMessage(forwarded, peer)) {
        successCount++;
      }
    }

    return successCount > 0;
  }

  /// Handle received message
  void _handleReceivedMessage(Message message) {
    _logger.i('Received message: ${message.id}');

    // Check if message is for us
    if (message.recipientId == _deviceId) {
      _logger.i('Message is for us!');
      onMessageReceived?.call(message);
      return;
    }

    // Forward the message if it can still hop
    if (message.canForward) {
      _logger.i('Forwarding message: ${message.id}');
      _broadcastMessage(message);
    } else {
      _logger.w('Message reached max hops, dropping: ${message.id}');
    }
  }

  /// Update or add a peer
  void _updatePeer(Peer peer) {
    final existing = _peers[peer.id];
    if (existing == null) {
      _logger.i('New peer discovered: ${peer.name}');
      _peers[peer.id] = peer;
      onPeerDiscovered?.call(peer);
    } else {
      _peers[peer.id] = peer;
    }
    
    _lastPeerUpdate[peer.id] = DateTime.now();
    notifyListeners();
  }

  /// Remove stale peers (not seen in a while)
  void _cleanupStalePeers() {
    final now = DateTime.now();
    final staleThreshold = const Duration(minutes: 5);
    
    final staleIds = <String>[];
    _lastPeerUpdate.forEach((id, lastUpdate) {
      if (now.difference(lastUpdate) > staleThreshold) {
        staleIds.add(id);
      }
    });

    for (final id in staleIds) {
      _logger.i('Removing stale peer: $id');
      _peers.remove(id);
      _lastPeerUpdate.remove(id);
      onPeerDisconnected?.call(id);
    }

    if (staleIds.isNotEmpty) {
      notifyListeners();
    }
  }

  /// Simulate peer discovery (for testing)
  void _simulatePeerDiscovery() {
    // This is temporary - replace with real discovery
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_isScanning) {
        timer.cancel();
        return;
      }

      // Simulate finding a random peer
      final simulatedPeer = Peer(
        id: 'peer_${DateTime.now().millisecondsSinceEpoch}',
        name: 'User ${_peers.length + 1}',
        deviceType: 'Android',
        lastSeen: DateTime.now(),
        status: PeerStatus.nearby,
        signalStrength: -65,
      );

      _updatePeer(simulatedPeer);
    });

    // Cleanup stale peers periodically
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (!_isScanning) {
        timer.cancel();
        return;
      }
      _cleanupStalePeers();
    });
  }

  @override
  void dispose() {
    stopScanning();
    stopAdvertising();
    _peers.clear();
    _lastPeerUpdate.clear();
    super.dispose();
  }
}
