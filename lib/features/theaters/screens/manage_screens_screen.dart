import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../models/private_theater.dart';
import '../models/theater_screen.dart';
import '../models/theater_time_slot.dart';
import '../providers/theater_provider.dart';
import '../controllers/screen_management_controller.dart';

class ManageScreensScreen extends ConsumerStatefulWidget {
  final String theaterId;

  const ManageScreensScreen({
    super.key,
    required this.theaterId,
  });

  @override
  ConsumerState<ManageScreensScreen> createState() => _ManageScreensScreenState();
}

class _ManageScreensScreenState extends ConsumerState<ManageScreensScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _setStatusBarColor();
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
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theatersAsync = ref.watch(theatersProvider);
    final controller = ref.watch(screenManagementControllerProvider(widget.theaterId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      body: theatersAsync.when(
        data: (theaters) {
          final theater = theaters.firstWhere(
            (t) => t.id == widget.theaterId,
            orElse: () => throw Exception('Theater not found'),
          );
          
          return Column(
            children: [
              // Header
              _buildHeader(theater),
              
              // Tab Bar
              _buildTabBar(),
              
              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildScreensTab(controller),
                    _buildTimeSlotsTab(controller),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error.toString()),
      ),
    );
  }

  Widget _buildHeader(PrivateTheater theater) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18,
                  ),
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
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Manage Screens & Time Slots',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Approved',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Theater Info
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.people_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${theater.capacity}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Capacity',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        theater.city,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Location',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondaryColor,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.theaters_rounded, size: 16),
                SizedBox(width: 8),
                Text('Screens'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule_rounded, size: 16),
                SizedBox(width: 8),
                Text('Time Slots'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreensTab(ScreenManagementController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Add Screen Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddScreenDialog(controller),
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Add New Screen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Screens List
          Expanded(
            child: controller.screens.isEmpty
                ? _buildEmptyScreensState()
                : ListView.builder(
                    itemCount: controller.screens.length,
                    itemBuilder: (context, index) {
                      final screen = controller.screens[index];
                      return _buildScreenCard(screen, controller);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsTab(ScreenManagementController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Quick Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showGenerateTimeSlotsDialog(controller),
                  icon: const Icon(Icons.auto_fix_high, size: 18),
                  label: const Text('Auto Generate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showAddCustomTimeSlotDialog(controller),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Custom'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Time Slots List
          Expanded(
            child: controller.timeSlots.isEmpty
                ? _buildEmptyTimeSlotsState()
                : ListView.builder(
                    itemCount: controller.timeSlots.length,
                    itemBuilder: (context, index) {
                      final timeSlot = controller.timeSlots[index];
                      return _buildTimeSlotCard(timeSlot, controller);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreenCard(TheaterScreen screen, ScreenManagementController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    screen.screenNumber.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      screen.screenName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${screen.allowedCapacity} people • ₹${screen.originalHourlyPrice}/hour',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _showEditScreenDialog(screen, controller);
                      break;
                    case 'delete':
                      _showDeleteScreenDialog(screen, controller);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: AppTheme.errorColor),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: AppTheme.errorColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          if (screen.amenities.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: screen.amenities.take(3).map((amenity) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    amenity,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.accentTeal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSlotCard(TheaterTimeSlot timeSlot, ScreenManagementController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${timeSlot.startTime} - ${timeSlot.endTime}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Base: ₹${timeSlot.basePrice} | Per Hour: ₹${timeSlot.pricePerHour}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showDeleteTimeSlotDialog(timeSlot, controller),
            icon: const Icon(Icons.delete_outline),
            iconSize: 16,
            color: AppTheme.errorColor,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyScreensState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.theaters_outlined,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'No Screens Configured',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add screens to start managing your theater',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTimeSlotsState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule_outlined,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'No Time Slots Configured',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Configure time slots to allow bookings',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error Loading Theater',
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
        ],
      ),
    );
  }

  // Dialog methods (simplified for brevity)
  void _showAddScreenDialog(ScreenManagementController controller) {
    // Implementation for add screen dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Screen dialog - To be implemented')),
    );
  }

  void _showEditScreenDialog(TheaterScreen screen, ScreenManagementController controller) {
    // Implementation for edit screen dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit Screen dialog - To be implemented')),
    );
  }

  void _showDeleteScreenDialog(TheaterScreen screen, ScreenManagementController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Screen'),
        content: Text('Are you sure you want to delete "${screen.screenName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteScreen(screen.id);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showGenerateTimeSlotsDialog(ScreenManagementController controller) {
    // Implementation for generate time slots dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generate Time Slots dialog - To be implemented')),
    );
  }

  void _showAddCustomTimeSlotDialog(ScreenManagementController controller) {
    // Implementation for add custom time slot dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Custom Time Slot dialog - To be implemented')),
    );
  }

  void _showDeleteTimeSlotDialog(TheaterTimeSlot timeSlot, ScreenManagementController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Time Slot'),
        content: Text('Are you sure you want to delete the time slot "${timeSlot.startTime} - ${timeSlot.endTime}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteTimeSlot(timeSlot.id);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}