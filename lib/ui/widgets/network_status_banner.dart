import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/mesh_network_service.dart';

/// Banner showing current network status
class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final meshService = context.watch<MeshNetworkService>();
    final peerCount = meshService.peers.length;
    final onlineCount = meshService.onlinePeers.length;

    Color backgroundColor;
    Color textColor;
    IconData icon;
    String message;

    if (onlineCount > 0) {
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[900]!;
      icon = Icons.wifi;
      message = '$onlineCount device${onlineCount != 1 ? 's' : ''} connected';
    } else if (peerCount > 0) {
      backgroundColor = Colors.orange[100]!;
      textColor = Colors.orange[900]!;
      icon = Icons.wifi_tethering;
      message = '$peerCount device${peerCount != 1 ? 's' : ''} nearby';
    } else {
      backgroundColor = Colors.grey[200]!;
      textColor = Colors.grey[800]!;
      icon = Icons.wifi_off;
      message = 'No devices found';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: textColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          if (meshService.isScanning)
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(textColor),
              ),
            ),
        ],
      ),
    );
  }
}
