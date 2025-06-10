import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/service_listing_provider.dart';
import '../models/service_listing.dart';

class ServiceListingsScreen extends ConsumerStatefulWidget {
  const ServiceListingsScreen({super.key});

  @override
  ConsumerState<ServiceListingsScreen> createState() => _ServiceListingsScreenState();
}

class _ServiceListingsScreenState extends ConsumerState<ServiceListingsScreen> {
  @override
  Widget build(BuildContext context) {
    final serviceListingsAsync = ref.watch(serviceListingsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Service Listings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(serviceListingsProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: serviceListingsAsync.when(
        data: (listings) => _buildListingsView(listings),
        loading: () => _buildLoadingView(),
        error: (error, stack) => _buildErrorView(error),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-service'),
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Service',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildListingsView(List<ServiceListing> listings) {
    if (listings.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(serviceListingsProvider.notifier).refresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listings.length,
        itemBuilder: (context, index) {
          final listing = listings[index];
          return _buildListingCard(listing);
        },
      ),
    );
  }

  Widget _buildListingCard(ServiceListing listing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Cover Photo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: listing.coverPhoto != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            listing.coverPhoto!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPhotoPlaceholder(),
                          ),
                        )
                      : _buildPhotoPlaceholder(),
                ),
                const SizedBox(width: 12),
                
                // Title and Category
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          listing.category,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status Toggle Switch
                _buildStatusToggle(listing),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Price Row
            Row(
              children: [
                Text(
                  '₹${listing.offerPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                if (listing.originalPrice > listing.offerPrice)
                  Text(
                    '₹${listing.originalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                const Spacer(),
                if (listing.promotionalTag?.isNotEmpty == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.warningColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      listing.promotionalTag!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warningColor,
                      ),
                    ),
                  ),
              ],
            ),

            // Theme Tags Row
            if (listing.themeTags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: listing.themeTags.take(3).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.accentPurple.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.accentPurple,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 8),

            // Service Environment Tags
            if (listing.serviceEnvironment.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: listing.serviceEnvironment.map((env) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.accentBlue.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          env == 'indoor' ? Icons.home_rounded : Icons.nature_rounded,
                          size: 12,
                          color: AppTheme.accentBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          env.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.accentBlue,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            
            const SizedBox(height: 12),
            
            // Footer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Created Date
                Text(
                  listing.createdAt != null
                      ? 'Created ${_formatDate(listing.createdAt!)}'
                      : 'Recently created',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                
                // Status Indicator (Disabled Edit Button)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_off_rounded,
                        size: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Edit Disabled',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return const Icon(
      Icons.image_outlined,
      size: 30,
      color: AppTheme.primaryColor,
    );
  }

  Widget _buildStatusToggle(ServiceListing listing) {
    return Column(
      children: [
        // Status Label
        Text(
          listing.isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: listing.isActive ? AppTheme.successColor : AppTheme.errorColor,
          ),
        ),
        const SizedBox(height: 4),
        // Toggle Switch
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: listing.isActive,
            onChanged: (value) => _toggleListingStatus(listing, value),
            activeColor: AppTheme.successColor,
            inactiveThumbColor: AppTheme.errorColor,
            inactiveTrackColor: AppTheme.errorColor.withOpacity(0.3),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Future<void> _toggleListingStatus(ServiceListing listing, bool newStatus) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Updating status...'),
            ],
          ),
          backgroundColor: AppTheme.primaryColor,
          duration: Duration(seconds: 1),
        ),
      );

      // Toggle status via provider
      await ref.read(serviceListingsProvider.notifier).toggleListingStatus(
        listing.id,
        newStatus,
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status updated to ${newStatus ? 'Active' : 'Inactive'}',
                ),
              ],
            ),
            backgroundColor: AppTheme.successColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('🔴 Error toggling listing status: $e');
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(
                  Icons.error_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text('Failed to update status. Please try again.'),
              ],
            ),
            backgroundColor: AppTheme.errorColor,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.list_alt_rounded,
              size: 60,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Service Listings Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first service listing to\nstart attracting customers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/add-service'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text(
              'Add Your First Service',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          SizedBox(height: 16),
          Text(
            'Loading your service listings...',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 60,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to Load Listings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.errorColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(serviceListingsProvider.notifier).refresh();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            label: const Text(
              'Try Again',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }
} 