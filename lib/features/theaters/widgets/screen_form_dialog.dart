import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../models/theater_screen.dart';
import '../service/theater_service.dart';

class ScreenFormDialog extends StatefulWidget {
  final TheaterScreen? screen; // null for new screen
  final Function(TheaterScreen) onSave;
  final List<TheaterScreen> existingScreens;

  const ScreenFormDialog({
    super.key,
    this.screen,
    required this.onSave,
    required this.existingScreens,
  });

  @override
  State<ScreenFormDialog> createState() => _ScreenFormDialogState();
}

class _ScreenFormDialogState extends State<ScreenFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _capacityController;
  late TextEditingController _hourlyRateController;
  
  List<String> _selectedAmenities = [];
  int _screenNumber = 1;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    _nameController = TextEditingController(
      text: widget.screen?.screenName ?? '',
    );
    _capacityController = TextEditingController(
      text: widget.screen?.allowedCapacity.toString() ?? '',
    );
    _hourlyRateController = TextEditingController(
      text: widget.screen?.originalHourlyPrice.toString() ?? '',
    );
    
    // Initialize other fields
    if (widget.screen != null) {
      _selectedAmenities = List.from(widget.screen!.amenities);
      _screenNumber = widget.screen!.screenNumber;
      _isActive = widget.screen!.isActive;
    } else {
      // Auto-generate screen number
      _screenNumber = _getNextScreenNumber();
      _nameController.text = 'Screen $_screenNumber';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  int _getNextScreenNumber() {
    if (widget.existingScreens.isEmpty) return 1;
    
    final existingNumbers = widget.existingScreens
        .map((screen) => screen.screenNumber)
        .toList()..sort();
    
    for (int i = 1; i <= existingNumbers.length + 1; i++) {
      if (!existingNumbers.contains(i)) {
        return i;
      }
    }
    return existingNumbers.length + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.theaters_rounded,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.screen != null ? 'Edit Screen' : 'Add New Screen',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryColor,
                    ),
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
            
            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Screen Number and Name
                      Row(
                        children: [
                          // Screen Number
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Screen Number',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withAlpha(26),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppTheme.primaryColor.withAlpha(77),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _screenNumber.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Screen Name
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Screen Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: 'e.g., Screen 1, Main Hall',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: AppTheme.primaryColor),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value?.trim().isEmpty ?? true) {
                                      return 'Screen name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Capacity and Hourly Rate
                      Row(
                        children: [
                          // Capacity
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Capacity',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _capacityController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: InputDecoration(
                                    hintText: 'Number of people',
                                    suffix: const Text('people'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: AppTheme.primaryColor),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value?.trim().isEmpty ?? true) {
                                      return 'Capacity is required';
                                    }
                                    final capacity = int.tryParse(value!);
                                    if (capacity == null || capacity <= 0) {
                                      return 'Enter valid capacity';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Hourly Rate
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hourly Rate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _hourlyRateController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    hintText: 'Rate per hour',
                                    prefixText: '₹ ',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: AppTheme.primaryColor),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value?.trim().isEmpty ?? true) {
                                      return 'Hourly rate is required';
                                    }
                                    final rate = double.tryParse(value!);
                                    if (rate == null || rate <= 0) {
                                      return 'Enter valid rate';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Amenities
                      const Text(
                        'Screen Amenities (Optional)',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildAmenitiesSelection(),
                      
                      const SizedBox(height: 16),
                      
                      // Active Status
                      SwitchListTile(
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                        title: const Text(
                          'Active Screen',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        subtitle: Text(
                          _isActive 
                              ? 'Screen is available for bookings'
                              : 'Screen is temporarily disabled',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        activeColor: AppTheme.primaryColor,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
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
                    onPressed: _saveScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(widget.screen != null ? 'Update Screen' : 'Add Screen'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesSelection() {
    final theaterService = TheaterService();
    final availableAmenities = theaterService.getAmenities();
    
    return Container(
      constraints: const BoxConstraints(maxHeight: 150),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: availableAmenities.map((amenity) {
            final isSelected = _selectedAmenities.contains(amenity);
            return FilterChip(
              label: Text(
                amenity,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppTheme.textPrimaryColor,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAmenities.add(amenity);
                  } else {
                    _selectedAmenities.remove(amenity);
                  }
                });
              },
              backgroundColor: AppTheme.surfaceColor,
              selectedColor: AppTheme.primaryColor,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected 
                    ? AppTheme.primaryColor 
                    : AppTheme.borderColor,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _saveScreen() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final screen = TheaterScreen(
      id: widget.screen?.id ?? '', // Will be generated by database
      theaterId: '', // Will be set by parent
      screenName: _nameController.text.trim(),
      screenNumber: _screenNumber,
      allowedCapacity: int.parse(_capacityController.text.trim()),
      amenities: _selectedAmenities,
      originalHourlyPrice: double.parse(_hourlyRateController.text.trim()),
      isActive: _isActive,
    );

    widget.onSave(screen);
    Navigator.of(context).pop();
  }
}