import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/vendor_private_details_provider.dart';

class PaymentSettingsScreen extends ConsumerStatefulWidget {
  const PaymentSettingsScreen({super.key});

  @override
  ConsumerState<PaymentSettingsScreen> createState() =>
      _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState extends ConsumerState<PaymentSettingsScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Header
          _buildHeader(context),

          // Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Refresh bank details
                ref.invalidate(vendorPrivateDetailsDataProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Bank Details Section
                    _buildSectionHeader('Bank Details'),
                    const SizedBox(height: 16),
                    _buildBankDetailsSection(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 20, 20, 24),
      decoration: BoxDecoration(
       color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          const Expanded(
            child: Text(
              'Payment Settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ), 
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildBankDetailsSection() {
    final privateDetailsAsync = ref.watch(vendorPrivateDetailsDataProvider);
    
    return privateDetailsAsync.when(
      data: (details) {
        if (details == null) {
          return _buildEmptyBankDetails();
        }
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              _buildDetailRow(
                'Bank Account',
                details.formattedBankAccount.isNotEmpty 
                    ? details.formattedBankAccount 
                    : 'Not provided',
                Icons.account_balance,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'IFSC Code',
                details.bankIfscCode ?? 'Not provided',
                Icons.code,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'GST Number',
                details.gstNumber ?? 'Not provided',
                Icons.receipt_long,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                'Aadhaar Number',
                details.aadhaarNumber != null 
                    ? '**** **** ${details.aadhaarNumber!.substring(details.aadhaarNumber!.length - 4)}'
                    : 'Not provided',
                Icons.credit_card,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.push('/edit-bank-details');
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Bank Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: AppTheme.errorColor,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Failed to load bank details',
              style: TextStyle(
                color: AppTheme.errorColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => ref.refresh(vendorPrivateDetailsDataProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyBankDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: AppTheme.textSecondaryColor,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'No Bank Details Added',
            style: TextStyle(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add your bank details to receive payments',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('/edit-bank-details');
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Bank Details'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
