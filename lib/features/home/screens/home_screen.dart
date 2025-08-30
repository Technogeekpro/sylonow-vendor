import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:sylonow_vendor/features/dashboard/models/booking.dart';
import 'package:sylonow_vendor/features/dashboard/models/dashboard_stats.dart';
import 'package:sylonow_vendor/features/dashboard/models/activity_item.dart';
import 'package:sylonow_vendor/features/dashboard/providers/dashboard_provider.dart';
import 'package:sylonow_vendor/features/dashboard/services/booking_service.dart';
import 'package:sylonow_vendor/features/onboarding/service/vendor_service.dart'
    as vendor_service;

import 'package:sylonow_vendor/features/onboarding/models/vendor.dart';
import '../../../core/theme/app_theme.dart';
import '../../onboarding/providers/vendor_provider.dart';
import '../../../core/services/firebase_analytics_service.dart';
import '../../service_addon/widgets/service_addon_summary_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  bool _isOnline = false;
  bool _isToggling = false; // Prevent sync during toggle operations
  int _selectedIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0; // Always reset to home when screen initializes
    _setupAnimations();
    _startAnimations();
    _setStatusBarColor();

    // Track screen view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAnalyticsService().logScreenView(screenName: 'home_screen');
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

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
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
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String _getRelativeTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorAsync = ref.watch(vendorProvider);
    final dashboardDataAsync = ref.watch(dashboardDataProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigation(),
      body: dashboardDataAsync.when(
        data: (dashboardData) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Minimalistic Header
                _buildHeader(vendorAsync),

                // Main Content - Flexible and Scrollable with Pull-to-Refresh
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    color: AppTheme.primaryColor,
                    backgroundColor: AppTheme.surfaceColor,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                          16, 16, 16, 80), // Added padding
                      child: Column(
                        children: [
                          _buildStatsGrid(dashboardData.stats),
                          const SizedBox(height: 24),
                          const ServiceAddonSummaryCard(),
                          const SizedBox(height: 24),
                          _buildNewBookingCard(
                              dashboardData.latestPendingBooking),
                          const SizedBox(height: 24),
                          _buildRecentActivity(dashboardData.recentActivities),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => Column(
          children: [
            _buildHeader(vendorAsync),
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ],
        ),
        error: (error, stack) => Column(
          children: [
            _buildHeader(vendorAsync),
            Expanded(
              child: Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    ref.invalidate(vendorProvider);
    ref.invalidate(dashboardDataProvider);
    await Future.delayed(const Duration(seconds: 1));
  }

  Widget _buildHeader(AsyncValue vendorAsync) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 15, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: vendorAsync.when(
        data: (vendor) {
          // Initialize local state on first load if not set
          if (!_isToggling && _isOnline != vendor.isOnline) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_isToggling) {
                setState(() {
                  _isOnline = vendor.isOnline;
                });
              }
            });
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vendor.fullName ?? 'Vendor Partner',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (vendor.vendorId != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.badge_outlined,
                                color: Colors.white.withOpacity(0.7),
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                vendor.vendorId!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.7),
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
                  Column(
                    children: [
                      Transform.scale(
                        scale: 0.8, // Make the switch a bit smaller
                        child: Switch(
                          value: _isToggling ? _isOnline : vendor.isOnline,
                          onChanged: (value) {
                            _toggleOnlineStatus(vendor, value);
                          },
                          activeTrackColor:
                              AppTheme.successColor.withOpacity(0.5),
                          inactiveTrackColor: Colors.black.withOpacity(0.2),
                          activeColor: Colors.white,
                          inactiveThumbColor: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/notifications'),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
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
                  HeroIcon(
                    HeroIcons.map,
                    color: Colors.white.withOpacity(0.8),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      vendor.serviceArea ?? 'Location not set',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => _buildHeaderSkeleton(),
        error: (error, stack) => _buildHeaderError(),
      ),
    );
  }

  Widget _buildHeaderSkeleton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const CircleAvatar(radius: 28, backgroundColor: Colors.white24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 14, width: 100, color: Colors.white24),
                  const SizedBox(height: 6),
                  Container(height: 18, width: 150, color: Colors.white24),
                  const SizedBox(height: 6),
                  Container(height: 12, width: 80, color: Colors.white24),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.location_on_rounded,
                color: Colors.white24, size: 16),
            const SizedBox(width: 8),
            Container(height: 14, width: 200, color: Colors.white24),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderError() {
    return const Center(
      child: Text(
        'Failed to load vendor data.',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildHeaderProfileImage(Vendor vendor) {
    // Debug information for home screen
    print('🔍 Home Header Profile Image Debug:');
    print('🔍 Vendor ID: ${vendor.id ?? 'null'}');
    print('🔍 Profile Picture URL: ${vendor.profilePicture}');
    print('🔍 Profile Picture null? ${vendor.profilePicture == null}');
    print(
        '🔍 Profile Picture empty? ${vendor.profilePicture?.isEmpty ?? true}');

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
              color: Colors.white.withOpacity(0.8),
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('🔴 Home header profile picture loading error: $error');
          print('🔴 Image URL: ${vendor.profilePicture}');
          print('🔴 Stack trace: $stackTrace');
          return Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_rounded,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 6,
                    color: AppTheme.primaryColor.withOpacity(0.7),
                  ),
                ),
              ],
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
          color: AppTheme.primaryColor.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.person_rounded,
          color: AppTheme.primaryColor,
          size: 28,
        ),
      );
    }
  }

  Widget _buildStatsGrid(DashboardStats stats) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    double childAspectRatio = 0.95;

    if (screenWidth >= 1200) {
      crossAxisCount = 4;
      childAspectRatio = 1.3;
    } else if (screenWidth >= 600) {
      crossAxisCount = 2;
      childAspectRatio = 1.4;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: childAspectRatio,
      children: [
        _HomeStatCard(
          path: 'assets/animations/growth.json',
          label: 'Gross Sales',
          value: _formatCurrency(stats.grossSales),
          color: AppTheme.successColor,
          isLoading: false,
          onTap: null, // Non-clickable
        ),
        _HomeStatCard(
          path: 'assets/animations/earning.json',
          label: 'Earnings',
          value: _formatCurrency(
              stats.grossSales), // Assuming earnings are same as gross for now
          color: AppTheme.primaryColor,
          isLoading: false,
          onTap: null, // Non-clickable
        ),
        _HomeStatCard(
          path: 'assets/animations/orders.json',
          label: 'Total Orders',
          value: '${stats.totalOrdersCount}',
          color: AppTheme.accentBlue,
          isLoading: false,
          onTap: (context) => context.push('/orders'),
        ),
        _HomeStatCard(
          path: 'assets/animations/service.json',
          label: 'Service Listings',
          value: '${stats.serviceListingsCount}',
          color: AppTheme.accentTeal,
          isLoading: false,
          onTap: (context) => context.push('/service-listings'),
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

  Widget _buildNewBookingCard(Booking? booking) {
    if (booking == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade50,
              Colors.grey.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.borderColor.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.schedule_rounded,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Looking for new bookings...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'We\'ll notify you as soon as a customer books your service. Keep your notifications enabled!',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Notifications Active',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                booking.serviceTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'NEW', // Placeholder for timer
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('E, MMM d - h:mm a').format(booking.bookingDate),
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${booking.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  // Accept Button
                  ElevatedButton(
                    onPressed: () => _acceptBooking(booking),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Accept',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                  // View Button
                  OutlinedButton(
                    onPressed: () => _viewBookingDetails(booking),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('View',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(List<ActivityItem> recentActivities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        if (recentActivities.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: const Center(
              child: Text(
                'No recent activity found.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ),
          )
        else
          ...recentActivities.take(3).map((activity) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildDynamicActivityItem(activity),
              )),
      ],
    );
  }

  Widget _buildDynamicActivityItem(ActivityItem activity) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activity.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              activity.icon,
              color: activity.iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${activity.subtitle} • ${_getRelativeTime(activity.timestamp)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (activity.status != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: activity.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                activity.displayStatus,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: activity.iconColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        print('🔵 Add Service button pressed');
        context.push('/add-service');
      },
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      child: const HeroIcon(HeroIcons.plusCircle),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
                onTap: () => _handleNavTap(1, '/orders'),
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

  // Accept booking functionality
  Future<void> _acceptBooking(Booking booking) async {
    try {
      print('🔄 Accepting booking: ${booking.id}');
      print('🔍 Full booking data: ${booking.toJson()}');

      // Show loading state
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(width: 16),
                const Text('Accepting booking...'),
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      final success = await _bookingService.acceptBooking(booking.id);

      if (success) {
        if (mounted) {
          // Clear any existing snackbars
          ScaffoldMessenger.of(context).clearSnackBars();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Booking Accepted Successfully! 🎉',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Customer will be notified. Looking for next booking...',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.successColor,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          // Refresh the dashboard data to update the UI and clear the accepted booking
          ref.invalidate(dashboardDataProvider);
        }
      } else {
        if (mounted) {
          // Clear any existing snackbars
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Failed to accept booking. Please try again.'),
                ],
              ),
              backgroundColor: AppTheme.errorColor,
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error accepting booking: $e');
      if (mounted) {
        // Clear any existing snackbars
        ScaffoldMessenger.of(context).clearSnackBars();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                      'Error accepting booking: ${e.toString().length > 50 ? '${e.toString().substring(0, 50)}...' : e}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // View booking details functionality
  void _viewBookingDetails(Booking booking) {
    print('🔍 Navigating to booking details: ${booking.id}');
    print('🔍 Navigation path: /booking-details/${booking.id}');

    if (booking.id.isEmpty) {
      print('❌ Booking ID is empty, cannot navigate');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Booking ID is missing'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Use Uri.encodeComponent to properly encode the booking ID for URL
      final encodedBookingId = Uri.encodeComponent(booking.id);
      final navigationPath = '/booking-details/$encodedBookingId';

      print('🔍 Encoded navigation path: $navigationPath');

      context.push(navigationPath).then((result) {
        // If the booking was accepted or declined, refresh the data
        if (result == true) {
          ref.invalidate(dashboardDataProvider);
        }
      }).catchError((error) {
        print('❌ Navigation error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigation failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } catch (e) {
      print('❌ Error preparing navigation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleOnlineStatus(Vendor vendor, bool newStatus) async {
    if (vendor.id == null) return;

    // Set toggling flag and optimistic state
    setState(() {
      _isToggling = true;
      _isOnline = newStatus; // Show immediate feedback
    });

    try {
      // Update on server
      await ref
          .read(vendor_service.vendorServiceProvider)
          .updateVendorOnlineStatus(vendor.id!, newStatus);

      // Refresh provider data
      ref.invalidate(vendorProvider);

      // Give a moment for provider to update, then clear toggling flag
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) {
        setState(() {
          _isToggling = false;
        });
      }
    } catch (e) {
      // On error, clear toggling flag and let switch show server state
      if (mounted) {
        setState(() {
          _isToggling = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: $e')),
        );
      }
    }
  }
}

class _HomeStatCard extends StatelessWidget {
  final String path;
  final String label;
  final String value;
  final Color color;
  final bool isLoading;
  final void Function(BuildContext)? onTap;

  const _HomeStatCard({
    required this.path,
    required this.label,
    required this.value,
    required this.color,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Lottie.asset(
              path,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (isLoading)
                  Container(
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                else
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap!(context),
          borderRadius: BorderRadius.circular(16),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
