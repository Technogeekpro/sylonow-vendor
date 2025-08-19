import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:sylonow_vendor/features/addons/screens/addons_list_screen.dart';
import '../../../core/theme/app_theme.dart';
import '../models/private_theater.dart';
import '../providers/vendor_theaters_provider.dart';
import '../providers/theater_screens_provider.dart';

class VendorTheatersScreen extends ConsumerWidget {
  const VendorTheatersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theatersAsync = ref.watch(vendorTheatersProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Theaters',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
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
            onPressed: () => _handleAddTheater(context, ref),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(vendorTheatersProvider);
        },
        color: AppTheme.secondaryColor,
        child: theatersAsync.when(
          data: (theaters) => _buildTheatersList(context, theaters),
          loading: () => _buildLoadingSkeleton(),
          error: (error, stack) => _buildErrorState(context, error.toString()),
        ),
      ),
    );
  }

  Widget _buildTheatersList(BuildContext context, List<PrivateTheater> theaters) {
    if (theaters.isEmpty) {
      return Consumer(
        builder: (context, ref, _) => _buildEmptyState(context, ref),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: theaters.length,
      itemBuilder: (context, index) {
        return _buildTheaterCard(context, theaters[index]);
      },
    );
  }

  Widget _buildTheaterCard(BuildContext context, PrivateTheater theater) {
    final isVerified = theater.approvalStatus.toLowerCase() == 'approved';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16), 
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isVerified ? () => context.push('/theater/${theater.id}/screens') : null,
          borderRadius: BorderRadius.circular(20),
          child: ColorFiltered(
            colorFilter: isVerified 
                ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                : const ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, 0, // Red channel
                    0.2126, 0.7152, 0.0722, 0, 0, // Green channel  
                    0.2126, 0.7152, 0.0722, 0, 0, // Blue channel
                    0, 0, 0, 1, 0, // Alpha channel
                  ]),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isVerified ? Colors.white : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isVerified ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ] : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
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
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
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
                                    size: 32,
                                    style: HeroIconStyle.solid,
                                  );
                                },
                              ),
                            )
                          : const HeroIcon(
                              HeroIcons.buildingOffice2,
                              color: AppTheme.primaryColor,
                              size: 32,
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                              Expanded(
                                child: Text(
                                  '${theater.city}, ${theater.state}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondaryColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(theater.approvalStatus).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getStatusText(theater.approvalStatus),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(theater.approvalStatus),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Stats Row
                Consumer(
                  builder: (context, ref, child) {
                    final screensAsync = ref.watch(theaterScreensProvider(theater.id));
                    return screensAsync.when(
                      data: (screens) {
                        final rate = screens.isNotEmpty
                            ? screens
                                .map((s) => s.discountedHourlyPrice)
                                .reduce((a, b) => a < b ? a : b)
                            : 0;
                        return Row(
                          children: [
                            _buildStatItem(
                              HeroIcons.currencyRupee,
                              'Starts From',
                              '₹${rate.toInt()}/hr',
                              AppTheme.successColor,
                            ),
                            const SizedBox(width: 24),
                            _buildStatItem(
                              HeroIcons.tv,
                              'Screens',
                              '${screens.length}',
                              AppTheme.accentTeal,
                            ),
                          ],
                        );
                      },
                      loading: () => Row(
                        children: [
                          _buildStatItem(
                            HeroIcons.currencyRupee,
                            'Starts From',
                            '₹-',
                            AppTheme.successColor,
                          ),
                          const SizedBox(width: 24),
                          _buildStatItem(
                            HeroIcons.tv,
                            'Screens',
                            '-',
                            AppTheme.accentTeal,
                          ),
                        ],
                      ),
                      error: (e, s) => Row(
                        children: [
                          _buildStatItem(
                            HeroIcons.currencyRupee,
                            'Starts From',
                            'Error',
                            AppTheme.errorColor,
                          ),
                          const SizedBox(width: 24),
                          _buildStatItem(
                            HeroIcons.tv,
                            'Screens',
                            '!',
                            AppTheme.errorColor,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                if (theater.amenities.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: theater.amenities.take(3).map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.borderColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          amenity,
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
                
                const SizedBox(height: 16),
                
                // Action Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isVerified ? () => _navigateToAddons(context) : null,
                        icon: HeroIcon(HeroIcons.plus, size: 16, color: isVerified ? null : Colors.grey),
                        label: const Text('Add-ons'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isVerified ? Theme.of(context).primaryColor : Colors.grey,
                          side: BorderSide(
                            color: isVerified ? Theme.of(context).primaryColor.withValues(alpha: 0.8) : Colors.grey.withValues(alpha: 0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isVerified ? () => context.push('/theater/${theater.id}/screens') : null,
                        icon: HeroIcon(HeroIcons.tv, size: 16, color: isVerified ? Colors.white : Colors.grey),
                        label: const Text('Screens'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isVerified ? Theme.of(context).primaryColor : Colors.grey.shade300,
                          foregroundColor: isVerified ? Colors.white : Colors.grey,
                          elevation: isVerified ? 0 : 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Non-verified message
                if (!isVerified) ...[ 
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200, width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.orange.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pending admin approval. Theater will be active once verified.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(HeroIcons icon, String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: HeroIcon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
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
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const HeroIcon(
                HeroIcons.buildingOffice2,
                size: 60,
                color: AppTheme.primaryColor,
                style: HeroIconStyle.solid,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Theaters Added Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first theater to start managing bookings and screens',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _handleAddTheater(context, ref),
              icon: const HeroIcon(HeroIcons.plus, size: 20),
              label: const Text('Add Theater'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
      padding: const EdgeInsets.all(16),
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
                    width: 64,
                    height: 64,
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
              'Failed to load theaters',
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
              onPressed: () => context.pop(),
              icon: const HeroIcon(HeroIcons.arrowLeft, size: 16),
              label: const Text('Go Back'),
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

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
      case 'active':
        return AppTheme.successColor;
      case 'pending':
        return AppTheme.warningColor;
      case 'rejected':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }

  void _navigateToAddons(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddonsListScreen(),
      ),
    );
  }

  String _getStatusText(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'pending':
        return 'Pending';
      case 'rejected':
        return 'Rejected';
      case 'active':
        return 'Active';
      default:
        return 'Unknown';
    }
  }

  void _handleAddTheater(BuildContext context, WidgetRef ref) {
    final theatersAsync = ref.read(vendorTheatersProvider);
    
    theatersAsync.whenData((theaters) {
      if (theaters.isNotEmpty) {
        _showContactSupportDialog(context);
      } else {
        context.push('/simple-add-theater');
      }
    });
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Multiple Theaters Not Allowed',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        content: const Text(
          'Currently, vendors are limited to one theater. To add additional theaters, please contact SyloNow support for assistance.',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/support');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Contact Support',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}