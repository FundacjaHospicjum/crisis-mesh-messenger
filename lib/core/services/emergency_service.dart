import 'dart:async';
import 'dart:math' show pi, sin, cos, sqrt, atan2;
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/emergency_signal.dart';

/// Manages emergency signals and their propagation through the mesh
class EmergencyService extends ChangeNotifier {
  final List<EmergencySignal> _activeSignals = [];
  final List<EmergencySignal> _resolvedSignals = [];
  final Map<String, DateTime> _signalCache = {}; // Prevent duplicates
  final _uuid = const Uuid();
  
  Timer? _cleanupTimer;
  
  // Configuration
  static const int maxHopCount = 10; // Maximum times a signal can be relayed
  static const Duration signalTTL = Duration(hours: 24); // Time to live
  static const Duration cleanupInterval = Duration(minutes: 5);
  
  List<EmergencySignal> get activeSignals => List.unmodifiable(_activeSignals);
  List<EmergencySignal> get resolvedSignals => List.unmodifiable(_resolvedSignals);
  
  /// Get count of critical active signals
  int get criticalSignalsCount => _activeSignals
      .where((s) => s.level == EmergencyLevel.critical && s.isActive)
      .length;
  
  /// Get most recent critical signal
  EmergencySignal? get mostRecentCritical {
    final criticals = _activeSignals
        .where((s) => s.level == EmergencyLevel.critical && s.isActive)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return criticals.isNotEmpty ? criticals.first : null;
  }

  EmergencyService() {
    _startCleanupTimer();
  }

  /// Broadcast an emergency signal
  Future<EmergencySignal> broadcastEmergency({
    required String senderId,
    required String senderName,
    required SignalType type,
    required EmergencyLevel level,
    required String message,
    double? latitude,
    double? longitude,
  }) async {
    final signal = EmergencySignal(
      id: _uuid.v4(),
      senderId: senderId,
      senderName: senderName,
      type: type,
      level: level,
      timestamp: DateTime.now(),
      message: message,
      latitude: latitude,
      longitude: longitude,
      hopCount: 0,
      routePath: [senderId],
    );

    _activeSignals.add(signal);
    _signalCache[signal.id] = signal.timestamp;
    
    // Sort by priority (critical first)
    _activeSignals.sort((a, b) => b.getPriorityScore().compareTo(a.getPriorityScore()));
    
    notifyListeners();
    
    debugPrint('🆘 Emergency signal broadcast: ${signal.type} - ${signal.message}');
    
    return signal;
  }

  /// Receive an emergency signal from another device (via mesh)
  Future<bool> receiveSignal(EmergencySignal signal) async {
    // Check if signal already received (deduplication)
    if (_signalCache.containsKey(signal.id)) {
      return false; // Already have this signal
    }

    // Check if signal exceeded max hops
    if (signal.hopCount >= maxHopCount) {
      debugPrint('⚠️ Signal ${signal.id} exceeded max hops, not relaying');
      return false;
    }

    // Check if signal expired
    if (DateTime.now().difference(signal.timestamp) > signalTTL) {
      debugPrint('⚠️ Signal ${signal.id} expired, not relaying');
      return false;
    }

    // Add to active signals
    _activeSignals.add(signal);
    _signalCache[signal.id] = signal.timestamp;
    
    // Sort by priority
    _activeSignals.sort((a, b) => b.getPriorityScore().compareTo(a.getPriorityScore()));
    
    notifyListeners();
    
    debugPrint('📡 Received emergency signal: ${signal.type} from ${signal.senderName}');
    debugPrint('   Hops: ${signal.hopCount}, Priority: ${signal.getPriorityScore()}');
    
    // Critical signals trigger visual/audio alert
    if (signal.level == EmergencyLevel.critical) {
      _triggerCriticalAlert(signal);
    }
    
    return true; // Signal should be relayed to other peers
  }

  /// Mark a signal as resolved
  Future<void> resolveSignal(String signalId, String responderId) async {
    final signalIndex = _activeSignals.indexWhere((s) => s.id == signalId);
    
    if (signalIndex != -1) {
      final signal = _activeSignals[signalIndex];
      final resolved = signal.resolve(responderId);
      
      _activeSignals.removeAt(signalIndex);
      _resolvedSignals.add(resolved);
      
      notifyListeners();
      
      debugPrint('✅ Signal ${signalId} resolved by ${responderId}');
    }
  }

  /// Get signals that should be relayed to a specific peer
  List<EmergencySignal> getSignalsToRelay(String peerId) {
    return _activeSignals
        .where((signal) =>
            signal.isActive &&
            !signal.routePath.contains(peerId) && // Don't send back to sender
            signal.hopCount < maxHopCount)
        .map((signal) => signal.withHop(peerId))
        .toList();
  }

  /// Get nearby emergency signals (within radius)
  List<EmergencySignal> getNearbySignals({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) {
    return _activeSignals.where((signal) {
      if (signal.latitude == null || signal.longitude == null) {
        return false;
      }
      
      final distance = _calculateDistance(
        latitude,
        longitude,
        signal.latitude!,
        signal.longitude!,
      );
      
      return distance <= radiusKm;
    }).toList();
  }

  /// Calculate distance between two coordinates (Haversine formula)
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;
    
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2));
    
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  /// Trigger alert for critical signal
  void _triggerCriticalAlert(EmergencySignal signal) {
    // TODO: Integrate with notification service
    // TODO: Play alert sound
    // TODO: Vibrate device
    debugPrint('🚨 CRITICAL ALERT: ${signal.message}');
  }

  /// Start cleanup timer to remove old signals
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(cleanupInterval, (_) {
      _cleanup();
    });
  }

  /// Clean up expired signals
  void _cleanup() {
    final now = DateTime.now();
    bool changed = false;

    // Remove expired signals from active list
    _activeSignals.removeWhere((signal) {
      final expired = now.difference(signal.timestamp) > signalTTL;
      if (expired) {
        changed = true;
        debugPrint('🗑️ Removing expired signal: ${signal.id}');
      }
      return expired;
    });

    // Clean cache
    _signalCache.removeWhere((id, timestamp) {
      return now.difference(timestamp) > signalTTL;
    });

    // Keep only last 100 resolved signals
    if (_resolvedSignals.length > 100) {
      _resolvedSignals.removeRange(0, _resolvedSignals.length - 100);
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  /// Get statistics
  Map<String, int> getStatistics() {
    return {
      'activeSignals': _activeSignals.length,
      'resolvedSignals': _resolvedSignals.length,
      'criticalSignals': criticalSignalsCount,
      'cachedSignals': _signalCache.length,
    };
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    super.dispose();
  }
}
