import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/notification.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _setStatusBarColor();
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await ref.read(notificationListProvider.notifier).refresh();
    await ref.read(unreadCountProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationListProvider);
    final unreadCountAsync = ref.watch(unreadCountProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Custom App Bar with gradient
          _buildCustomAppBar(context, unreadCountAsync),

          // Tab Bar
          _buildTabBar(),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllNotifications(notificationsAsync),
                _buildNotificationsByType('booking'),
                _buildNotificationsByType('payment'),
                _buildNotificationsByType('system'),
                _buildNotificationsByType('promotion'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(
      BuildContext context, AsyncValue<int> unreadCountAsync) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 8, 16, 16),
      decoration: BoxDecoration(
        gradient: AppTheme.secondaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header Row
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              const Expanded(
                child: Text(
                  'Notifications',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) async {
                  switch (value) {
                    case 'mark_all_read':
                      await ref
                          .read(notificationListProvider.notifier)
                          .markAllAsRead();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('All notifications marked as read')),
                      );
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'mark_all_read',
                    child: Text('Mark all as read'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                'Total',
                ref.watch(notificationListProvider).when(
                      data: (notifications) => notifications.length.toString(),
                      loading: () => '...',
                      error: (_, __) => '0',
                    ),
                const HeroIcon(HeroIcons.bell, color: Colors.white, size: 20),
              ),
              _buildStatCard(
                'Unread',
                unreadCountAsync.when(
                  data: (count) => count.toString(),
                  loading: () => '...',
                  error: (_, __) => '0',
                ),
                const HeroIcon(HeroIcons.bell, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, HeroIcon icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            icon,
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AppTheme.secondaryColor, width: 3),
          insets: EdgeInsets.symmetric(horizontal: 16),
        ),
        labelColor: AppTheme.secondaryColor,
        unselectedLabelColor: AppTheme.textSecondaryColor,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Bookings'),
          Tab(text: 'Payments'),
          Tab(text: 'System'),
          Tab(text: 'Promotions'),
        ],
      ),
    );
  }

  Widget _buildAllNotifications(
      AsyncValue<List<VendorNotification>> notificationsAsync) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.primaryColor,
      child: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationCard(notification);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildNotificationsByType(String type) {
    return Consumer(
      builder: (context, ref, child) {
        final notificationsAsync = ref.watch(notificationsByTypeProvider(type));

        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(notificationsByTypeProvider(type).notifier)
                .refresh();
          },
          color: AppTheme.primaryColor,
          child: notificationsAsync.when(
            data: (notifications) {
              if (notifications.isEmpty) {
                return _buildEmptyState(type: type);
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return _buildNotificationCard(notification);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(error.toString()),
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(VendorNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (direction) {
        ref
            .read(notificationListProvider.notifier)
            .deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${notification.title} deleted')),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppTheme.surfaceColor
              : AppTheme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead
                ? AppTheme.borderColor
                : AppTheme.primaryColor.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: notification.isRead
              ? []
              : [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: InkWell(
          onTap: () {
            if (!notification.isRead) {
              ref
                  .read(notificationListProvider.notifier)
                  .markAsRead(notification.id);
            }
            // Handle notification tap action here
            _handleNotificationTap(notification);
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Type Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getTypeIcon(notification.type),
                      color: _getTypeColor(notification.type),
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: notification.isRead
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                  color: AppTheme.textPrimaryColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                            fontWeight: notification.isRead
                                ? FontWeight.w400
                                : FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Bottom Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(notification.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      notification.type.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getTypeColor(notification.type),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Text(
                    notification.relativeTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState({String? type}) {
    final message =
        type != null ? 'No $type notifications yet' : 'No notifications yet';

    final description = type != null
        ? 'You\'ll see $type related notifications here'
        : 'You\'ll see all your notifications here once you receive them';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                type != null ? _getTypeIcon(type) : Icons.notifications_rounded,
                color: AppTheme.primaryColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppTheme.errorColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Error: $error',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleRefresh,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.calendar_today_rounded;
      case 'payment':
        return Icons.payment_rounded;
      case 'system':
        return Icons.settings_rounded;
      case 'promotion':
        return Icons.local_offer_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'booking':
        return AppTheme.successColor;
      case 'payment':
        return AppTheme.accentPink;
      case 'system':
        return AppTheme.accentBlue;
      case 'promotion':
        return AppTheme.accentTeal;
      default:
        return AppTheme.primaryColor;
    }
  }

  void _handleNotificationTap(VendorNotification notification) {
    // Handle different notification types
    switch (notification.type) {
      case 'booking':
        // Navigate to booking details or orders screen
        context.push('/orders');
        break;
      case 'payment':
        // Navigate to wallet screen
        context.push('/wallet');
        break;
      case 'system':
        // Show system notification details or navigate to settings
        break;
      case 'promotion':
        // Handle promotion tap (maybe show offer details)
        break;
      default:
        break;
    }
  }
}
