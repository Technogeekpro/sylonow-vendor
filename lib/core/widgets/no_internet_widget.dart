import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_theme.dart';
import '../providers/connectivity_provider.dart';

class NoInternetWidget extends ConsumerStatefulWidget {
  final Widget child;
  
  const NoInternetWidget({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<NoInternetWidget> createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends ConsumerState<NoInternetWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectivityAsync = ref.watch(currentConnectivityProvider);

    return connectivityAsync.when(
      data: (isConnected) {
        if (isConnected) {
          _animationController.reverse();
          return widget.child;
        } else {
          _animationController.forward();
          return Stack(
            children: [
              // Blur the background content
              widget.child,
              // Overlay with no internet message
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Container(
                    color: Colors.black.withOpacity(0.8 * _fadeAnimation.value),
                    child: child,
                  );
                },
                child: Center(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: _NoInternetContent(),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
      loading: () => widget.child, // Show content while checking connectivity
      error: (_, __) => widget.child, // Show content if connectivity check fails
    );
  }
}

class _NoInternetContent extends ConsumerStatefulWidget {
  @override
  ConsumerState<_NoInternetContent> createState() => _NoInternetContentState();
}

class _NoInternetContentState extends ConsumerState<_NoInternetContent> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated icon or Lottie animation
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.wifi_off_rounded,
              size: 60,
              color: AppTheme.errorColor,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            'Oops! No Internet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 12),
          
          // Description
          Text(
            'It looks like you\'re not connected to the internet. Please check your connection and try again.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondaryColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Tips section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.infoColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.infoColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: AppTheme.infoColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Quick Tips:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.infoColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTip('Check your WiFi or mobile data'),
                _buildTip('Move to an area with better signal'),
                _buildTip('Restart your router if using WiFi'),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Open system settings
                    // Note: This would require additional permissions and platform-specific code
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Settings'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isRetrying ? null : _retryConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isRetrying
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Try Again',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: AppTheme.infoColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _retryConnection() async {
    if (_isRetrying) return;
    
    setState(() {
      _isRetrying = true;
    });

    try {
      // Wait a moment for user feedback
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Refresh connectivity status
      await ref.read(currentConnectivityProvider.notifier).refresh();
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }
}