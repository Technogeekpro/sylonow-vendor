import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/theater_time_slot.dart';
import '../providers/theater_time_slot_provider.dart';
import '../service/theater_time_slot_service.dart';

class TimeSlotManagementScreen extends ConsumerStatefulWidget {
  final String screenId;
  final String screenName;
  final String theaterId;

  const TimeSlotManagementScreen({
    super.key,
    required this.screenId,
    required this.screenName,
    required this.theaterId,
  });

  @override
  ConsumerState<TimeSlotManagementScreen> createState() => _TimeSlotManagementScreenState();
}

class _TimeSlotManagementScreenState extends ConsumerState<TimeSlotManagementScreen> {
  DateTime _selectedDate = DateTime.now();
  Map<String, bool> _slotBookingStatus = {};
  
  @override
  void initState() {
    super.initState();
    _loadBookingStatusForDate();
  }
  
  @override
  Widget build(BuildContext context) {
    final timeSlotsAsync = ref.watch(screenTimeSlotsProvider(widget.screenId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              widget.screenName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const Text(
              'Manage time slots',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: Column(
        children: [
          // Date Selection View
          _buildDateSelectionView(),

          // Time Slots Grid
          Expanded(
            child: timeSlotsAsync.when(
              data: (timeSlots) => _buildTimeSlotGrid(timeSlots),
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryColor),
                    SizedBox(height: 16),
                    Text(
                      'Loading time slots...',
                      style: TextStyle(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              error: (err, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeroIcon(
                      HeroIcons.exclamationTriangle,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load time slots',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () {
                        ref.invalidate(screenTimeSlotsProvider);
                      },
                      icon: const HeroIcon(HeroIcons.arrowPath, size: 16),
                      label: const Text('Try Again'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeTo12Hour(String time24) {
    final parts = time24.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    
    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
    }
  }

  Widget _buildTimeSlotGrid(List<TheaterTimeSlot> timeSlots) {
    // Create grid items - add plus button at the end
    final List<Widget> gridItems = [];
    
    // Add existing time slots
    for (final timeSlot in timeSlots) {
      gridItems.add(_buildTimeSlotGridItem(timeSlot));
    }
    
    // Add plus button for adding new time slot
    gridItems.add(_buildAddTimeSlotGridItem());
    
    // If no time slots, show empty state with just the plus button
    if (timeSlots.isEmpty) {
      return Container(
        color: Colors.grey.shade50,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroIcon(
                HeroIcons.clock,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No time slots yet',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the + button below to create\\nyour first time slot',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 100,
                height: 70,
                child: _buildAddTimeSlotGridItem(),
              ),
            ],
          ),
        ),
      );
    }
    
    return Container(
      color: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: gridItems.length,
          itemBuilder: (context, index) => gridItems[index],
        ),
      ),
    );
  }
  
  Widget _buildTimeSlotGridItem(TheaterTimeSlot timeSlot) {
    final isBooked = _slotBookingStatus[timeSlot.id] ?? false;
    
    return GestureDetector(
      onTap: () => _showTimeSlotOptionsDialog(timeSlot),
      child: Container(
        decoration: BoxDecoration(
          color: isBooked ? Colors.grey.shade200 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isBooked 
                ? Colors.grey.shade300
                : AppTheme.primaryColor,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  _formatTimeTo12Hour(timeSlot.startTime),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isBooked 
                        ? Colors.grey.shade600
                        : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 1),
              Flexible(
                child: Text(
                  _formatTimeTo12Hour(timeSlot.endTime),
                  style: TextStyle(
                    fontSize: 11,
                    color: isBooked 
                        ? Colors.grey.shade500
                        : Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  '₹${timeSlot.pricePerHour.toStringAsFixed(0)}/hr',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isBooked 
                        ? Colors.grey.shade500
                        : AppTheme.primaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isBooked) ...[
                const SizedBox(height: 2),
                FutureBuilder<Map<String, dynamic>?>(
                  future: ref.read(theaterTimeSlotServiceProvider)
                      .getBookingDetailsForSlotAndDate(timeSlot.id, _selectedDate),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final bookingType = snapshot.data!['type'];
                      final isCustomerBooking = bookingType == 'customer_booking';
                      
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: isCustomerBooking ? Colors.blue.shade400 : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isCustomerBooking ? 'CUSTOMER' : 'BLOCKED',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'BOOKED',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAddTimeSlotGridItem() {
    return GestureDetector(
      onTap: () => _showCreateTimeSlotDialog(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.primaryColor,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
              HeroIcons.plus,
              size: 20,
              color: AppTheme.primaryColor,
            ),
            SizedBox(height: 4),
            Text(
              'Add Slot',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeSlotOptionsDialog(TheaterTimeSlot timeSlot) async {
    final isBooked = _slotBookingStatus[timeSlot.id] ?? false;
    
    // Get detailed booking information if slot is booked
    Map<String, dynamic>? bookingDetails;
    if (isBooked) {
      bookingDetails = await ref.read(theaterTimeSlotServiceProvider)
          .getBookingDetailsForSlotAndDate(timeSlot.id, _selectedDate);
    }
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Time Slot: ${_formatTimeTo12Hour(timeSlot.startTime)} - ${_formatTimeTo12Hour(timeSlot.endTime)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₹${timeSlot.pricePerHour.toStringAsFixed(0)} per hour',
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryColor,
              ),
            ),
            if (isBooked && bookingDetails != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              if (bookingDetails['type'] == 'customer_booking') ...[
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    const Text(
                      'Customer Booking',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Customer: ${bookingDetails['customer_name']}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  'Status: ${bookingDetails['booking_status'].toString().toUpperCase()}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ] else ...[
                Row(
                  children: [
                    Icon(Icons.bookmark, size: 16, color: Colors.orange.shade600),
                    const SizedBox(width: 8),
                    const Text(
                      'Vendor Marked',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Marked as unavailable by you',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (!isBooked)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _markAsBookedForSelectedDate(timeSlot);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Mark as Booked'),
            )
          else if (bookingDetails != null && bookingDetails['can_unbook'] == true)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _unmarkAsBookedForDate(timeSlot);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Remove Booking'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showEditTimeSlotBottomSheet(timeSlot);
            },
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showDeleteConfirmation(timeSlot);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCreateTimeSlotDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TimeSlotFormBottomSheet(
        screenId: widget.screenId,
        theaterId: widget.theaterId,
        onSlotCreated: () {
          ref.invalidate(screenTimeSlotsProvider);
        },
      ),
    );
  }

  void _showEditTimeSlotBottomSheet(TheaterTimeSlot timeSlot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TimeSlotFormBottomSheet(
        screenId: widget.screenId,
        theaterId: widget.theaterId,
        timeSlot: timeSlot,
        onSlotCreated: () {
          ref.invalidate(screenTimeSlotsProvider);
        },
      ),
    );
  }

  Widget _buildDateSelectionView() {
    return Container(
      height: 120,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Select Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 30, // Next 30 days
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected = _isSameDay(date, _selectedDate);
                final isToday = _isSameDay(date, DateTime.now());
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                    _loadBookingStatusForDate();
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday && !isSelected
                          ? Border.all(color: AppTheme.primaryColor, width: 1)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getDayName(date.weekday),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: isSelected 
                                ? Colors.white
                                : isToday
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected 
                                ? Colors.white
                                : isToday
                                    ? AppTheme.primaryColor
                                    : Colors.black87,
                          ),
                        ),
                        Text(
                          _getMonthName(date.month).substring(0, 3),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                            color: isSelected 
                                ? Colors.white
                                : isToday
                                    ? AppTheme.primaryColor
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
  
  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  Future<void> _loadBookingStatusForDate() async {
    try {
      final timeSlotsAsync = ref.read(screenTimeSlotsProvider(widget.screenId));
      if (timeSlotsAsync.hasValue) {
        final timeSlots = timeSlotsAsync.value!;
        final Map<String, bool> newStatus = {};
        
        for (final slot in timeSlots) {
          final isBooked = await ref.read(theaterTimeSlotServiceProvider)
              .isSlotBookedForDate(slot.id, _selectedDate);
          newStatus[slot.id] = isBooked;
        }
        
        if (mounted) {
          setState(() {
            _slotBookingStatus = newStatus;
          });
        }
      }
    } catch (e) {
      print('🔴 ERROR: Failed to load booking status: $e');
    }
  }
  
  Future<void> _markAsBookedForSelectedDate(TheaterTimeSlot timeSlot) async {
    await _markAsBooked(timeSlot, _selectedDate);
    await _loadBookingStatusForDate();
  }
  
  Future<void> _unmarkAsBookedForDate(TheaterTimeSlot timeSlot) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removing booking...')),
      );

      await ref.read(theaterTimeSlotServiceProvider)
          .unmarkSlotAsBookedForDate(timeSlot.id, _selectedDate);
      
      await _loadBookingStatusForDate();
      
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        final dateStr = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking removed for $dateStr'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove booking: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _markAsBooked(TheaterTimeSlot timeSlot, DateTime date) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marking slot as booked...')),
      );

      await ref.read(theaterTimeSlotServiceProvider)
          .markSlotAsBooked(timeSlot.id, date);
      
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        final dateStr = '${date.day}/${date.month}/${date.year}';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Time slot marked as booked for $dateStr'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mark as booked: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }


  void _showDeleteConfirmation(TheaterTimeSlot timeSlot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Time Slot'),
        content: Text(
          'Are you sure you want to delete the time slot ${timeSlot.startTime} - ${timeSlot.endTime}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteTimeSlot(timeSlot);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteTimeSlot(TheaterTimeSlot timeSlot) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleting time slot...')),
      );

      await ref.read(theaterTimeSlotServiceProvider).deleteTimeSlot(timeSlot.id);
      
      ref.invalidate(screenTimeSlotsProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Time slot deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete time slot: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _QuickCreateTimeSlotDialog extends ConsumerStatefulWidget {
  final String screenId;
  final String theaterId;
  final VoidCallback onSlotCreated;

  const _QuickCreateTimeSlotDialog({
    required this.screenId,
    required this.theaterId,
    required this.onSlotCreated,
  });

  @override
  ConsumerState<_QuickCreateTimeSlotDialog> createState() => _QuickCreateTimeSlotDialogState();
}

class _QuickCreateTimeSlotDialogState extends ConsumerState<_QuickCreateTimeSlotDialog> {
  final _commonTimeSlots = [
    {'start': '09:00', 'end': '17:00', 'price': 500.0, 'name': 'Full Day', 'display': '9:00 AM - 5:00 PM'},
    {'start': '09:00', 'end': '13:00', 'price': 300.0, 'name': 'Morning', 'display': '9:00 AM - 1:00 PM'},
    {'start': '14:00', 'end': '18:00', 'price': 300.0, 'name': 'Afternoon', 'display': '2:00 PM - 6:00 PM'},
    {'start': '19:00', 'end': '23:00', 'price': 400.0, 'name': 'Evening', 'display': '7:00 PM - 11:00 PM'},
    {'start': '10:00', 'end': '22:00', 'price': 600.0, 'name': 'Extended', 'display': '10:00 AM - 10:00 PM'},
  ];
  
  bool _isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const HeroIcon(
              HeroIcons.bolt,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Add Time Slots',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Choose from common time slots',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...(_commonTimeSlots.map((slot) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: _isLoading ? null : () => _createTimeSlot(slot),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const HeroIcon(
                          HeroIcons.clock,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot['name'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              slot['display'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${(slot['price'] as double).toStringAsFixed(0)}/hr',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
  
  void _createTimeSlot(Map<String, dynamic> slot) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final newTimeSlot = TheaterTimeSlot(
        id: '',
        theaterId: widget.theaterId,
        screenId: widget.screenId,
        startTime: slot['start'] as String,
        endTime: slot['end'] as String,
        pricePerHour: slot['price'] as double,
        isAvailable: true,
        isActive: true,
      );

      await ref.read(theaterTimeSlotServiceProvider).createTimeSlot(newTimeSlot);
      
      widget.onSlotCreated();
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Time slot "${slot['name']}" created successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create time slot: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _TimeSlotFormBottomSheet extends ConsumerStatefulWidget {
  final String screenId;
  final String theaterId;
  final TheaterTimeSlot? timeSlot;
  final VoidCallback onSlotCreated;

  const _TimeSlotFormBottomSheet({
    required this.screenId,
    required this.theaterId,
    this.timeSlot,
    required this.onSlotCreated,
  });

  @override
  ConsumerState<_TimeSlotFormBottomSheet> createState() => _TimeSlotFormBottomSheetState();
}

class _TimeSlotFormBottomSheetState extends ConsumerState<_TimeSlotFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.timeSlot?.pricePerHour.toString() ?? '');
    
    if (widget.timeSlot != null) {
      // Parse existing time slot times
      final startParts = widget.timeSlot!.startTime.split(':');
      final endParts = widget.timeSlot!.endTime.split(':');
      _startTime = TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1]));
      _endTime = TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1]));
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTimeTo12Hour(TimeOfDay time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    
    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
    }
  }

  Future<void> _selectTime(bool isStartTime) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime ?? TimeOfDay.now() : _endTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              dayPeriodBorderSide: const BorderSide(color: AppTheme.primaryColor),
              dayPeriodColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              dayPeriodTextColor: AppTheme.primaryColor,
              hourMinuteColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              hourMinuteTextColor: AppTheme.primaryColor,
              dialHandColor: AppTheme.primaryColor,
              dialBackgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
              dialTextColor: AppTheme.textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = selectedTime;
        } else {
          _endTime = selectedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.timeSlot != null;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          Text(
            isEditing ? 'Edit Time Slot' : 'Create Time Slot',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 24),
          
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Time Selection Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Start Time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectTime(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.borderColor),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade50,
                              ),
                              child: Row(
                                children: [
                                  const HeroIcon(
                                    HeroIcons.clock,
                                    size: 20,
                                    color: AppTheme.primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _startTime != null ? _formatTimeTo12Hour(_startTime!) : 'Select start time',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _startTime != null ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'End Time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _selectTime(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.borderColor),
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade50,
                              ),
                              child: Row(
                                children: [
                                  const HeroIcon(
                                    HeroIcons.clock,
                                    size: 20,
                                    color: AppTheme.primaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    _endTime != null ? _formatTimeTo12Hour(_endTime!) : 'Select end time',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: _endTime != null ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Price Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price per Hour (₹)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        hintText: 'Enter price per hour',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price per hour';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: AppTheme.borderColor),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveTimeSlot,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEditing ? 'Update' : 'Create',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveTimeSlot() async {
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both start and end times'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final isEditing = widget.timeSlot != null;
      final startTimeStr = _formatTimeOfDay(_startTime!);
      final endTimeStr = _formatTimeOfDay(_endTime!);
      
      if (isEditing) {
        // Update existing time slot
        await ref.read(theaterTimeSlotServiceProvider).updateTimeSlot(
          widget.timeSlot!.id,
          {
            'start_time': startTimeStr,
            'end_time': endTimeStr,
            'price_per_hour': double.parse(_priceController.text),
          },
        );
      } else {
        // Create new time slot
        final newTimeSlot = TheaterTimeSlot(
          id: '', // Will be auto-generated
          theaterId: widget.theaterId,
          screenId: widget.screenId,
          startTime: startTimeStr,
          endTime: endTimeStr,
          pricePerHour: double.parse(_priceController.text),
          isAvailable: true,
          isActive: true,
        );

        await ref.read(theaterTimeSlotServiceProvider).createTimeSlot(newTimeSlot);
      }

      widget.onSlotCreated();
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Time slot ${isEditing ? 'updated' : 'created'} successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ${widget.timeSlot != null ? 'update' : 'create'} time slot: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}