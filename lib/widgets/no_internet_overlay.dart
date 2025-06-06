import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/connectivity_provider.dart';

class NoInternetOverlay extends StatelessWidget {
  final Widget child;
  const NoInternetOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, _) {
        return Stack(
          children: [
            child,
            if (!connectivity.isOnline)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.wifi_off,
// <<<<<<< tti6jg-codex/add-no-internet-message-with-retry-button
//                           size: 80, color: Theme.of(context).colorScheme.onBackground),
// =======
//                           size: 80,
//                           color: Theme.of(context).colorScheme.onSurface),
// >>>>>>> main
                      const SizedBox(height: 16),
                      Text('No Internet Connection',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: connectivity.retry,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
