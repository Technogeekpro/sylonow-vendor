import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/add_theater_controller.dart';
import '../service/theater_service.dart';

class TheaterAmenitiesSection extends StatefulWidget {
  final AddTheaterController controller;

  const TheaterAmenitiesSection({
    super.key,
    required this.controller,
  });

  @override
  State<TheaterAmenitiesSection> createState() => _TheaterAmenitiesSectionState();
}

class _TheaterAmenitiesSectionState extends State<TheaterAmenitiesSection> {
  late TheaterService _theaterService;
  List<String> _availableAmenities = [];

  @override
  void initState() {
    super.initState();
    _theaterService = TheaterService();
    _availableAmenities = _theaterService.getAmenities();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Amenities & Facilities',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select the amenities available at your theater',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 32),

          // Selected Amenities Count
          if (widget.controller.selectedAmenities.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${widget.controller.selectedAmenities.length} amenities selected',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Amenities Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3.5,
            ),
            itemCount: _availableAmenities.length,
            itemBuilder: (context, index) {
              final amenity = _availableAmenities[index];
              final isSelected = widget.controller.selectedAmenities.contains(amenity);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      widget.controller.removeAmenity(amenity);
                    } else {
                      widget.controller.addAmenity(amenity);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.primaryColor.withOpacity(0.1)
                        : AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? AppTheme.primaryColor
                          : AppTheme.borderColor,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSelected 
                                ? AppTheme.primaryColor
                                : AppTheme.borderColor,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          amenity,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.w500,
                            color: isSelected 
                                ? AppTheme.primaryColor
                                : AppTheme.textPrimaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Custom Amenity Input
          _buildCustomAmenityInput(),

          const SizedBox(height: 32),

          // Selected Amenities Preview
          if (widget.controller.selectedAmenities.isNotEmpty) ...[
            const Text(
              'Selected Amenities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.controller.selectedAmenities.map((amenity) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        amenity,
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
                            widget.controller.removeAmenity(amenity);
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
          ],

          const SizedBox(height: 32),

          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.accentBlue.withOpacity(0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppTheme.accentBlue,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'More amenities = Better visibility! Customers prefer theaters with good facilities.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCustomAmenityInput() {
    final TextEditingController customController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Custom Amenity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: customController,
                decoration: InputDecoration(
                  hintText: 'e.g., VIP Lounge, 4K Projection',
                  hintStyle: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                final customAmenity = customController.text.trim();
                if (customAmenity.isNotEmpty && 
                    !widget.controller.selectedAmenities.contains(customAmenity)) {
                  setState(() {
                    widget.controller.addAmenity(customAmenity);
                    customController.clear();
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}