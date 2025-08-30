import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import '../../../core/theme/app_theme.dart';
import '../../onboarding/models/vendor.dart';
import '../../onboarding/providers/vendor_provider.dart';
import '../../onboarding/providers/service_area_provider.dart';
import '../../../core/services/firebase_analytics_service.dart';
import '../providers/dashboard_provider.dart';
import '../providers/theater_booking_provider.dart';
import '../widgets/stats_grid.dart';
import '../widgets/action_cards.dart';
import '../widgets/orders_section.dart';
import '../models/dashboard_order.dart';
import '../models/dashboard_stats.dart' as ds;

class TheaterDashboardScreen extends ConsumerStatefulWidget {
  const TheaterDashboardScreen({super.key});

  @override
  ConsumerState<TheaterDashboardScreen> createState() =>
      _TheaterDashboardScreenState();
}

class _TheaterDashboardScreenState
    extends ConsumerState<TheaterDashboardScreen> {
  int _selectedIndex = 0;
  late ValueNotifier<bool> _onlineStatusController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _onlineStatusController = ValueNotifier<bool>(false);
    _selectedIndex = 0; // Always reset to home when screen initializes
    _setStatusBarColor();

    // Track screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAnalyticsService()
          .logScreenView(screenName: 'theater_dashboard_screen');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset navigation to home whenever this screen is active
    if (_selectedIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _onlineStatusController.dispose();
    super.dispose();
  }

  void _setStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vendorAsync = ref.watch(vendorProvider);
    final primaryServiceAreaAsync = ref.watch(primaryServiceAreaProvider);
    final bookingStatsAsync = ref.watch(bookingStatsProvider);
    final pendingOrdersAsync = ref.watch(pendingOrdersProvider);
    final upcomingOrdersAsync = ref.watch(upcomingOrdersProvider);
    final hasTheatersAsync = ref.watch(vendorHasTheatersProvider);

    // Initialize controller with vendor data only once
    vendorAsync.whenData((vendor) {
      if (vendor != null && !_isInitialized) {
        final vendorOnlineStatus = vendor.isOnline == true;
        _onlineStatusController.value = vendorOnlineStatus;
        _isInitialized = true;
        print(
            '🟢 Initialized online status controller with: $vendorOnlineStatus');
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Header
          _buildHeader(vendorAsync, primaryServiceAreaAsync),

          // Main Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppTheme.primaryColor,
              backgroundColor: AppTheme.surfaceColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(_getResponsivePadding(context), 24,
                    _getResponsivePadding(context), 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Grid (2x2 responsive)
                    bookingStatsAsync.when(
                      data: (stats) => StatsGrid(
                        stats: _convertBookingStatsToGridStats(stats),
                        isLoading: false,
                      ),
                      loading: () => const StatsGrid(
                        stats: null,
                        isLoading: true,
                      ),
                      error: (error, stack) => const StatsGrid(
                        stats: null,
                        isLoading: false,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Action Cards
                    hasTheatersAsync.when(
                      data: (hasTheaters) =>
                          ActionCards(hasTheaters: hasTheaters),
                      loading: () => const ActionCards(hasTheaters: false),
                      error: (error, stack) =>
                          const ActionCards(hasTheaters: false),
                    ),

                    const SizedBox(height: 8),

                    // Additional Action Cards
                    hasTheatersAsync.when(
                      data: (hasTheaters) =>
                          _buildAdditionalActionCards(hasTheaters),
                      loading: () => _buildAdditionalActionCards(false),
                      error: (error, stack) =>
                          _buildAdditionalActionCards(false),
                    ),

                    const SizedBox(height: 32),

                    // Orders Section
                    pendingOrdersAsync.when(
                      data: (orders) => OrdersSection(
                        orders: orders,
                        isLoading: false,
                      ),
                      loading: () => const OrdersSection(
                        orders: [],
                        isLoading: true,
                      ),
                      error: (error, stack) => const OrdersSection(
                        orders: [],
                        isLoading: false,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Upcoming Orders List
                    upcomingOrdersAsync.when(
                      data: (orders) => _buildUpcomingOrders(orders),
                      loading: () => _buildUpcomingOrdersSkeleton(),
                      error: (error, stack) => _buildUpcomingOrders([]),
                    ),

                    // Bottom padding for navigation bar
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  ds.DashboardStats _convertBookingStatsToGridStats(
      Map<String, dynamic> bookingStats) {
    return ds.DashboardStats(
      vendorId: '', // Not needed for display
      grossSales: bookingStats['gross_sales']?.toDouble() ?? 0.0,
      totalEarnings: bookingStats['total_revenue']?.toDouble() ?? 0.0,
      totalOrders: bookingStats['total_bookings'] ?? 0,
      totalTheaters: bookingStats['total_theaters'] ?? 0,
      activeTheaters: bookingStats['total_theaters'] ?? 0,
      pendingOrders: bookingStats['pending_payments'] ?? 0,
      completedOrders: bookingStats['completed_bookings'] ?? 0,
      monthlyEarnings: bookingStats['this_month_revenue']?.toDouble() ?? 0.0,
      ordersThisWeek: 0, // Not available in booking stats
      ordersToday: bookingStats['today_bookings'] ?? 0,
    );
  }

  Widget _buildAdditionalActionCards(bool hasTheaters) {
    return Row(
      children: [
        // Add Extra Service Card - Always visible
        Expanded(
          child: _buildActionCard(
            title: 'Add Extra Service',
            subtitle: 'Boost revenue with add-ons',
            icon: Icons.add_circle_outline_rounded,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
            onTap: () => context.push('/addons'),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              offset: const Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    try {
      if (kDebugMode) {
        print('🔄 Refreshing dashboard data...');
      }

      // Track refresh action
      FirebaseAnalyticsService().logFeatureUsed(
        featureName: 'pull_to_refresh',
        screenName: 'theater_dashboard_screen',
      );

      // Show haptic feedback
      HapticFeedback.lightImpact();

      // Refresh all providers
      await Future.wait([
        ref.read(bookingStatsProvider.notifier).refresh(),
        ref.read(pendingOrdersProvider.notifier).refresh(),
        ref.read(upcomingOrdersProvider.notifier).refresh(),
        ref.read(vendorHasTheatersProvider.notifier).refresh(),
      ]);

      if (kDebugMode) {
        print('🟢 Dashboard refresh completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴 Dashboard refresh failed: $e');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _toggleOnlineStatus(
      WidgetRef ref, Vendor? vendor, bool newStatus) async {
    if (vendor == null) return;

    print(
        '🔄 Toggling online status from ${_onlineStatusController.value} to $newStatus');

    // Optimistically update the UI immediately
    _onlineStatusController.value = newStatus;
    print('🔵 Controller value set to: ${_onlineStatusController.value}');

    try {
      // Show haptic feedback
      HapticFeedback.lightImpact();

      // Update the vendor online status in database
      final vendorService = ref.read(vendorServiceProvider);
      final success =
          await vendorService.updateVendorOnlineStatus(vendor.id!, newStatus);

      if (!success) {
        throw Exception('Failed to update online status in database');
      }

      print('🟢 Database update successful');

      // Update the vendor provider state to keep it in sync
      ref.read(vendorProvider.notifier).updateOnlineStatus(newStatus);

      // Track the status change
      FirebaseAnalyticsService().logFeatureUsed(
        featureName: 'toggle_online_status',
        screenName: 'theater_dashboard_screen',
        additionalParams: {'new_status': newStatus.toString()},
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus
                  ? 'You are now online and available for orders'
                  : 'You are now offline',
            ),
            backgroundColor:
                newStatus ? AppTheme.successColor : AppTheme.warningColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('🔴 Error during toggle: $e, reverting UI state');
      // Revert the optimistic update on error
      _onlineStatusController.value = !newStatus;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating status: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildHeader(
      AsyncValue vendorAsync, AsyncValue primaryServiceAreaAsync) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 15, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: vendorAsync.when(
        data: (vendor) => Column(
          children: [
            Row(
              children: [
                // Profile Picture
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [AppTheme.cardShadow],
                  ),
                  child: ClipOval(
                    child: _buildHeaderProfileImage(vendor),
                  ),
                ),
                const SizedBox(width: 16),

                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: 14,
                          // ignore: deprecated_member_use
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vendor?.fullName ?? 'Theater Owner',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (vendor?.vendorId != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.theaters_rounded,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              ' ${vendor!.vendorId!}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Status & Notifications
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: _onlineStatusController,
                            builder: (context, isOnline, child) {
                              return Icon(
                                Icons.circle,
                                size: 8,
                                color: isOnline
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Colors.red,
                              );
                            },
                          ),
                          const SizedBox(width: 4),
                          ValueListenableBuilder<bool>(
                            valueListenable: _onlineStatusController,
                            builder: (context, isOnline, child) {
                              return AdvancedSwitch(
                                key: ValueKey(
                                    isOnline), // Force rebuild on value change
                                initialValue: isOnline,
                                activeChild: const Text(
                                  'Online',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                inactiveChild: const Text(
                                  'Offline',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                activeColor: Colors.green,
                                inactiveColor: Colors.grey,
                                width: 80.0,
                                height: 32.0,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                onChanged: (value) =>
                                    _toggleOnlineStatus(ref, vendor, value),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => context.push('/notifications'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const HeroIcon(
                          HeroIcons.bell,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Location
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: primaryServiceAreaAsync.when(
                    data: (serviceArea) {
                      String locationText = 'Theater Location';
                      if (serviceArea != null) {
                        final parts = <String>[];
                        if (serviceArea.areaName.isNotEmpty) {
                          parts.add(serviceArea.areaName);
                        }
                        if (serviceArea.city != null &&
                            serviceArea.city!.isNotEmpty) {
                          parts.add(serviceArea.city!);
                        }
                        if (serviceArea.state != null &&
                            serviceArea.state!.isNotEmpty) {
                          parts.add(serviceArea.state!);
                        }
                        locationText = parts.isEmpty
                            ? 'Theater Location'
                            : parts.join(', ');
                      }
                      return Text(
                        locationText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                    loading: () => Text(
                      'Loading location...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    error: (error, stack) => Text(
                      'Theater Location',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        loading: () => _buildHeaderSkeleton(),
        error: (error, stack) => _buildHeaderError(),
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 14,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 18,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderError() {
    return const Row(
      children: [
        Icon(
          Icons.theaters_rounded,
          color: Colors.white,
          size: 28,
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                'Theater Owner',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderProfileImage(Vendor vendor) {
    if (vendor.profilePicture != null && vendor.profilePicture!.isNotEmpty) {
      return Image.network(
        vendor.profilePicture!,
        fit: BoxFit.cover,
        width: 56,
        height: 56,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white.withValues(alpha: 0.8),
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.theaters_rounded,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          );
        },
      );
    } else {
      return Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.theaters_rounded,
          color: AppTheme.primaryColor,
          size: 28,
        ),
      );
    }
  }

  Widget _buildUpcomingOrders(List<DashboardOrder> orders) {
    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/orders'),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...orders.map((order) => _buildUpcomingOrderCard(order)),
      ],
    );
  }

  Widget _buildUpcomingOrderCard(DashboardOrder order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_seat_rounded,
              color: AppTheme.successColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.serviceTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  order.customerName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatBookingDate(order.bookingDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(order.totalAmount),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              if (order.daysUntilBooking != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'in ${order.daysUntilBooking}d',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.successColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingOrdersSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 140,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          2,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }

  String _formatBookingDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  // Helper method for responsive padding
  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1200) {
      return 32.0; // Desktop
    } else if (screenWidth >= 600) {
      return 24.0; // Tablet
    } else {
      return 16.0; // Mobile
    }
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 32,
            offset: const Offset(0, -8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                icon: HeroIcons.home,
                label: 'Home',
                index: 0,
                isSelected: _selectedIndex == 0,
                onTap: () => _handleNavTap(0),
              ),
              _buildNavItem(
                icon: HeroIcons.shoppingBag,
                label: 'Orders',
                index: 1,
                isSelected: _selectedIndex == 1,
                onTap: () => _handleNavTap(1, '/theater-bookings'),
              ),
              _buildNavItem(
                icon: HeroIcons.lifebuoy,
                label: 'Support',
                index: 2,
                isSelected: _selectedIndex == 2,
                onTap: () => _handleNavTap(2, '/support'),
              ),
              _buildNavItem(
                icon: HeroIcons.user,
                label: 'Profile',
                index: 3,
                isSelected: _selectedIndex == 3,
                onTap: () => _handleNavTap(3, '/profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required HeroIcons icon,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with Material 3 style indicator
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: isSelected ? 64 : 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: isSelected ? 1.1 : 1.0,
                        child: HeroIcon(
                          icon,
                          size: 24,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : AppTheme.textSecondaryColor,
                          style: isSelected
                              ? HeroIconStyle.solid
                              : HeroIconStyle.outline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Label with animation
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: isSelected ? 12 : 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : AppTheme.textSecondaryColor,
                  height: 1.2,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavTap(int index, [String? route]) {
    if (route != null) {
      // For navigation to other screens, don't update state
      // The state will be reset when user returns
      context.push(route);
    } else if (_selectedIndex != index) {
      // Only update state if staying on current screen (Home)
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
