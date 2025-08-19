import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../models/private_theater.dart';
import '../providers/theater_provider.dart';

class TheaterManagementCard extends ConsumerWidget {
  const TheaterManagementCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theatersAsync = ref.watch(theatersProvider);

    return theatersAsync.when(
      data: (theaters) {
        if (theaters.isEmpty) {
          return _buildNoTheatersCard(context);
        }
        
        // Show the first theater (most recent)
        final theater = theaters.first;
        return _buildTheaterCard(context, theater);
      },
      loading: () => _buildLoadingCard(),
      error: (error, stack) => _buildErrorCard(context, error.toString()),
    );
  }

  Widget _buildNoTheatersCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.05),
            AppTheme.primaryColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.theaters_rounded,
              color: AppTheme.primaryColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Add Your First Theater',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start by adding your theater details for admin approval',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/simple-add-theater'),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add Theater'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTheaterCard(BuildContext context, PrivateTheater theater) {
    final statusConfig = _getStatusConfig(theater.approvalStatus);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusConfig.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.theaters_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        theater.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${theater.city}, ${theater.state}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusConfig.icon,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusConfig.label,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Theater Details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.people_rounded,
                        label: 'Capacity',
                        value: '${theater.capacity} people',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.location_on_rounded,
                        label: 'Pin Code',
                        value: theater.pinCode,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Status Message
                _buildStatusMessage(theater),
                
                const SizedBox(height: 16),
                
                // Action Buttons
                _buildActionButtons(context, theater),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: AppTheme.textSecondaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessage(PrivateTheater theater) {
    String message;
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (theater.approvalStatus) {
      case 'pending':
        message = 'Your theater is under admin review. You\'ll be notified once approved.';
        backgroundColor = AppTheme.warningColor.withOpacity(0.1);
        textColor = AppTheme.warningColor;
        icon = Icons.pending_rounded;
        break;
      case 'approved':
        message = 'Great! Your theater is approved. Configure screens and time slots to start accepting bookings.';
        backgroundColor = AppTheme.successColor.withOpacity(0.1);
        textColor = AppTheme.successColor;
        icon = Icons.check_circle_rounded;
        break;
      case 'rejected':
        message = 'Theater approval was rejected. ${theater.adminNotes ?? 'Please contact support for details.'}';
        backgroundColor = AppTheme.errorColor.withOpacity(0.1);
        textColor = AppTheme.errorColor;
        icon = Icons.cancel_rounded;
        break;
      default:
        message = 'Status unknown. Please contact support.';
        backgroundColor = AppTheme.textSecondaryColor.withOpacity(0.1);
        textColor = AppTheme.textSecondaryColor;
        icon = Icons.help_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: textColor,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PrivateTheater theater) {
    if (theater.approvalStatus == 'approved') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.push('/theater-details/${theater.id}'),
              icon: const Icon(Icons.visibility_rounded, size: 16),
              label: const Text('View Details'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => context.push('/manage-screens/${theater.id}'),
              icon: const Icon(Icons.settings_rounded, size: 16),
              label: const Text('Manage Screens'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (theater.approvalStatus == 'rejected') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => context.push('/simple-add-theater'),
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Submit New Theater'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    } else {
      // Pending status - no actions available
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.textSecondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Waiting for admin approval...',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String error) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppTheme.errorColor,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Failed to load theater',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  ({Color backgroundColor, String label, IconData icon}) _getStatusConfig(String status) {
    switch (status) {
      case 'approved':
        return (
          backgroundColor: AppTheme.successColor,
          label: 'Approved',
          icon: Icons.check_circle,
        );
      case 'rejected':
        return (
          backgroundColor: AppTheme.errorColor,
          label: 'Rejected',
          icon: Icons.cancel,
        );
      case 'pending':
      default:
        return (
          backgroundColor: AppTheme.warningColor,
          label: 'Pending',
          icon: Icons.pending,
        );
    }
  }
}