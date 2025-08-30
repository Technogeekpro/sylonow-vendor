import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/private_theater.dart';
import '../models/theater_screen.dart';
import '../providers/theater_screens_provider.dart';
import '../service/theater_management_service.dart';
import 'add_edit_theater_screen.dart';
import 'time_slot_management_screen.dart';

class TheaterScreensManagement extends ConsumerStatefulWidget {
  final String theaterId;

  const TheaterScreensManagement({
    super.key,
    required this.theaterId,
  });

  @override
  ConsumerState<TheaterScreensManagement> createState() =>
      _TheaterScreensManagementState();
}

class _TheaterScreensManagementState
    extends ConsumerState<TheaterScreensManagement> {
  @override
  Widget build(BuildContext context) {
    final screensAsync = ref.watch(theaterScreensProvider(widget.theaterId));
    final theaterAsync = ref.watch(_theaterByIdProvider(widget.theaterId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: theaterAsync.when(
          data: (theater) => Text(
            theater?.name ?? 'Theater Screens',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          loading: () => const Text(
            'Theater Screens',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          error: (_, __) => const Text(
            'Theater Screens',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const HeroIcon(
              HeroIcons.plus,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => _navigateToAddScreen(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(theaterScreensProvider(widget.theaterId));
        },
        color: AppTheme.primaryColor,
        child: Column(
          children: [
            // Theater Info Header
            theaterAsync.when(
              data: (theater) => theater != null
                  ? _buildTheaterHeader(theater)
                  : const SizedBox.shrink(),
              loading: () => _buildTheaterHeaderSkeleton(),
              error: (_, __) => const SizedBox.shrink(),
            ),

            // Screens List
            Expanded(
              child: screensAsync.when(
                data: (screens) => _buildScreensList(context, screens),
                loading: () => _buildLoadingSkeleton(),
                error: (error, stack) =>
                    _buildErrorState(context, error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTheaterHeader(PrivateTheater theater) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.06).round()),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: theater.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          theater.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const HeroIcon(
                              HeroIcons.buildingOffice2,
                              color: AppTheme.primaryColor,
                              size: 28,
                              style: HeroIconStyle.solid,
                            );
                          },
                        ),
                      )
                    : const HeroIcon(
                        HeroIcons.buildingOffice2,
                        color: AppTheme.primaryColor,
                        size: 28,
                        style: HeroIconStyle.solid,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theater.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const HeroIcon(
                          HeroIcons.mapPin,
                          size: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${theater.city}, ${theater.state}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        
        ],
      ),
    );
  }

  Widget _buildStatChip(dynamic icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTheaterHeaderSkeleton() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 18,
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
    );
  }

  Widget _buildScreensList(BuildContext context, List<TheaterScreen> screens) {
    if (screens.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: screens.length,
      itemBuilder: (context, index) {
        return _buildScreenCard(context, screens[index]);
      },
    );
  }

  Widget _buildScreenCard(BuildContext context, TheaterScreen screen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.06).round()),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.accentTeal.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${screen.screenNumber}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentTeal,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      screen.screenName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: const HeroIcon(
                  HeroIcons.ellipsisVertical,
                  size: 20,
                  color: AppTheme.textSecondaryColor,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        HeroIcon(HeroIcons.pencil, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                    onTap: () => _navigateToEditScreen(context, screen),
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        HeroIcon(HeroIcons.trash,
                            size: 16, color: AppTheme.errorColor),
                        SizedBox(width: 8),
                        Text('Delete',
                            style: TextStyle(color: AppTheme.errorColor)),
                      ],
                    ),
                    onTap: () => _showDeleteScreenDialog(context, screen),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Screen Details
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (screen.totalCapacity > 0)
                _buildDetailChip(
                  HeroIcons.users,
                  '${screen.totalCapacity} Total',
                  AppTheme.primaryColor,
                ),
              if (screen.allowedCapacity > 0)
                _buildDetailChip(
                  HeroIcons.userGroup,
                  '${screen.allowedCapacity} Allowed',
                  AppTheme.accentTeal,
                ),
              if (screen.originalHourlyPrice > 0)
                _buildDetailChip(
                  HeroIcons.banknotes,
                  '₹${screen.originalHourlyPrice.toInt()}/hr',
                  AppTheme.accentBlue,
                ),
              if (screen.discountedHourlyPrice > 0 &&
                  screen.discountedHourlyPrice < screen.originalHourlyPrice)
                _buildDetailChip(
                  HeroIcons.tag,
                  'Sale: ₹${screen.discountedHourlyPrice.toInt()}/hr',
                  AppTheme.successColor,
                ),
            ],
          ),

          if (screen.amenities.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: screen.amenities.take(3).map((feature) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor.withAlpha((255 * 0.1).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    feature,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          // Time Slot Management Button
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _navigateToTimeSlots(context, screen),
              icon: const HeroIcon(HeroIcons.clock, size: 18),
              label: const Text('Manage Time Slots'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(dynamic icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.accentTeal.withAlpha((255 * 0.1).round()),
                shape: BoxShape.circle,
              ),
              child: const HeroIcon(
                HeroIcons.tv,
                size: 60,
                color: AppTheme.accentTeal,
                style: HeroIconStyle.solid,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Screens Added Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add screens to start managing time slots and bookings',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddScreen(context),
              icon: const HeroIcon(HeroIcons.plus, size: 20),
              label: const Text('Add Screen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                          height: 13,
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HeroIcon(
              HeroIcons.exclamationTriangle,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load screens',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.invalidate(theaterScreensProvider(widget.theaterId));
              },
              icon: const HeroIcon(HeroIcons.arrowPath, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddScreen(BuildContext context) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => AddEditTheaterScreen(
          theaterId: widget.theaterId,
        ),
      ),
    )
        .then((_) {
      // Refresh the screens list when returning
      ref.invalidate(theaterScreensProvider(widget.theaterId));
    });
  }

  void _navigateToEditScreen(BuildContext context, TheaterScreen screen) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => AddEditTheaterScreen(
          theaterId: widget.theaterId,
          existingScreen: screen,
        ),
      ),
    )
        .then((_) {
      // Refresh the screens list when returning
      ref.invalidate(theaterScreensProvider(widget.theaterId));
    });
  }

  void _showDeleteScreenDialog(BuildContext context, TheaterScreen screen) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Delete Screen'),
        content: Text(
            'Are you sure you want to delete "${screen.screenName}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref
                    .read(theaterManagementServiceProvider)
                    .deleteTheaterScreen(screen.id);
                ref.invalidate(theaterScreensProvider(widget.theaterId));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Screen deleted successfully'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete screen: $e'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _navigateToTimeSlots(BuildContext context, TheaterScreen screen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TimeSlotManagementScreen(
          screenId: screen.id,
          screenName: screen.screenName,
          theaterId: widget.theaterId,
        ),
      ),
    );
  }
}

// Provider for getting theater by ID
final _theaterByIdProvider =
    FutureProvider.family<PrivateTheater?, String>((ref, theaterId) {
  return ref.watch(theaterManagementServiceProvider).getTheaterById(theaterId);
});
