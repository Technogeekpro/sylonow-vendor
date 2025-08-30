import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/vendor_private_details_provider.dart';

class EditBankDetailsScreen extends ConsumerStatefulWidget {
  const EditBankDetailsScreen({super.key});

  @override
  ConsumerState<EditBankDetailsScreen> createState() =>
      _EditBankDetailsScreenState();
}

class _EditBankDetailsScreenState extends ConsumerState<EditBankDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();
  final _gstController = TextEditingController();
  final _aadhaarController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _ifscController.dispose();
    _gstController.dispose();
    _aadhaarController.dispose();
    super.dispose();
  }

  void _loadExistingData() async {
    try {
      final privateDetailsAsync = ref.read(vendorPrivateDetailsDataProvider);
      privateDetailsAsync.when(
        data: (details) {
          if (details != null) {
            _accountNumberController.text = details.bankAccountNumber ?? '';
            _ifscController.text = details.bankIfscCode ?? '';
            _gstController.text = details.gstNumber ?? '';
            _aadhaarController.text = details.aadhaarNumber ?? '';
          }
        },
        loading: () {},
        error: (_, __) {},
      );
    } catch (e) {
      // Handle loading error
    }
  }

  @override
  Widget build(BuildContext context) {
    final privateDetailsAsync = ref.watch(vendorPrivateDetailsDataProvider);
    final validators = ref.watch(validationHelperProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Edit Bank Details'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveDetails,
            child: Text(
              'Save',
              style: TextStyle(
                color: _isLoading ? Colors.white54 : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: privateDetailsAsync.when(
        data: (details) => _buildForm(validators),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 64, color: AppTheme.errorColor),
              const SizedBox(height: 16),
              Text('Error loading details: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(vendorPrivateDetailsDataProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Map<String, bool Function(String)> validators) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bank Details Section
            _buildSectionHeader('Bank Account Details', Icons.account_balance),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _accountNumberController,
              label: 'Bank Account Number',
              hint: 'Enter your account number',
              icon: Icons.credit_card,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Account number is required';
                }
                if (!validators['account']!(value)) {
                  return 'Please enter a valid account number (8-18 digits)';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _ifscController,
              label: 'IFSC Code',
              hint: 'e.g., SBIN0001234',
              icon: Icons.code,
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'IFSC code is required';
                }
                if (!validators['ifsc']!(value)) {
                  return 'Please enter a valid IFSC code';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            const SizedBox(height: 24),

            // Additional Details Section
            _buildSectionHeader(
                'Additional Details (Optional)', Icons.receipt_long),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _gstController,
              label: 'GST Number (Optional)',
              hint: 'e.g., 22AAAAA0000A1Z5',
              icon: Icons.receipt,
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value != null &&
                    value.isNotEmpty &&
                    !validators['gst']!(value)) {
                  return 'Please enter a valid GST number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _aadhaarController,
              label: 'Aadhaar Number (Optional)',
              hint: 'e.g., 1234 5678 9012',
              icon: Icons.credit_card,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  // Remove spaces for validation
                  final cleanValue = value.replaceAll(' ', '');
                  if (!validators['aadhaar']!(cleanValue)) {
                    return 'Please enter a valid 12-digit Aadhaar number';
                  }
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save Bank Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Help Text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.infoColor.withOpacity(0.3),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.infoColor,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Important Information',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.infoColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Bank details are required for payment processing\n'
                    '• IFSC code must be valid (11 characters)\n'
                    '• GST registration may be required for business transactions\n'
                    '• All information is securely encrypted',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
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
        filled: true,
        fillColor: AppTheme.surfaceColor,
      ),
    );
  }

  Future<void> _saveDetails() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare update data
      final updates = <String, dynamic>{
        'bank_account_number': _accountNumberController.text.trim(),
        'bank_ifsc_code': _ifscController.text.trim().toUpperCase(),
      };

      // Add optional fields if provided
      if (_gstController.text.isNotEmpty) {
        updates['gst_number'] = _gstController.text.trim().toUpperCase();
      }
      if (_aadhaarController.text.isNotEmpty) {
        // Remove spaces and store clean Aadhaar number
        updates['aadhaar_number'] =
            _aadhaarController.text.replaceAll(' ', '').trim();
      }

      // Update details
      await ref
          .read(vendorPrivateDetailsDataProvider.notifier)
          .updateDetails(updates);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bank details saved successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving details: $e'),
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
