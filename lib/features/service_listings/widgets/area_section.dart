import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/add_service_controller.dart';

class AreaSection extends StatefulWidget {
  final AddServiceController controller;

  const AreaSection({
    super.key,
    required this.controller,
  });

  @override
  State<AreaSection> createState() => _AreaSectionState();
}

class _AreaSectionState extends State<AreaSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pincodes Section
          _buildSectionTitle('Service Areas'),
          const SizedBox(height: 8),
          const Text(
            'Add pincodes where you provide services (max 20).',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildPincodesSection(),
          
          const SizedBox(height: 24),
          
          // Venue Types Section
          _buildSectionTitle('Venue Types'),
          const SizedBox(height: 8),
          const Text(
            'Select the types of venues where you can provide services.',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildVenueTypesSection(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildPincodesSection() {
    return Column(
      children: [
        // Pincode input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.controller.pincodeController,
                decoration: InputDecoration(
                  hintText: 'Enter 6-digit pincode',
                  prefixIcon: const Icon(Icons.location_on_rounded, color: AppTheme.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (_) => null,
                onFieldSubmitted: (value) => _addPincode(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: widget.controller.pincodes.length < 20 ? _addPincode : null,
              style: IconButton.styleFrom(
                backgroundColor: widget.controller.pincodes.length < 20 
                    ? AppTheme.primaryColor 
                    : AppTheme.borderColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Pincodes list
        if (widget.controller.pincodes.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Added Pincodes:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              Text(
                '${widget.controller.pincodes.length}/20',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.controller.pincodes.map((pincode) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pincode,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.controller.removePincode(pincode);
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppTheme.textSecondaryColor,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Add at least one pincode to continue',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVenueTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select applicable venue types:',
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.controller.venueTypes.map((venueType) {
            final isSelected = widget.controller.selectedVenueTypes.contains(venueType);
            return GestureDetector(
              onTap: () {
                setState(() {
                  widget.controller.toggleVenueType(venueType);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppTheme.primaryColor 
                      : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? AppTheme.primaryColor 
                        : AppTheme.borderColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getVenueIcon(venueType),
                      size: 16,
                      color: isSelected 
                          ? Colors.white 
                          : AppTheme.textPrimaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      venueType,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected 
                            ? Colors.white 
                            : AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Text(
          '${widget.controller.selectedVenueTypes.length} venue types selected',
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        
        // Service area summary
        if (widget.controller.pincodes.isNotEmpty && 
            widget.controller.selectedVenueTypes.isNotEmpty) ...[
          const SizedBox(height: 24),
          _buildServiceAreaSummary(),
        ],
      ],
    );
  }

  Widget _buildServiceAreaSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 20,
                color: AppTheme.primaryColor,
              ),
              SizedBox(width: 8),
              Text(
                'Service Area Summary',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.controller.pincodes.length} pincodes',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.business,
                size: 16,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.controller.selectedVenueTypes.length} venue types',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getVenueIcon(String venueType) {
    switch (venueType.toLowerCase()) {
      case 'home':
      case 'apartment':
        return Icons.home_rounded;
      case 'café':
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'rooftop':
        return Icons.roofing_rounded;
      case 'garden':
        return Icons.local_florist_rounded;
      case 'hall':
        return Icons.meeting_room_rounded;
      case 'hotel':
        return Icons.hotel_rounded;
      case 'office':
        return Icons.business_rounded;
      case 'outdoor':
      case 'beach':
        return Icons.landscape_rounded;
      case 'farmhouse':
        return Icons.cottage_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  void _addPincode() {
    if (widget.controller.pincodeController.text.length == 6) {
      final isValid = widget.controller.validatePincode(widget.controller.pincodeController.text) == null;
      if (isValid) {
        setState(() {
          widget.controller.addPincode();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid 6-digit pincode'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pincode must be 6 digits'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
} 