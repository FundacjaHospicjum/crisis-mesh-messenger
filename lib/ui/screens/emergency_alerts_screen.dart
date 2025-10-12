import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/emergency_signal.dart';
import '../../core/services/emergency_service.dart';
import 'package:intl/intl.dart';

/// Screen showing all emergency signals in the network
class EmergencyAlertsScreen extends StatelessWidget {
  const EmergencyAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Emergency Alerts'),
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.warning), text: 'Active'),
              Tab(icon: Icon(Icons.check_circle), text: 'Resolved'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ActiveSignalsTab(),
            _ResolvedSignalsTab(),
          ],
        ),
      ),
    );
  }
}

class _ActiveSignalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyService>(
      builder: (context, emergencyService, child) {
        final signals = emergencyService.activeSignals;

        if (signals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.green.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No Active Emergencies',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'All clear in your area',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          );
        }

        // Group by emergency level
        final critical = signals.where((s) => s.level == EmergencyLevel.critical).toList();
        final high = signals.where((s) => s.level == EmergencyLevel.high).toList();
        final medium = signals.where((s) => s.level == EmergencyLevel.medium).toList();
        final low = signals.where((s) => s.level == EmergencyLevel.low).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Stats header
            _buildStatsCard(context, emergencyService),
            const SizedBox(height: 16),

            // Critical signals
            if (critical.isNotEmpty) ...[
              _buildSectionHeader(context, 'Critical', critical.length, Colors.red),
              ...critical.map((signal) => _buildSignalCard(context, signal)),
              const SizedBox(height: 16),
            ],

            // High priority
            if (high.isNotEmpty) ...[
              _buildSectionHeader(context, 'High Priority', high.length, Colors.orange),
              ...high.map((signal) => _buildSignalCard(context, signal)),
              const SizedBox(height: 16),
            ],

            // Medium priority
            if (medium.isNotEmpty) ...[
              _buildSectionHeader(context, 'Medium Priority', medium.length, Colors.amber),
              ...medium.map((signal) => _buildSignalCard(context, signal)),
              const SizedBox(height: 16),
            ],

            // Low priority
            if (low.isNotEmpty) ...[
              _buildSectionHeader(context, 'Low Priority', low.length, Colors.green),
              ...low.map((signal) => _buildSignalCard(context, signal)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStatsCard(BuildContext context, EmergencyService service) {
    final stats = service.getStatistics();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  '${stats['activeSignals']}',
                  'Active',
                  Colors.red,
                  Icons.warning,
                ),
                _buildStatItem(
                  context,
                  '${stats['criticalSignals']}',
                  'Critical',
                  Colors.red.shade900,
                  Icons.priority_high,
                ),
                _buildStatItem(
                  context,
                  '${stats['resolvedSignals']}',
                  'Resolved',
                  Colors.green,
                  Icons.check_circle,
                ),
              ],
            ),
            if (stats['criticalSignals']! > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Critical emergencies require immediate attention',
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    int count,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$title ($count)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalCard(BuildContext context, EmergencySignal signal) {
    final color = Color(signal.getColorValue());
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.3), width: 2),
      ),
      child: InkWell(
        onTap: () => _showSignalDetails(context, signal),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        signal.getIconData(),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          signal.getDescription(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'From: ${signal.senderName}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      signal.level.toString().split('.').last.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                signal.message,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(signal.timestamp),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.share, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${signal.hopCount} hops',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.priority_high, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Priority: ${signal.getPriorityScore()}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignalDetails(BuildContext context, EmergencySignal signal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SignalDetailsSheet(signal: signal),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    }
  }
}

class _ResolvedSignalsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EmergencyService>(
      builder: (context, emergencyService, child) {
        final signals = emergencyService.resolvedSignals;

        if (signals.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text('No Resolved Signals'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: signals.length,
          itemBuilder: (context, index) {
            final signal = signals[index];
            return _buildResolvedCard(context, signal);
          },
        );
      },
    );
  }

  Widget _buildResolvedCard(BuildContext context, EmergencySignal signal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              signal.getIconData(),
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(signal.getDescription()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('From: ${signal.senderName}'),
            Text('Resolved by: ${signal.resolvedBy ?? "Unknown"}'),
          ],
        ),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}

class _SignalDetailsSheet extends StatelessWidget {
  final EmergencySignal signal;

  const _SignalDetailsSheet({required this.signal});

  @override
  Widget build(BuildContext context) {
    final color = Color(signal.getColorValue());
    
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Header
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        signal.getIconData(),
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          signal.getDescription(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            signal.level.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              
              // Details
              _buildDetailRow(Icons.person, 'From', signal.senderName),
              _buildDetailRow(Icons.message, 'Message', signal.message),
              _buildDetailRow(Icons.access_time, 'Time', 
                DateFormat('MMM d, yyyy HH:mm:ss').format(signal.timestamp)),
              _buildDetailRow(Icons.share, 'Network Hops', '${signal.hopCount}'),
              _buildDetailRow(Icons.priority_high, 'Priority Score', 
                '${signal.getPriorityScore()}'),
              
              if (signal.routePath.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Signal Path',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...signal.routePath.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '${entry.key + 1}.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.device_hub, size: 16),
                        const SizedBox(width: 8),
                        Text(entry.value),
                      ],
                    ),
                  );
                }),
              ],
              
              const SizedBox(height: 24),
              
              // Actions
              if (signal.isActive) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<EmergencyService>().resolveSignal(
                          signal.id,
                          'current_user', // TODO: Get actual user ID
                        );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Mark as Resolved'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Open chat with sender
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.message),
                  label: const Text('Contact Sender'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
