import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sylonow_vendor/core/theme/app_theme.dart';
import 'package:sylonow_vendor/features/wallet/providers/wallet_provider.dart';

class WithdrawalScreen extends ConsumerStatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  ConsumerState<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends ConsumerState<WithdrawalScreen> {
  String _enteredAmount = '';
  double _availableBalance = 0.0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletProvider);
    final bankDetailsAsync = ref.watch(bankDetailsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Withdraw money',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimaryColor),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
      ),
      body: walletAsync.when(
        data: (wallet) {
        _availableBalance = wallet.availableBalance;
          return Column(
            children: [
              // Available Balance Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  '₹${NumberFormat('#,##,###.00').format(wallet.availableBalance)} available',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Main Amount Display Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Large Amount Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '₹',
                            style: TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w300,
                              color: AppTheme.textPrimaryColor,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _enteredAmount.isEmpty ? '0' : _enteredAmount,
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w300,
                              color: AppTheme.textPrimaryColor,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Status Message
                      Text(
                        _enteredAmount.isEmpty || double.tryParse(_enteredAmount) == 0
                            ? 'No balance available to withdraw'
                            : 'Enter amount to withdraw',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Bank Details Section
              bankDetailsAsync.when(
                data: (bankDetails) => _buildBankDetailsSection(bankDetails),
                loading: () => _buildBankDetailsLoading(),
                error: (err, stack) => _buildBankDetailsError(),
              ),

              // Numeric Keypad
              _buildNumericKeypad(),

              // Withdraw Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: _canWithdraw() && !_isLoading ? _processWithdrawal : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Withdraw',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppTheme.errorColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load wallet details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.errorColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                err.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(walletProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankDetailsSection(Map<String, dynamic>? bankDetails) {
    if (bankDetails == null || 
        bankDetails['masked_account_number'] == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.warningColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.warningColor.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.warning_outlined,
                color: AppTheme.warningColor,
                size: 24,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bank details not available',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warningColor,
                      ),
                    ),
                    Text(
                      'Please complete your profile to add bank details',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Navigate to bank details edit screen
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bank Account',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        bankDetails['masked_account_number'] ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.textSecondaryColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankDetailsLoading() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppTheme.borderColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetailsError() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.errorColor,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Failed to load bank details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Row 1: 1, 2, 3
          Row(
            children: [
              _buildKeypadButton('1'),
              _buildKeypadButton('2'),
              _buildKeypadButton('3'),
            ],
          ),
          const SizedBox(height: 16),
          // Row 2: 4, 5, 6
          Row(
            children: [
              _buildKeypadButton('4'),
              _buildKeypadButton('5'),
              _buildKeypadButton('6'),
            ],
          ),
          const SizedBox(height: 16),
          // Row 3: 7, 8, 9
          Row(
            children: [
              _buildKeypadButton('7'),
              _buildKeypadButton('8'),
              _buildKeypadButton('9'),
            ],
          ),
          const SizedBox(height: 16),
          // Row 4: ., 0, backspace
          Row(
            children: [
              _buildKeypadButton('.', enabled: !_enteredAmount.contains('.')),
              _buildKeypadButton('0'),
              _buildKeypadButton('⌫', isBackspace: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String text, {bool enabled = true, bool isBackspace = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: enabled ? () => _onKeypadPressed(text, isBackspace) : null,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: enabled ? AppTheme.surfaceColor : AppTheme.surfaceColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: enabled ? AppTheme.borderColor : AppTheme.borderColor.withOpacity(0.3),
                ),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: enabled ? AppTheme.textPrimaryColor : AppTheme.textSecondaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onKeypadPressed(String value, bool isBackspace) {
    setState(() {
      if (isBackspace) {
        if (_enteredAmount.isNotEmpty) {
          _enteredAmount = _enteredAmount.substring(0, _enteredAmount.length - 1);
        }
      } else {
        // Limit to reasonable number length and decimal places
        if (_enteredAmount.length < 10) {
          // Don't allow multiple decimal points
          if (value == '.' && _enteredAmount.contains('.')) return;
          
          // Don't allow decimal point at the beginning
          if (value == '.' && _enteredAmount.isEmpty) return;
          
          // Limit decimal places to 2
          if (_enteredAmount.contains('.')) {
            final parts = _enteredAmount.split('.');
            if (parts.length > 1 && parts[1].length >= 2) return;
          }
          
          _enteredAmount += value;
        }
      }
    });
  }

  bool _canWithdraw() {
    if (_enteredAmount.isEmpty) return false;
    final amount = double.tryParse(_enteredAmount);
    if (amount == null || amount <= 0) return false;
    if (amount < 100) return false; // Minimum withdrawal
    if (amount > _availableBalance) return false;
    return true;
  }

  void _processWithdrawal() async {
    if (!_canWithdraw()) return;

    final amount = double.parse(_enteredAmount);

    setState(() {
      _isLoading = true;
    });

    try {
      // Create withdrawal request using bank details from database
      final bankDetails = await ref.read(bankDetailsProvider.future);
      if (bankDetails != null && 
          bankDetails['bank_account_number'] != null && 
          bankDetails['bank_ifsc_code'] != null) {
        
      final withdrawalNotifier = ref.read(withdrawalNotifierProvider.notifier);
      
      await withdrawalNotifier.createWithdrawal(
          amount: amount,
          bankAccountNumber: bankDetails['bank_account_number'],
          bankIfscCode: bankDetails['bank_ifsc_code'],
          bankAccountHolderName: 'Account Holder', // TODO: Get from vendor profile
      );

      final withdrawalState = ref.read(withdrawalNotifierProvider);
      
      if (withdrawalState.status == WithdrawalStatus.success) {
          _showSuccessDialog(amount);
      } else if (withdrawalState.status == WithdrawalStatus.error) {
        _showErrorSnackBar(withdrawalState.message ?? 'Failed to create withdrawal request');
        }
      } else {
        _showErrorSnackBar('Bank details not found. Please update your profile.');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to create withdrawal request: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(
          Icons.check_circle,
          color: AppTheme.successColor,
          size: 64,
        ),
        title: const Text(
          'Withdrawal Request Submitted',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textPrimaryColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your withdrawal request for ₹${NumberFormat('#,##,###.00').format(amount)} has been submitted successfully.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textPrimaryColor),
            ),
            const SizedBox(height: 16),
            const Text(
              'It will be processed within 1-2 business days. You will receive a notification once it\'s approved.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/wallet');
            },
            child: const Text(
              'OK',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
} 