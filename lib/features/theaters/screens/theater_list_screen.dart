import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';

class TheaterListScreen extends ConsumerStatefulWidget {
  const TheaterListScreen({super.key});

  @override
  ConsumerState<TheaterListScreen> createState() => _TheaterListScreenState();
}

class _TheaterListScreenState extends ConsumerState<TheaterListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        title: const Text(
          'My Theaters',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/simple-add-theater'),
            icon: const HeroIcon(
              HeroIcons.plus,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.primaryColor,
        child: _buildTheaterList(),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // TODO: Refresh theater data from database
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _buildTheaterList() {
    // Mock data - Replace with actual data from database
    final mockTheaters = [
      {
        'id': '1',
        'name': 'PVR Cinemas',
        'location': 'Mall Road, City Center',
        'isVerified': true,
        'screens': 4,
        'capacity': 200,
        'imageUrl': null,
      },
      {
        'id': '2',
        'name': 'INOX Theater',
        'location': 'Downtown Plaza',
        'isVerified': false,
        'screens': 2,
        'capacity': 150,
        'imageUrl': null,
      },
      {
        'id': '3',
        'name': 'Carnival Cinemas',
        'location': 'Shopping Complex, Sector 5',
        'isVerified': true,
        'screens': 6,
        'capacity': 300,
        'imageUrl': null,
      },
    ];

    if (mockTheaters.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockTheaters.length,
      itemBuilder: (context, index) {
        final theater = mockTheaters[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildTheaterCard(theater),
        );
      },
    );
  }

  Widget _buildEmptyState() {
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
              child: const HeroIcon(
                HeroIcons.buildingOffice2,
                color: AppTheme.primaryColor,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No theaters added yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first theater to start managing shows and bookings',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/simple-add-theater'),
              icon: const HeroIcon(HeroIcons.plus, size: 20),
              label: const Text('Add Theater'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTheaterCard(Map<String, dynamic> theater) {
    final isVerified = theater['isVerified'] as bool;
    final screens = theater['screens'] as int;
    final capacity = theater['capacity'] as int;
    final imageUrl = theater['imageUrl'] as String?;

    return GestureDetector(
      onTap: () => _navigateToTheaterDetails(theater),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isVerified 
              ? AppTheme.successColor.withOpacity(0.3)
              : AppTheme.borderColor,
            width: 1,
          ),
          boxShadow: [AppTheme.cardShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Theater Image/Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: (isVerified 
                      ? AppTheme.successColor 
                      : AppTheme.primaryColor).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return HeroIcon(
                              HeroIcons.buildingOffice2,
                              color: isVerified 
                                ? AppTheme.successColor 
                                : AppTheme.primaryColor,
                              size: 28,
                            );
                          },
                        ),
                      )
                    : HeroIcon(
                        HeroIcons.buildingOffice2,
                        color: isVerified 
                          ? AppTheme.successColor 
                          : AppTheme.primaryColor,
                        size: 28,
                      ),
                ),
                
                const SizedBox(width: 16),
                
                // Theater Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              theater['name'] as String,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, 
                              vertical: 4
                            ),
                            decoration: BoxDecoration(
                              color: isVerified
                                ? AppTheme.successColor.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                HeroIcon(
                                  isVerified 
                                    ? HeroIcons.checkBadge 
                                    : HeroIcons.clock,
                                  size: 12,
                                  color: isVerified 
                                    ? AppTheme.successColor 
                                    : Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isVerified ? 'Verified' : 'Pending',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isVerified 
                                      ? AppTheme.successColor 
                                      : Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                              theater['location'] as String,
                              style: const TextStyle(
                                fontSize: 13,
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
                
                const SizedBox(width: 8),
                
                // Arrow
                const HeroIcon(
                  HeroIcons.chevronRight,
                  size: 20,
                  color: AppTheme.textSecondaryColor,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Theater Stats
            Row(
              children: [
                _buildStatChip(
                  icon: HeroIcons.tv,
                  label: '$screens Screens',
                  color: AppTheme.accentBlue,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  icon: HeroIcons.users,
                  label: '$capacity Capacity',
                  color: AppTheme.accentTeal,
                ),
                const Spacer(),
                _buildActionButton(theater),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required HeroIcons icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> theater) {
    final isVerified = theater['isVerified'] as bool;
    
    return GestureDetector(
      onTap: () => _showTheaterActions(theater),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const HeroIcon(
          HeroIcons.ellipsisVertical,
          size: 16,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  void _navigateToTheaterDetails(Map<String, dynamic> theater) {
    final theaterId = theater['id'] as String;
    context.push('/theater-management/$theaterId');
  }

  void _showTheaterActions(Map<String, dynamic> theater) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              theater['name'] as String,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildActionItem(
              icon: HeroIcons.eye,
              label: 'View Details',
              onTap: () {
                context.pop();
                _navigateToTheaterDetails(theater);
              },
            ),
            _buildActionItem(
              icon: HeroIcons.pencilSquare,
              label: 'Edit Theater',
              onTap: () {
                context.pop();
                // TODO: Navigate to edit theater screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit theater coming soon')),
                );
              },
            ),
            _buildActionItem(
              icon: HeroIcons.cog6Tooth,
              label: 'Manage Screens',
              onTap: () {
                context.pop();
                // TODO: Navigate to screen management
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Screen management coming soon')),
                );
              },
            ),
            _buildActionItem(
              icon: HeroIcons.trash,
              label: 'Delete Theater',
              color: AppTheme.errorColor,
              onTap: () {
                context.pop();
                _showDeleteConfirmation(theater);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required HeroIcons icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      onTap: onTap,
      leading: HeroIcon(
        icon,
        color: color ?? AppTheme.textPrimaryColor,
        size: 20,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? AppTheme.textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> theater) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Theater',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        content: Text(
          'Are you sure you want to delete "${theater['name']}"? This action cannot be undone.',
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              _deleteTheater(theater);
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

  void _deleteTheater(Map<String, dynamic> theater) {
    // TODO: Implement theater deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${theater['name']} has been deleted'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}