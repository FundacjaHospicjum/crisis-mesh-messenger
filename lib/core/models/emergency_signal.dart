/// Emergency signal priority levels
enum EmergencyLevel {
  critical, // Life-threatening: injury, trapped, immediate danger
  high, // Urgent help needed: medical, food, water
  medium, // Need assistance: lost, scared, need information
  low, // Check-in: I'm safe, status update
}

/// Emergency signal types
enum SignalType {
  sos, // General distress
  medical, // Medical emergency
  trapped, // Physically trapped
  danger, // Immediate danger nearby
  safe, // Safety check-in
  needWater,
  needFood,
  needShelter,
  needMedication,
  foundSurvivor,
}

/// Represents an emergency signal that propagates through the mesh
class EmergencySignal {
  final String id;
  final String senderId;
  final String senderName;
  final SignalType type;
  final EmergencyLevel level;
  final DateTime timestamp;
  final String message;
  final double? latitude;
  final double? longitude;
  final int hopCount; // How many devices this has traveled through
  final List<String> routePath; // Track the signal's journey
  final bool isActive; // Can be deactivated when help arrives
  final DateTime? resolvedAt;
  final String? resolvedBy;

  EmergencySignal({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.type,
    required this.level,
    required this.timestamp,
    required this.message,
    this.latitude,
    this.longitude,
    this.hopCount = 0,
    this.routePath = const [],
    this.isActive = true,
    this.resolvedAt,
    this.resolvedBy,
  });

  /// Get color for emergency level
  int getColorValue() {
    switch (level) {
      case EmergencyLevel.critical:
        return 0xFFFF0000; // Red
      case EmergencyLevel.high:
        return 0xFFFF6B00; // Orange
      case EmergencyLevel.medium:
        return 0xFFFFC107; // Amber
      case EmergencyLevel.low:
        return 0xFF4CAF50; // Green
    }
  }

  /// Get icon for signal type
  String getIconData() {
    switch (type) {
      case SignalType.sos:
        return '🆘';
      case SignalType.medical:
        return '🏥';
      case SignalType.trapped:
        return '🚧';
      case SignalType.danger:
        return '⚠️';
      case SignalType.safe:
        return '✅';
      case SignalType.needWater:
        return '💧';
      case SignalType.needFood:
        return '🍞';
      case SignalType.needShelter:
        return '🏠';
      case SignalType.needMedication:
        return '💊';
      case SignalType.foundSurvivor:
        return '👤';
    }
  }

  /// Get human-readable description
  String getDescription() {
    switch (type) {
      case SignalType.sos:
        return 'EMERGENCY - Need immediate help';
      case SignalType.medical:
        return 'Medical emergency';
      case SignalType.trapped:
        return 'Person trapped - need rescue';
      case SignalType.danger:
        return 'Immediate danger nearby';
      case SignalType.safe:
        return 'Safety check-in';
      case SignalType.needWater:
        return 'Need water urgently';
      case SignalType.needFood:
        return 'Need food';
      case SignalType.needShelter:
        return 'Need shelter';
      case SignalType.needMedication:
        return 'Need medication';
      case SignalType.foundSurvivor:
        return 'Survivor found';
    }
  }

  /// Calculate priority score for message routing (higher = more important)
  int getPriorityScore() {
    int score = 0;

    // Base score on emergency level
    switch (level) {
      case EmergencyLevel.critical:
        score += 1000;
        break;
      case EmergencyLevel.high:
        score += 750;
        break;
      case EmergencyLevel.medium:
        score += 500;
        break;
      case EmergencyLevel.low:
        score += 250;
        break;
    }

    // Boost for specific critical types
    if (type == SignalType.sos || type == SignalType.medical || type == SignalType.trapped) {
      score += 500;
    }

    // Reduce score as it hops (so fresh signals have priority)
    score -= hopCount * 10;

    // Time decay (older signals get lower priority)
    final ageInMinutes = DateTime.now().difference(timestamp).inMinutes;
    score -= ageInMinutes;

    return score.clamp(0, 2000);
  }

  /// Create a copy with updated hop count (for mesh propagation)
  EmergencySignal withHop(String deviceId) {
    return EmergencySignal(
      id: id,
      senderId: senderId,
      senderName: senderName,
      type: type,
      level: level,
      timestamp: timestamp,
      message: message,
      latitude: latitude,
      longitude: longitude,
      hopCount: hopCount + 1,
      routePath: [...routePath, deviceId],
      isActive: isActive,
      resolvedAt: resolvedAt,
      resolvedBy: resolvedBy,
    );
  }

  /// Mark signal as resolved
  EmergencySignal resolve(String responderId) {
    return EmergencySignal(
      id: id,
      senderId: senderId,
      senderName: senderName,
      type: type,
      level: level,
      timestamp: timestamp,
      message: message,
      latitude: latitude,
      longitude: longitude,
      hopCount: hopCount,
      routePath: routePath,
      isActive: false,
      resolvedAt: DateTime.now(),
      resolvedBy: responderId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'type': type.toString().split('.').last,
      'level': level.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'message': message,
      'latitude': latitude,
      'longitude': longitude,
      'hopCount': hopCount,
      'routePath': routePath,
      'isActive': isActive,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'resolvedBy': resolvedBy,
    };
  }

  factory EmergencySignal.fromJson(Map<String, dynamic> json) {
    return EmergencySignal(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      type: SignalType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      level: EmergencyLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['level'],
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      message: json['message'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      hopCount: json['hopCount'] as int? ?? 0,
      routePath: (json['routePath'] as List<dynamic>?)?.cast<String>() ?? [],
      isActive: json['isActive'] as bool? ?? true,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
      resolvedBy: json['resolvedBy'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencySignal &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
