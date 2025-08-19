import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/theater_booking.dart';
import '../providers/theater_booking_provider.dart';
import '../../onboarding/providers/vendor_provider.dart';

class TheaterBookingsScreen extends ConsumerStatefulWidget {
  const TheaterBookingsScreen({super.key});

  @override
  ConsumerState<TheaterBookingsScreen> createState() =>
      _TheaterBookingsScreenState();
}

class _TheaterBookingsScreenState extends ConsumerState<TheaterBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> _tabs = [
    'All',
    'Today',
    'Upcoming',
    'Confirmed',
    'Cancelled',
    'Completed'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingStatsAsync = ref.watch(bookingStatsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : const Text(
                'Theater Bookings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: HeroIcon(
              _isSearching ? HeroIcons.xMark : HeroIcons.magnifyingGlass,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const HeroIcon(
              HeroIcons.funnel,
              size: 20,
            ),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // Collapsible Stats Overview
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: bookingStatsAsync.when(
                  data: (stats) => _buildStatsCards(stats),
                  loading: () => _buildStatsLoading(),
                  error: (error, stack) => _buildStatsError(),
                ),
              ),
            ),
            // Persistent Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: AppTheme.primaryColor,
                  indicatorWeight: 3,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: AppTheme.textSecondaryColor,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAllBookingsTab(),
            _buildTodayBookingsTab(),
            _buildUpcomingBookingsTab(),
            _buildFilteredBookingsTab('confirmed'),
            _buildFilteredBookingsTab('cancelled'),
            _buildFilteredBookingsTab('completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Search bookings...',
        hintStyle: TextStyle(color: Colors.white70),
        border: InputBorder.none,
      ),
      onChanged: (query) {
        if (query.trim().isNotEmpty) {
          ref.read(searchedBookingsProvider(query).notifier).search(query);
        }
      },
    );
  }

  Widget _buildStatsCards(Map<String, dynamic> stats) {
    return Column(
      children: [
        // First row of stats
        Row(
          children: [
            _buildStatCard(
              'Total',
              '${stats['total_bookings'] ?? 0}',
              HeroIcons.calendar,
              AppTheme.primaryColor,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'Gross Sales',
              '₹${_formatNumber(stats['gross_sales']?.toDouble() ?? 0.0)}',
              HeroIcons.banknotes,
              AppTheme.successColor,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'Earnings',
              '₹${_formatNumber(stats['total_revenue']?.toDouble() ?? 0.0)}',
              HeroIcons.currencyRupee,
              Colors.green.shade600,
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row of stats
        Row(
          children: [
            _buildStatCard(
              'Today',
              '${stats['today_bookings'] ?? 0}',
              HeroIcons.clock,
              AppTheme.warningColor,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'This Month',
              '₹${_formatNumber(stats['this_month_revenue']?.toDouble() ?? 0.0)}',
              HeroIcons.chartBarSquare,
              Colors.blue.shade600,
            ),
            const SizedBox(width: 12),
            _buildStatCard(
              'Pending',
              '${stats['pending_payments'] ?? 0}',
              HeroIcons.exclamationTriangle,
              AppTheme.errorColor,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, HeroIcons icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          children: [
          //  HeroIcon(icon, size: 20, color: AppTheme.primaryColor),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsLoading() { 
    return Column( 
      children: [
        // First row loading
        Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderColor),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Second row loading
        Row(
          children: List.generate(
            3,
            (index) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsError() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Failed to load booking statistics',
        style: TextStyle(
          color: AppTheme.errorColor,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAllBookingsTab() {
    final bookingsAsync = ref.watch(vendorBookingsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(vendorBookingsProvider.future),
      child: bookingsAsync.when(
        data: (bookings) => _buildBookingsList(bookings),
        loading: () => _buildBookingsLoading(),
        error: (error, stack) => _buildBookingsError(error),
      ),
    );
  }

  Widget _buildTodayBookingsTab() {
    final todayBookingsAsync = ref.watch(todayBookingsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(todayBookingsProvider.future),
      child: todayBookingsAsync.when(
        data: (bookings) => _buildBookingsList(bookings),
        loading: () => _buildBookingsLoading(),
        error: (error, stack) => _buildBookingsError(error),
      ),
    );
  }

  Widget _buildUpcomingBookingsTab() {
    final upcomingBookingsAsync = ref.watch(upcomingBookingsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(upcomingBookingsProvider.future),
      child: upcomingBookingsAsync.when(
        data: (bookings) => _buildBookingsList(bookings),
        loading: () => _buildBookingsLoading(),
        error: (error, stack) => _buildBookingsError(error),
      ),
    );
  }

  Widget _buildFilteredBookingsTab(String status) {
    final filteredBookingsAsync = ref.watch(filteredBookingsProvider(status));

    return RefreshIndicator(
      onRefresh: () => ref.refresh(filteredBookingsProvider(status).future),
      child: filteredBookingsAsync.when(
        data: (bookings) => _buildBookingsList(bookings),
        loading: () => _buildBookingsLoading(),
        error: (error, stack) => _buildBookingsError(error),
      ),
    );
  }

  Widget _buildBookingsList(List<TheaterBooking> bookings) {
    if (bookings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(TheaterBooking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.04).round()),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/theater-booking-detail/${booking.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.contactName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${booking.theaterName ?? 'Theater'} - ${booking.screenName ?? 'Screen ${booking.screenNumber}'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(booking.bookingStatus),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildBookingInfo(
                  HeroIcons.calendar,
                  _formatDateWithDay(booking.bookingDate),
                ),
                const SizedBox(width: 16),
                _buildBookingInfo(
                  HeroIcons.clock,
                  '${_formatTimeTo12Hour(booking.startTime)} - ${_formatTimeTo12Hour(booking.endTime)}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildBookingInfo(
              HeroIcons.users,
              '${booking.numberOfPeople} people',
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${_formatNumber(booking.totalAmount)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Row(
                  children: [
                    _buildPaymentStatusChip(booking.paymentStatus),
                    const SizedBox(width: 8),
                    const HeroIcon(
                      HeroIcons.chevronRight,
                      size: 16,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingInfo(HeroIcons icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroIcon(
          icon,
          size: 16,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = AppTheme.successColor;
        break;
      case 'cancelled':
        color = AppTheme.errorColor;
        break;
      case 'completed':
        color = AppTheme.primaryColor;
        break;
      case 'no_show':
        color = AppTheme.warningColor;
        break;
      default:
        color = AppTheme.textSecondaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPaymentStatusChip(String paymentStatus) {
    Color color;
    switch (paymentStatus.toLowerCase()) {
      case 'paid':
        color = AppTheme.successColor;
        break;
      case 'pending':
        color = AppTheme.warningColor;
        break;
      case 'failed':
        color = AppTheme.errorColor;
        break;
      case 'refunded':
        color = AppTheme.textSecondaryColor;
        break;
      default:
        color = AppTheme.textSecondaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withAlpha((255 * 0.3).round())),
      ),
      child: Text(
        paymentStatus.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBookingsLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
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
                width: 200,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 120,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingsError(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HeroIcon(
            HeroIcons.exclamationTriangle,
            size: 48,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load bookings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error?.toString() ?? 'Unknown error occurred',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(vendorBookingsProvider),
            icon: const HeroIcon(HeroIcons.arrowPath, size: 16),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeroIcon(
            HeroIcons.calendar,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'No bookings found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Bookings will appear here when customers\nbook your theaters',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Bookings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            // Add filter options here
            Text('Filter options coming soon...'),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDate = DateTime(date.year, date.month, date.day);

    if (bookingDate == today) {
      return 'Today';
    } else if (bookingDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatDateWithDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDate = DateTime(date.year, date.month, date.day);

    List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    String dayOfWeek = weekdays[date.weekday - 1];

    if (bookingDate == today) {
      return 'Today';
    } else if (bookingDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return '$dayOfWeek, ${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTimeTo12Hour(String time24) {
    try {
      final parts = time24.split(':');
      if (parts.length < 2) return time24;

      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      // Ignore seconds if present (parts[2])

      String period = hour >= 12 ? 'PM' : 'AM';
      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour = hour - 12;
      }

      return '${hour.toString()}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time24;
    }
  }

  String _formatNumber(double number) {
    if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }
}

// Custom delegate for the persistent tab bar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
