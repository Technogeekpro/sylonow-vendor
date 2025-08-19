import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/add_theater_controller.dart';

class TheaterBasicInfoSection extends StatefulWidget {
  final AddTheaterController controller;

  const TheaterBasicInfoSection({
    super.key,
    required this.controller,
  });

  @override
  State<TheaterBasicInfoSection> createState() => _TheaterBasicInfoSectionState();
}

class _TheaterBasicInfoSectionState extends State<TheaterBasicInfoSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.controller.basicInfoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tell us about your private theater',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),

            // Theater Name
            _buildInputField(
              label: 'Theater Name',
              controller: widget.controller.nameController,
              hint: 'e.g., Royal Cinema Hall',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Theater name is required';
                }
                if (value.trim().length < 3) {
                  return 'Theater name must be at least 3 characters';
                }
                return null;
              },
              required: true,
            ),

            const SizedBox(height: 24),

            // Description
            _buildInputField(
              label: 'Description',
              controller: widget.controller.descriptionController,
              hint: 'Describe your theater facilities and unique features',
              maxLines: 4,
              required: false,
            ),

            const SizedBox(height: 24),

            // Hourly Rate
            _buildInputField(
              label: 'Hourly Rate (₹)',
              controller: widget.controller.hourlyRateController,
              hint: '2000',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Hourly rate is required';
                }
                final rate = double.tryParse(value.trim());
                if (rate == null || rate <= 0) {
                  return 'Enter valid rate';
                }
                if (rate > 100000) {
                  return 'Rate seems too high';
                }
                return null;
              },
              required: true,
            ),

            const SizedBox(height: 32),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Add attractive theater name and competitive hourly rates to get more bookings.',
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
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: AppTheme.errorColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.errorColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}