import 'package:bacterialboom_client/bacterialboom_client.dart';
import 'package:flutter/material.dart';

/// Shows the connection state of a streaming connection.
class ConnectionDisplay extends StatelessWidget {
  final Widget child;
  final StreamingConnectionHandlerState connectionState;

  const ConnectionDisplay({
    required this.child,
    required this.connectionState,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String connectionStateDescription;
    Color connectionStateColor;
    Icon connectionStateIcon;
    switch (connectionState.status) {
      case StreamingConnectionStatus.connected:
        connectionStateDescription = 'Connected';
        connectionStateColor = Colors.green.shade900;
        connectionStateIcon = const Icon(
          Icons.check,
          weight: 700,
          color: Colors.white,
          size: 16,
        );
        break;
      case StreamingConnectionStatus.connecting:
        connectionStateDescription = 'Connecting';
        connectionStateColor = Colors.orange.shade900;
        connectionStateIcon = const Icon(
          Icons.change_circle_outlined,
          color: Colors.white,
          size: 16,
          weight: 500,
        );
        break;
      case StreamingConnectionStatus.disconnected:
        connectionStateDescription = 'Disconnected';
        connectionStateColor = Colors.red.shade900;
        connectionStateIcon = const Icon(
          Icons.cancel_outlined,
          color: Colors.white,
          size: 16,
          weight: 500,
        );
        break;
      case StreamingConnectionStatus.waitingToRetry:
        connectionStateDescription =
            'Retrying ${connectionState.retryInSeconds}';
        connectionStateColor = Colors.orange.shade900;
        connectionStateIcon = const Icon(
          Icons.change_circle_outlined,
          color: Colors.white,
          size: 16,
          weight: 500,
        );
        break;
    }

    return Stack(
      children: [
        child,
        Positioned(
          left: 16,
          top: 16,
          child: Container(
            width: 140,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: connectionStateColor.withOpacity(0.5),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: Colors.black54, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                connectionStateIcon,
                const SizedBox(width: 4),
                Text(
                  connectionStateDescription,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
