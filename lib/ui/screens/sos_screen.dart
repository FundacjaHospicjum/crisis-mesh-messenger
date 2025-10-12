import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/emergency_signal.dart';
import '../../core/services/emergency_service.dart';
import '../../core/services/mesh_network_service.dart';

/// Emergency SOS screen with one-tap distress signal
class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  SignalType? _selectedType;
  bool _isSending = false;
  EmergencySignal? _lastSignal;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _sendSOS(BuildContext context) async {
    if (_selectedType == null || _isSending) return;

    setState(() => _isSending = true);

    try {
      final emergencyService = context.read<EmergencyService>();
      final meshService = context.read<MeshNetworkService>();

      // Get device info
      final deviceId = meshService.localPeer.id;
      final deviceName = meshService.localPeer.name;

      // Determine emergency level based on type
      EmergencyLevel level;
      switch (_selectedType!) {
        case SignalType.sos:
        case SignalType.medical:
        case SignalType.trapped:
        case SignalType.danger:
          level = EmergencyLevel.critical;
          break;
        case SignalType.needWater:
        case SignalType.needFood:
        case SignalType.needMedication:
          level = EmergencyLevel.high;
          break;
        default:
          level = EmergencyLevel.medium;
      }

      // Broadcast emergency
      final signal = await emergencyService.broadcastEmergency(
        senderId: deviceId,
        senderName: deviceName,
        type: _selectedType!,
        level: level,
        message: _getMessageForType(_selectedType!),
      );

      setState(() {
        _lastSignal = signal;
        _isSending = false;
      });

      if (mounted) {
        _showSuccessDialog(context);
      }
    } catch (e) {
      setState(() => _isSending = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send SOS: $e')),
        );
      }
    }
  }

  String _getMessageForType(SignalType type) {
    switch (type) {
      case SignalType.sos:
        return 'EMERGENCY - Need immediate help!';
      case SignalType.medical:
        return 'Medical emergency - Need medical assistance';
      case SignalType.trapped:
        return 'Trapped - Need rescue';
      case SignalType.danger:
        return 'In immediate danger';
      case SignalType.needWater:
        return 'Need water urgently';
      case SignalType.needFood:
        return 'Need food';
      case SignalType.needShelter:
        return 'Need shelter';
      case SignalType.needMedication:
        return 'Need medication';
      case SignalType.safe:
        return 'I am safe - Status check-in';
      case SignalType.foundSurvivor:
        return 'Found survivor - Need assistance';
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 64),
        title: const Text('SOS Sent!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your emergency signal is broadcasting to all nearby devices',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Keep your device on to continue broadcasting',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade700,
              Colors.red.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_pulseController.value * 0.1),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5 * _pulseController.value),
                                  blurRadius: 40 * _pulseController.value,
                                  spreadRadius: 20 * _pulseController.value,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.warning_rounded,
                              size: 64,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Emergency Signal',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select emergency type and send signal',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Emergency type selector
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: _isSending
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Broadcasting emergency signal...'),
                            ],
                          ),
                        )
                      : _lastSignal != null
                          ? _buildActiveSignal()
                          : _buildTypeSelector(theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'What kind of help do you need?',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Critical emergencies
          _buildSectionHeader('Critical - Immediate Help'),
          _buildEmergencyButton(
            type: SignalType.sos,
            icon: '🆘',
            title: 'SOS - General Emergency',
            description: 'Need immediate help',
            color: Colors.red,
          ),
          _buildEmergencyButton(
            type: SignalType.medical,
            icon: '🏥',
            title: 'Medical Emergency',
            description: 'Need medical assistance',
            color: Colors.red,
          ),
          _buildEmergencyButton(
            type: SignalType.trapped,
            icon: '🚧',
            title: 'Trapped',
            description: 'Physically trapped, need rescue',
            color: Colors.red,
          ),
          _buildEmergencyButton(
            type: SignalType.danger,
            icon: '⚠️',
            title: 'Immediate Danger',
            description: 'In danger right now',
            color: Colors.red,
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Need Resources'),
          _buildEmergencyButton(
            type: SignalType.needWater,
            icon: '💧',
            title: 'Need Water',
            description: 'Urgent need for water',
            color: Colors.orange,
          ),
          _buildEmergencyButton(
            type: SignalType.needFood,
            icon: '🍞',
            title: 'Need Food',
            description: 'Need food supplies',
            color: Colors.orange,
          ),
          _buildEmergencyButton(
            type: SignalType.needMedication,
            icon: '💊',
            title: 'Need Medication',
            description: 'Need medical supplies',
            color: Colors.orange,
          ),
          _buildEmergencyButton(
            type: SignalType.needShelter,
            icon: '🏠',
            title: 'Need Shelter',
            description: 'Need safe place to stay',
            color: Colors.orange,
          ),

          const SizedBox(height: 24),
          _buildSectionHeader('Status Updates'),
          _buildEmergencyButton(
            type: SignalType.safe,
            icon: '✅',
            title: 'I\'m Safe',
            description: 'Check-in - Everything OK',
            color: Colors.green,
          ),
          _buildEmergencyButton(
            type: SignalType.foundSurvivor,
            icon: '👤',
            title: 'Found Survivor',
            description: 'Located person needing help',
            color: Colors.blue,
          ),

          const SizedBox(height: 32),
          
          // Send button
          if (_selectedType != null)
            ElevatedButton(
              onPressed: () => _sendSOS(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
              ),
              child: const Text(
                'SEND SOS SIGNAL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildEmergencyButton({
    required SignalType type,
    required String icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final isSelected = _selectedType == type;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => setState(() => _selectedType = type),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? color : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: color, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveSignal() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.broadcast_on_personal,
            size: 80,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          const Text(
            'SOS Signal Active',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Broadcasting: ${_lastSignal!.getDescription()}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Signal sent ${_formatTimestamp(_lastSignal!.timestamp)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                const Icon(Icons.info_outline, color: Colors.green),
                const SizedBox(height: 8),
                const Text(
                  'Your signal is being relayed through the mesh network',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Keep your device on and nearby devices will help relay your message',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _lastSignal = null;
                _selectedType = null;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Send Another Signal'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return '${difference.inHours} hours ago';
    }
  }
}
