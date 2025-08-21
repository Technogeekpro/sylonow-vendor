import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class TimeSlotsScreen extends ConsumerStatefulWidget {
  final String theaterId;
  final String? screenId;

  const TimeSlotsScreen({
    super.key,
    required this.theaterId,
    this.screenId,
  });

  @override
  ConsumerState<TimeSlotsScreen> createState() => _TimeSlotsScreenState();
}

class _TimeSlotsScreenState extends ConsumerState<TimeSlotsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  final List<String> _timeSlots = [
    '09:00', '10:00', '11:00', '12:00', '13:00', '14:00',
    '15:00', '16:00', '17:00', '18:00', '19:00', '20:00',
    '21:00', '22:00'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Time Slots Management'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Available'),
            Tab(text: 'Booked'),
            Tab(text: 'Generate'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Date Selector
          _buildDateSelector(),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailableSlots(),
                _buildBookedSlots(),
                _buildGenerateSlots(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Select Date:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryColor,
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

  Widget _buildAvailableSlots() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Time Slots',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: _timeSlots.length - 1,
            itemBuilder: (context, index) {
              final startTime = _timeSlots[index];
              final endTime = _timeSlots[index + 1];
              
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$startTime - $endTime',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Available',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookedSlots() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booked Time Slots',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),

          // Mock booked slots
          ...List.generate(3, (index) {
            final bookedSlots = [
              {'time': '14:00 - 16:00', 'customer': 'John Doe', 'amount': '₹4000'},
              {'time': '18:00 - 20:00', 'customer': 'Jane Smith', 'amount': '₹4000'},
              {'time': '20:00 - 22:00', 'customer': 'Mike Johnson', 'amount': '₹4000'},
            ];
            
            final slot = bookedSlots[index];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppTheme.errorColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slot['time']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          slot['customer']!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    slot['amount']!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGenerateSlots() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Generate Time Slots',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bulk generate time slots for multiple dates',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),

          // Date Range Selection
          _buildDateRangeCard(),
          
          const SizedBox(height: 24),

          // Time Range Selection
          _buildTimeRangeCard(),
          
          const SizedBox(height: 24),

          // Pricing Settings
          _buildPricingCard(),
          
          const SizedBox(height: 32),

          // Generate Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _generateTimeSlots,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Generate Time Slots',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Date Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDateField('From', 'Select start date'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateField('To', 'Select end date'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Time Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTimeField('Start Time', '09:00'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimeField('End Time', '22:00'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTimeField('Slot Duration', '2 hours'),
        ],
      ),
    );
  }

  Widget _buildPricingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pricing Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceField('Base Price (₹)', '2000'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildPriceField('Weekend Multiplier', '1.5x'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPriceField('Holiday Multiplier', '2.0x'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            hint,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            hint,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            hint,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _generateTimeSlots() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement time slot generation logic
      await Future.delayed(const Duration(seconds: 2)); // Mock delay
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Time slots generated successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        _tabController.animateTo(0); // Switch to Available tab
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate slots: ${e.toString()}'),
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