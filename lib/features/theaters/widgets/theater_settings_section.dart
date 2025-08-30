import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/add_theater_controller.dart';

class TheaterSettingsSection extends StatefulWidget {
  final AddTheaterController controller;

  const TheaterSettingsSection({
    super.key,
    required this.controller,
  });

  @override
  State<TheaterSettingsSection> createState() => _TheaterSettingsSectionState();
}

class _TheaterSettingsSectionState extends State<TheaterSettingsSection> {
  @override
  void initState() {
    super.initState();
    // Initialize default values if empty
    if (widget.controller.bookingDurationController.text.isEmpty) {
      widget.controller.initializeDefaults();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: widget.controller.settingsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Configure your theater booking preferences',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),

            // Booking Duration
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'Minimum Booking Duration',
                    controller: widget.controller.bookingDurationController,
                    hint: '2',
                    suffix: 'hours',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Duration is required';
                      }
                      final duration = int.tryParse(value.trim());
                      if (duration == null || duration <= 0) {
                        return 'Enter valid duration';
                      }
                      if (duration > 12) {
                        return 'Maximum 12 hours allowed';
                      }
                      return null;
                    },
                    required: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    label: 'Advance Booking',
                    controller: widget.controller.advanceBookingDaysController,
                    hint: '30',
                    suffix: 'days',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Advance days required';
                      }
                      final days = int.tryParse(value.trim());
                      if (days == null || days <= 0) {
                        return 'Enter valid days';
                      }
                      if (days > 365) {
                        return 'Maximum 365 days allowed';
                      }
                      return null;
                    },
                    required: true,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Cancellation Policy
            _buildInputField(
              label: 'Cancellation Policy',
              controller: widget.controller.cancellationPolicyController,
              hint: 'Free cancellation up to 24 hours before the booking',
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Cancellation policy is required';
                }
                if (value.trim().length < 20) {
                  return 'Please provide a detailed cancellation policy';
                }
                return null;
              },
              required: true,
            ),

            const SizedBox(height: 32),

            // Quick Settings Cards
            const Text(
              'Quick Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildQuickSettingCard(
                    title: 'Standard',
                    subtitle: '2 hrs booking\n30 days advance',
                    onTap: () => _applyQuickSetting(2, 30),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickSettingCard(
                    title: 'Flexible',
                    subtitle: '1 hr booking\n60 days advance',
                    onTap: () => _applyQuickSetting(1, 60),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildQuickSettingCard(
                    title: 'Premium',
                    subtitle: '4 hrs booking\n90 days advance',
                    onTap: () => _applyQuickSetting(4, 90),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickSettingCard(
                    title: 'Event Mode',
                    subtitle: '6 hrs booking\n180 days advance',
                    onTap: () => _applyQuickSetting(6, 180),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Cancellation Policy Templates
            const Text(
              'Policy Templates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),

            ..._buildPolicyTemplates(),

            const SizedBox(height: 32),

            // Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.preview,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Booking Preview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Customers can book your theater for minimum ${widget.controller.bookingDurationController.text.isEmpty ? "2" : widget.controller.bookingDurationController.text} hours, up to ${widget.controller.advanceBookingDaysController.text.isEmpty ? "30" : widget.controller.advanceBookingDaysController.text} days in advance.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                      height: 1.4,
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
    String? suffix,
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
            suffixText: suffix,
            hintStyle: const TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14,
            ),
            suffixStyle: const TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
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

  Widget _buildQuickSettingCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondaryColor,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPolicyTemplates() {
    final templates = [
      {
        'title': 'Flexible',
        'policy': 'Free cancellation up to 24 hours before the booking. 50% refund for cancellations within 24 hours.',
      },
      {
        'title': 'Standard',
        'policy': 'Free cancellation up to 48 hours before the booking. No refund for cancellations within 48 hours.',
      },
      {
        'title': 'Strict',
        'policy': 'Free cancellation up to 7 days before the booking. 25% refund for cancellations between 3-7 days.',
      },
    ];

    return templates.map((template) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () {
            widget.controller.cancellationPolicyController.text = template['policy']!;
            setState(() {});
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
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
                    Expanded(
                      child: Text(
                        '${template['title']} Policy',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  template['policy']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  void _applyQuickSetting(int duration, int advanceDays) {
    widget.controller.bookingDurationController.text = duration.toString();
    widget.controller.advanceBookingDaysController.text = advanceDays.toString();
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings applied: $duration hrs booking, $advanceDays days advance'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}