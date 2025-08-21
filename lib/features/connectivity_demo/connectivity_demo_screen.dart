import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/connectivity_provider.dart';
import '../../core/theme/app_theme.dart';

class ConnectivityDemoScreen extends ConsumerWidget {
  const ConnectivityDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(currentConnectivityProvider);
    final connectivityStream = ref.watch(connectivityStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Demo'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    connectivityAsync.when(
                      data: (isConnected) => _StatusIndicator(
                        isConnected: isConnected,
                        label: isConnected ? 'Connected' : 'Disconnected',
                      ),
                      loading: () => const _StatusIndicator(
                        isConnected: null,
                        label: 'Checking...',
                      ),
                      error: (_, __) => const _StatusIndicator(
                        isConnected: false,
                        label: 'Error checking connectivity',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Real-time Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Real-time Status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    connectivityStream.when(
                      data: (isConnected) => _StatusIndicator(
                        isConnected: isConnected,
                        label: isConnected ? 'Online' : 'Offline',
                        showPulse: true,
                      ),
                      loading: () => const _StatusIndicator(
                        isConnected: null,
                        label: 'Monitoring...',
                      ),
                      error: (_, __) => const _StatusIndicator(
                        isConnected: false,
                        label: 'Stream error',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Test Actions
            Text(
              'Test Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () {
                ref.refresh(currentConnectivityProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Status'),
            ),

            const SizedBox(height: 8),

            OutlinedButton.icon(
              onPressed: () async {
                final status = await ref
                    .read(connectivityStatusProvider.notifier)
                    .getStatusString();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Status: $status')),
                  );
                }
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Get Detailed Status'),
            ),

            const Spacer(),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.infoColor.withOpacity(0.3),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Test:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.infoColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Turn off WiFi/Mobile data to see offline state\n'
                    '2. Turn on airplane mode\n'
                    '3. Connect to WiFi without internet\n'
                    '4. The app will show overlay when offline',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatefulWidget {
  final bool? isConnected;
  final String label;
  final bool showPulse;

  const _StatusIndicator({
    required this.isConnected,
    required this.label,
    this.showPulse = false,
  });

  @override
  State<_StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<_StatusIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.showPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    if (widget.isConnected == null) {
      color = Colors.orange;
      icon = Icons.help_outline;
    } else if (widget.isConnected!) {
      color = AppTheme.successColor;
      icon = Icons.wifi;
    } else {
      color = AppTheme.errorColor;
      icon = Icons.wifi_off;
    }

    Widget indicator = Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );

    if (widget.showPulse && widget.isConnected != null) {
      indicator = AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      );
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 12),
        indicator,
        const SizedBox(width: 12),
        Text(
          widget.label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
