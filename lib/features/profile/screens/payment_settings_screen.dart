import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../onboarding/providers/vendor_provider.dart';
import '../../../core/config/supabase_config.dart';

class PaymentSettingsScreen extends ConsumerStatefulWidget {
  const PaymentSettingsScreen({super.key});

  @override
  ConsumerState<PaymentSettingsScreen> createState() => _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState extends ConsumerState<PaymentSettingsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _walletData;
  List<Map<String, dynamic>>? _transactions;
  Map<String, dynamic>? _privateDetails;

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
    _loadPaymentData();
  }

  Future<void> _loadPaymentData() async {
    final vendor = ref.read(vendorProvider).value;
    if (vendor == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = SupabaseConfig.client;
      
      // Fetch wallet data
      final walletResponse = await supabase
          .from('vendor_wallets')
          .select('*')
          .eq('vendor_id', vendor.id)
          .maybeSingle();

      if (walletResponse != null) {
        _walletData = walletResponse;
      } else {
        // Initialize wallet if it doesn't exist
        _walletData = {
          'available_balance': 0.0,
          'pending_balance': 0.0,
          'total_earned': 0.0,
          'total_withdrawn': 0.0,
        };
      }

      // Fetch private details (bank account, GST, etc.)
      final privateDetailsResponse = await supabase
          .from('vendor_private_details')
          .select('*')
          .eq('vendor_id', vendor.id)
          .maybeSingle();

      _privateDetails = privateDetailsResponse ?? {};

      // Fetch recent transactions (last 10)
      final transactionsResponse = await supabase
          .from('wallet_transactions')
          .select('*')
          .eq('vendor_id', vendor.id)
          .order('created_at', ascending: false)
          .limit(10);

      _transactions = List<Map<String, dynamic>>.from(transactionsResponse);
      
    } catch (e) {
      print('Error loading payment data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load payment data: $e'),
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppTheme.primaryColor),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Wallet Overview
                        _buildWalletOverview(),
                        
                        const SizedBox(height: 24),
                        
                        // Bank Details Section
                        _buildSectionHeader('Bank Details'),
                        const SizedBox(height: 16),
                        _buildBankDetailsSection(),
                        
                        const SizedBox(height: 24),
                        
                        // Recent Transactions Section
                        _buildSectionHeader('Recent Transactions'),
                        const SizedBox(height: 16),
                        _buildTransactionsSection(),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
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

  Widget _buildWalletOverview() {
    if (_walletData == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wallet Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildWalletCard(
                  'Available Balance',
                  _formatCurrency(_walletData!['available_balance']),
                  Icons.account_balance_wallet,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildWalletCard(
                  'Pending Balance',
                  _formatCurrency(_walletData!['pending_balance']),
                  Icons.pending_actions,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildWalletCard(
                  'Total Earned',
                  _formatCurrency(_walletData!['total_earned']),
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildWalletCard(
                  'Total Withdrawn',
                  _formatCurrency(_walletData!['total_withdrawn']),
                  Icons.download,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard(String title, String amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return '₹0.00';
    
    double amount;
    if (value is String) {
      amount = double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      amount = value.toDouble();
    } else {
      amount = 0.0;
    }
    
    return '₹${amount.toStringAsFixed(2)}';
  }

  String _formatBankAccount(String? accountNumber) {
    if (accountNumber == null || accountNumber.isEmpty) {
      return 'Not provided';
    }
    
    if (accountNumber.length > 4) {
      return '****${accountNumber.substring(accountNumber.length - 4)}';
    }
    return accountNumber;
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    // Handle real Supabase transaction data structure
    final transactionType = transaction['transaction_type'] ?? '';
    final amount = transaction['amount'];
    final status = transaction['status'] ?? 'pending';
    final description = transaction['description'] ?? _getTransactionDescription(transactionType);
    final createdAt = transaction['created_at'];
    
    // Determine if this is a credit or debit transaction
    final isCredit = _isTransactionCredit(transactionType);
    
    // Parse amount
    double transactionAmount = 0.0;
    if (amount is String) {
      transactionAmount = double.tryParse(amount) ?? 0.0;
    } else if (amount is num) {
      transactionAmount = amount.toDouble();
    }
    
    // Parse date
    DateTime date = DateTime.now();
    if (createdAt != null) {
      try {
        date = DateTime.parse(createdAt);
      } catch (e) {
        // Use current date if parsing fails
      }
    }
    
    final statusColor = _getStatusColor(status);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getTransactionIcon(transactionType),
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${date.day}/${date.month}/${date.year}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : ''}${_formatCurrency(transactionAmount)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isCredit ? AppTheme.successColor : AppTheme.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  bool _isTransactionCredit(String transactionType) {
    return transactionType == 'order_payment' || 
           transactionType == 'bonus' ||
           transactionType == 'order_refund';
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppTheme.successColor;
      case 'pending':
        return AppTheme.warningColor;
      case 'failed':
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }

  IconData _getTransactionIcon(String transactionType) {
    switch (transactionType) {
      case 'order_payment':
        return Icons.payment;
      case 'withdrawal':
        return Icons.money_off;
      case 'order_refund':
        return Icons.keyboard_return;
      case 'bonus':
        return Icons.card_giftcard;
      case 'penalty':
        return Icons.money_off;
      case 'withdrawal_fee':
        return Icons.receipt;
      default:
        return Icons.account_balance_wallet;
    }
  }

  String _getTransactionDescription(String transactionType) {
    switch (transactionType) {
      case 'order_payment':
        return 'Payment from order';
      case 'withdrawal':
        return 'Withdrawal to bank account';
      case 'order_refund':
        return 'Order refund';
      case 'bonus':
        return 'Bonus credit';
      case 'penalty':
        return 'Penalty deduction';
      case 'withdrawal_fee':
        return 'Withdrawal fee';
      default:
        return 'Transaction';
    }
  }

  Widget _buildBankDetailsSection() {
    if (_privateDetails == null) {
      return const SizedBox.shrink();
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
            _formatBankAccount(_privateDetails?['bank_account_number']),
            Icons.account_balance,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'IFSC Code',
            _privateDetails?['bank_ifsc_code'] ?? 'Not provided',
            Icons.code,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            'GST Number',
            _privateDetails?['gst_number'] ?? 'Not provided',
            Icons.receipt_long,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Navigate to edit bank details screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit bank details feature coming soon!'),
                    backgroundColor: AppTheme.warningColor,
                  ),
                );
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

  Widget _buildTransactionsSection() {
    if (_transactions == null || _transactions!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor),
        ),
        child: const Center(
          child: Text(
            'No transactions found',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        children: _transactions!.take(5).map((transaction) {
          return _buildTransactionItem(transaction);
        }).toList(),
      ),
    );
  }
} 