import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../models/theater_screen.dart';
import '../models/theater_time_slot.dart';

class TimeSlotsManagementDialog extends StatefulWidget {
  final TheaterScreen? screen; // null for main theater
  final Function(List<TheaterTimeSlot>) onSlotsUpdated;
  final List<TheaterTimeSlot> existingSlots;
  final double basePrice;

  const TimeSlotsManagementDialog({
    super.key,
    this.screen,
    required this.onSlotsUpdated,
    required this.existingSlots,
    required this.basePrice,
  });

  @override
  State<TimeSlotsManagementDialog> createState() => _TimeSlotsManagementDialogState();
}

class _TimeSlotsManagementDialogState extends State<TimeSlotsManagementDialog> {
  List<TheaterTimeSlot> _timeSlots = [];
  String _selectedTimeSlotType = 'predefined'; // 'predefined' or 'custom'
  
  // Predefined slot generation
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 22, minute: 0);
  int _slotDuration = 2; // hours
  
  // Custom slot creation
  final _customStartController = TextEditingController();
  final _customEndController = TextEditingController();
  final _customPriceController = TextEditingController();
  
  // Pricing controls
  final _basePriceController = TextEditingController();
  final _pricePerHourController = TextEditingController();
  double _weekdayMultiplier = 1.0;
  double _weekendMultiplier = 1.5;
  double _holidayMultiplier = 2.0;

  @override
  void initState() {
    super.initState();
    _timeSlots = List.from(widget.existingSlots);
    _basePriceController.text = widget.basePrice.toString();
    _pricePerHourController.text = widget.basePrice.toString();
  }

  @override
  void dispose() {
    _customStartController.dispose();
    _customEndController.dispose();
    _customPriceController.dispose();
    _basePriceController.dispose();
    _pricePerHourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time Slots Management',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      if (widget.screen != null)
                        Text(
                          'For ${widget.screen!.screenName}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  splashRadius: 20,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Slot Generation Type Selection
                    _buildSlotTypeSelection(),
                    
                    const SizedBox(height: 24),
                    
                    // Slot Generation Controls
                    if (_selectedTimeSlotType == 'predefined')
                      _buildPredefinedSlotsSection()
                    else
                      _buildCustomSlotSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Pricing Configuration
                    _buildPricingSection(),
                    
                    const SizedBox(height: 24),
                    
                    // Current Time Slots
                    _buildCurrentSlotsSection(),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.textSecondaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveTimeSlots,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Save Time Slots (${_timeSlots.length})'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotTypeSelection() {
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
            'Slot Generation Method',
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
                child: RadioListTile<String>(
                  value: 'predefined',
                  groupValue: _selectedTimeSlotType,
                  onChanged: (value) {
                    setState(() {
                      _selectedTimeSlotType = value!;
                    });
                  },
                  title: const Text(
                    'Auto Generate',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Create slots automatically',
                    style: TextStyle(fontSize: 12),
                  ),
                  activeColor: AppTheme.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  value: 'custom',
                  groupValue: _selectedTimeSlotType,
                  onChanged: (value) {
                    setState(() {
                      _selectedTimeSlotType = value!;
                    });
                  },
                  title: const Text(
                    'Custom Slots',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Add individual slots',
                    style: TextStyle(fontSize: 12),
                  ),
                  activeColor: AppTheme.primaryColor,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredefinedSlotsSection() {
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
            'Auto Generate Time Slots',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              // Start Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start Time', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _startTime,
                        );
                        if (time != null) {
                          setState(() {
                            _startTime = time;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.borderColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 8),
                            Text(_startTime.format(context)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // End Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('End Time', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _endTime,
                        );
                        if (time != null) {
                          setState(() {
                            _endTime = time;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.borderColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 8),
                            Text(_endTime.format(context)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Duration
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Duration (Hours)', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _slotDuration,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: [1, 2, 3, 4, 6, 8].map((hours) {
                        return DropdownMenuItem(
                          value: hours,
                          child: Text('$hours hour${hours > 1 ? 's' : ''}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _slotDuration = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _generatePredefinedSlots,
              icon: const Icon(Icons.auto_fix_high, size: 16),
              label: const Text('Generate Time Slots'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSlotSection() {
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
            'Add Custom Time Slot',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              // Start Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start Time', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _customStartController,
                      decoration: InputDecoration(
                        hintText: 'HH:MM (e.g., 09:00)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // End Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('End Time', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _customEndController,
                      decoration: InputDecoration(
                        hintText: 'HH:MM (e.g., 11:00)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9:]')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addCustomSlot,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Time Slot'),
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
      ),
    );
  }

  Widget _buildPricingSection() {
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
            'Pricing Configuration',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Base Price (₹)', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _basePriceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
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
                    const Text('Price Per Hour (₹)', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _pricePerHourController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          const Text(
            'Dynamic Pricing Multipliers',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          
          // Weekday Multiplier
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text('Weekdays (Mon-Thu)', style: TextStyle(fontSize: 14)),
              ),
              Expanded(
                child: Slider(
                  value: _weekdayMultiplier,
                  min: 0.5,
                  max: 2.0,
                  divisions: 15,
                  label: '${_weekdayMultiplier.toStringAsFixed(1)}x',
                  onChanged: (value) {
                    setState(() {
                      _weekdayMultiplier = value;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ),
              Text(
                '${_weekdayMultiplier.toStringAsFixed(1)}x',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          
          // Weekend Multiplier
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text('Weekends (Fri-Sun)', style: TextStyle(fontSize: 14)),
              ),
              Expanded(
                child: Slider(
                  value: _weekendMultiplier,
                  min: 0.5,
                  max: 3.0,
                  divisions: 25,
                  label: '${_weekendMultiplier.toStringAsFixed(1)}x',
                  onChanged: (value) {
                    setState(() {
                      _weekendMultiplier = value;
                    });
                  },
                  activeColor: AppTheme.accentPink,
                ),
              ),
              Text(
                '${_weekendMultiplier.toStringAsFixed(1)}x',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          
          // Holiday Multiplier
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text('Holidays', style: TextStyle(fontSize: 14)),
              ),
              Expanded(
                child: Slider(
                  value: _holidayMultiplier,
                  min: 1.0,
                  max: 5.0,
                  divisions: 40,
                  label: '${_holidayMultiplier.toStringAsFixed(1)}x',
                  onChanged: (value) {
                    setState(() {
                      _holidayMultiplier = value;
                    });
                  },
                  activeColor: AppTheme.warningColor,
                ),
              ),
              Text(
                '${_holidayMultiplier.toStringAsFixed(1)}x',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSlotsSection() {
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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Current Time Slots',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ),
              if (_timeSlots.isNotEmpty)
                TextButton.icon(
                  onPressed: _clearAllSlots,
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Clear All'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_timeSlots.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.borderColor.withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 32,
                    color: AppTheme.textSecondaryColor,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No time slots configured',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _timeSlots.length,
              itemBuilder: (context, index) {
                final slot = _timeSlots[index];
                return _buildTimeSlotCard(slot, index);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotCard(TheaterTimeSlot slot, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
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
                  '${slot.startTime} - ${slot.endTime}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Base: ₹${slot.basePrice} | Per Hour: ₹${slot.pricePerHour}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeTimeSlot(index),
            icon: const Icon(Icons.delete_outline),
            iconSize: 16,
            color: AppTheme.errorColor,
            splashRadius: 16,
          ),
        ],
      ),
    );
  }

  void _generatePredefinedSlots() {
    final slots = <TheaterTimeSlot>[];
    
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    final endMinutes = _endTime.hour * 60 + _endTime.minute;
    final durationMinutes = _slotDuration * 60;
    
    for (int currentMinutes = startMinutes; 
         currentMinutes + durationMinutes <= endMinutes; 
         currentMinutes += durationMinutes) {
      
      final startHour = currentMinutes ~/ 60;
      final startMinute = currentMinutes % 60;
      final endCurrentMinutes = currentMinutes + durationMinutes;
      final endHour = endCurrentMinutes ~/ 60;
      final endMinuteValue = endCurrentMinutes % 60;
      
      final slot = TheaterTimeSlot(
        id: '',
        theaterId: '',
        screenId: widget.screen?.id,
        startTime: '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')}',
        endTime: '${endHour.toString().padLeft(2, '0')}:${endMinuteValue.toString().padLeft(2, '0')}',
        basePrice: double.tryParse(_basePriceController.text) ?? widget.basePrice,
        pricePerHour: double.tryParse(_pricePerHourController.text) ?? widget.basePrice,
        weekdayMultiplier: _weekdayMultiplier,
        weekendMultiplier: _weekendMultiplier,
        holidayMultiplier: _holidayMultiplier,
        maxDurationHours: _slotDuration,
        minDurationHours: _slotDuration,
      );
      
      slots.add(slot);
    }
    
    setState(() {
      _timeSlots = slots;
    });
    
    _showSuccessSnackBar('Generated ${slots.length} time slots successfully!');
  }

  void _addCustomSlot() {
    final startTime = _customStartController.text.trim();
    final endTime = _customEndController.text.trim();
    
    if (startTime.isEmpty || endTime.isEmpty) {
      _showErrorSnackBar('Please enter both start and end time');
      return;
    }
    
    // Validate time format
    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(startTime) || !timeRegex.hasMatch(endTime)) {
      _showErrorSnackBar('Please enter valid time format (HH:MM)');
      return;
    }
    
    final slot = TheaterTimeSlot(
      id: '',
      theaterId: '',
      screenId: widget.screen?.id,
      startTime: startTime,
      endTime: endTime,
      basePrice: double.tryParse(_basePriceController.text) ?? widget.basePrice,
      pricePerHour: double.tryParse(_pricePerHourController.text) ?? widget.basePrice,
      weekdayMultiplier: _weekdayMultiplier,
      weekendMultiplier: _weekendMultiplier,
      holidayMultiplier: _holidayMultiplier,
    );
    
    setState(() {
      _timeSlots.add(slot);
      _customStartController.clear();
      _customEndController.clear();
    });
    
    _showSuccessSnackBar('Time slot added successfully!');
  }

  void _removeTimeSlot(int index) {
    setState(() {
      _timeSlots.removeAt(index);
    });
  }

  void _clearAllSlots() {
    setState(() {
      _timeSlots.clear();
    });
  }

  void _saveTimeSlots() {
    widget.onSlotsUpdated(_timeSlots);
    Navigator.of(context).pop();
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}