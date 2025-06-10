import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/add_service_controller.dart';

class DetailsSection extends StatefulWidget {
  final AddServiceController controller;

  const DetailsSection({
    super.key,
    required this.controller,
  });

  @override
  State<DetailsSection> createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          _buildSectionTitle('Service Description'),
          const SizedBox(height: 8),
          const Text(
            'Provide a detailed description of your service offering.',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildDescriptionSection(),
          
          const SizedBox(height: 24),
          
          // Inclusions
          _buildSectionTitle('What\'s Included'),
          const SizedBox(height: 8),
          const Text(
            'List items that are included in your service package.',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildInclusionsSection(),
          
          const SizedBox(height: 24),
          
          // Customization
          _buildSectionTitle('Customization'),
          const SizedBox(height: 12),
          _buildCustomizationSection(),
          
          const SizedBox(height: 24),
          
          // Setup Time
          _buildSectionTitle('Setup Time'),
          const SizedBox(height: 8),
          _buildDropdownField(
            value: widget.controller.selectedSetupTime,
            items: widget.controller.setupTimeOptions,
            hint: 'How long does setup take?',
            icon: Icons.access_time_rounded,
            onChanged: (value) {
              setState(() {
                widget.controller.selectedSetupTime = value;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Booking Notice
          _buildSectionTitle('Booking Notice'),
          const SizedBox(height: 8),
          const Text(
            'How much advance notice do you need for bookings?',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildDropdownField(
            value: widget.controller.selectedBookingNotice,
            items: widget.controller.bookingNoticeOptions,
            hint: 'Select booking notice period',
            icon: Icons.schedule_rounded,
            onChanged: (value) {
              setState(() {
                widget.controller.selectedBookingNotice = value;
              });
            },
          ),
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

  Widget _buildDescriptionSection() {
    return TextFormField(
      controller: widget.controller.descriptionController,
      decoration: InputDecoration(
        hintText: 'Describe your service in detail - what makes it special, what customers can expect, etc.',
        prefixIcon: const Icon(Icons.description_outlined, color: AppTheme.primaryColor),
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
      maxLines: 4,
      maxLength: 500,
      validator: (_) => null, // Optional field, always valid
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildInclusionsSection() {
    return Column(
      children: [
        // Inclusion input
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.controller.inclusionController,
                decoration: InputDecoration(
                  hintText: 'e.g., Balloons, Banner, Setup',
                  prefixIcon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
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
                validator: (_) => null, // Optional input field, always valid
                onFieldSubmitted: (value) => _addInclusion(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _addInclusion,
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
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
        
        // Inclusions list
        if (widget.controller.inclusions.isNotEmpty) ...[
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Included Items:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.controller.inclusions.map((inclusion) {
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
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      inclusion,
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
                          widget.controller.removeInclusion(inclusion);
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
          const SizedBox(height: 8),
          Text(
            '${widget.controller.inclusions.length} items included',
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.textSecondaryColor,
            ),
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
                    'Add at least one item to continue',
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

  Widget _buildCustomizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Customization toggle
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.tune_rounded,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Offer Customization',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Allow customers to customize the service',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: widget.controller.customizationAvailable,
                onChanged: (value) {
                  setState(() {
                    widget.controller.customizationAvailable = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
        
        // Customization note (if enabled)
        if (widget.controller.customizationAvailable) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.controller.customizationNoteController,
            decoration: InputDecoration(
              hintText: 'Describe what can be customized (optional)',
              prefixIcon: const Icon(Icons.edit_note_rounded, color: AppTheme.primaryColor),
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
            validator: (_) => null, // Optional field, always valid
            maxLines: 2,
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String hint,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        ),
        hint: Text(hint),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select an option';
          }
          return null;
        },
      ),
    );
  }

  void _addInclusion() {
    if (widget.controller.inclusionController.text.isNotEmpty) {
      setState(() {
        widget.controller.addInclusion();
      });
    }
  }
} 