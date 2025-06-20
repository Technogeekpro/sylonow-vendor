import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sylonow_vendor/features/dashboard/models/booking.dart';
import 'package:sylonow_vendor/features/dashboard/models/dashboard_data.dart';
import 'package:sylonow_vendor/features/dashboard/models/dashboard_stats.dart';
import 'package:sylonow_vendor/features/dashboard/models/activity_item.dart';
import 'package:sylonow_vendor/features/dashboard/providers/dashboard_provider.dart';
import 'package:sylonow_vendor/features/onboarding/models/vendor.dart';
import '../../../core/theme/app_theme.dart';
import '../../onboarding/providers/vendor_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
    _setStatusBarColor();
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
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Business Overview - Four Cards
                          _buildBusinessOverview(dashboardData.stats),
                          
                          const SizedBox(height: 20),
                          
                          // New Booking Alert
                          _buildNewBookingAlert(dashboardData.latestPendingBooking),
                          
                          const SizedBox(height: 20),
                          
                          // Recent Activity
                          _buildRecentActivity(dashboardData.recentActivities),
                          
                          // Bottom padding for navigation bar
                          SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $err'),
              ElevatedButton(
                onPressed: () => ref.invalidate(dashboardDataProvider),
                child: const Text('Retry'),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Future<void> _handleRefresh() async {
    try {
      print('🔄 Refreshing home screen data...');
      
      // Show haptic feedback
      HapticFeedback.lightImpact();
      
      // Refresh both vendor data and dashboard data
      await Future.wait([
        ref.read(vendorProvider.notifier).refreshVendor(),
        Future(() => ref.invalidate(dashboardDataProvider)),
      ]);
      
      print('🟢 Home screen refresh completed');
    } catch (e) {
      print('🔴 Home screen refresh failed: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _buildHeader(AsyncValue vendorAsync) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 15, 20, 16),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
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
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        vendor?.fullName ?? 'Vendor Partner',
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
                              Icons.badge_outlined,
                              color: Colors.white.withOpacity(0.7),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              vendor!.vendorId!,
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 6,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
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
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  vendor?.serviceArea ?? 'Service Area',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
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
            color: Colors.white.withOpacity(0.3),
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
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 18,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
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
          Icons.person_rounded,
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
                'Vendor Partner',
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
    // Debug information for home screen
    print('🔍 Home Header Profile Image Debug:');
    print('🔍 Vendor ID: ${vendor.id}');
    print('🔍 Profile Picture URL: ${vendor.profilePicture}');
    print('🔍 Profile Picture null? ${vendor.profilePicture == null}');
    print('🔍 Profile Picture empty? ${vendor.profilePicture?.isEmpty ?? true}');

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

  Widget _buildBusinessOverview(DashboardStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        // Gross Sales
        _buildOverviewCard(
          icon: Icons.trending_up_rounded,
          label: 'Gross Sales',
          value: '₹${stats.grossSales.toStringAsFixed(0)}',
          color: AppTheme.successColor,
        ),
        // Earnings
        _buildOverviewCard(
          icon: Icons.account_balance_wallet_rounded,
          label: 'Earnings',
          value: '₹${stats.grossSales.toStringAsFixed(0)}', // Assuming earnings are same as gross for now
          color: AppTheme.accentPink,
        ),
        // Service Listings
        _buildOverviewCard(
          icon: Icons.list_alt_rounded,
          label: 'Service Listings',
          value: stats.serviceListingsCount.toString(),
          color: AppTheme.accentBlue,
        ),
        // Total Orders
        _buildOverviewCard(
          icon: Icons.shopping_bag_rounded,
          label: 'Total Orders',
          value: stats.totalOrdersCount.toString(),
          color: AppTheme.accentTeal,
        ),
      ],
    );
  }

  Widget _buildOverviewCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    bool isServiceListings = label == 'Service Listings';
    
    return GestureDetector(
      onTap: isServiceListings ? () {
        context.push('/service-listings');
      } : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
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
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isServiceListings)
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: color,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewBookingAlert(Booking? booking) {
    if (booking == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: const Center(
          child: Text(
            'No new bookings right now.',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondaryColor,
            ),
          ),
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
                    onPressed: () {
                      // TODO: Implement accept booking functionality
                    },
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
                    onPressed: () {
                      // TODO: Implement view booking details functionality
                    },
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

  Widget _buildRecentActivity(List<dynamic> recentActivities) {
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

  Widget _buildActivityItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String status,
  }) {
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
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
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
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => context.push('/add-service'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });

            switch (index) {
              case 1:
                context.push('/orders');
                break;
              case 2:
                context.push('/wallet');
                break;
              case 3:
                context.push('/support');
                break;
              case 4:
                context.push('/profile');
                break;
              default:
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.surfaceColor,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textSecondaryColor,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_rounded),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.support_agent_rounded),
              label: 'Support',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
