import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sylonow_vendor/features/wallet/models/wallet.dart';
import 'package:sylonow_vendor/features/wallet/models/wallet_transaction.dart';
import 'package:sylonow_vendor/features/wallet/providers/wallet_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Wallet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(walletProvider);
          ref.invalidate(walletTransactionsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet Balance Card
              Consumer(
                builder: (context, ref, child) {
                  final walletAsync = ref.watch(walletProvider);
                  return walletAsync.when(
                    data: (wallet) => _buildWalletCard(wallet, context),
                    loading: () => _buildLoadingWalletCard(),
                    error: (err, stack) => _buildErrorWalletCard(err.toString(), ref),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              // Recent Transactions
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              
              // Transaction List
              Consumer(
                builder: (context, ref, child) {
                  final transactionsAsync = ref.watch(walletTransactionsProvider);
                  return transactionsAsync.when(
                    data: (transactions) => _buildTransactionsList(transactions),
                    loading: () => _buildLoadingTransactions(),
                    error: (err, stack) => _buildErrorTransactions(err.toString(), ref),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletCard(Wallet wallet, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.pink, Colors.pinkAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Balance',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // Show last updated time
              Text(
                'Updated: ${DateFormat('HH:mm').format(wallet.updatedAt)}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₹ ${NumberFormat('#,##,###.00').format(wallet.totalBalance)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      '₹ ${NumberFormat('#,##,###.00').format(wallet.availableBalance)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      '₹ ${NumberFormat('#,##,###.00').format(wallet.pendingBalance)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Additional wallet stats
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Earned',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '₹ ${NumberFormat('#,##,###').format(wallet.totalEarned)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Withdrawn',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '₹ ${NumberFormat('#,##,###').format(wallet.totalWithdrawn)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Withdraw Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: wallet.availableBalance > 0 
                  ? () => context.push('/wallet/withdraw')
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.account_balance_wallet, size: 20),
              label: const Text(
                'Withdraw Money',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWalletCard() {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.pink, Colors.pinkAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildErrorWalletCard(String error, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 32),
          const SizedBox(height: 8),
          Text(
            'Failed to load wallet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            error,
            style: TextStyle(
              fontSize: 12,
              color: Colors.red.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(walletProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(List<WalletTransaction> transactions) {
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your transaction history will appear here',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return _buildTransactionCard(transactions[index]);
      },
    );
  }

  Widget _buildLoadingTransactions() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
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
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 12,
                      width: 100,
                      color: Colors.grey.shade200,
                    ),
                  ],
                ),
              ),
              Container(
                height: 16,
                width: 80,
                color: Colors.grey.shade200,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorTransactions(String error, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load transactions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(walletTransactionsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(WalletTransaction transaction) {
    final isCredit = transaction.amount > 0 && transaction.transactionType != 'withdrawal';
    final isWithdrawal = transaction.transactionType == 'withdrawal';
    
    // Determine transaction display properties
    String title;
    IconData icon;
    Color iconBgColor;
    Color iconColor;
    Color amountColor;
    
    switch (transaction.transactionType) {
      case 'order_payment':
        title = 'Order Payment';
        icon = Icons.shopping_bag;
        iconBgColor = Colors.green.shade50;
        iconColor = Colors.green;
        amountColor = Colors.green;
        break;
      case 'withdrawal':
        title = 'Withdrawal';
        icon = Icons.arrow_upward;
        iconBgColor = Colors.red.shade50;
        iconColor = Colors.red;
        amountColor = Colors.red;
        break;
      case 'order_refund':
        title = 'Order Refund';
        icon = Icons.undo;
        iconBgColor = Colors.orange.shade50;
        iconColor = Colors.orange;
        amountColor = Colors.orange;
        break;
      case 'bonus':
        title = 'Bonus';
        icon = Icons.card_giftcard;
        iconBgColor = Colors.purple.shade50;
        iconColor = Colors.purple;
        amountColor = Colors.green;
        break;
      default:
        title = transaction.transactionType.replaceAll('_', ' ').toUpperCase();
        icon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;
        iconBgColor = isCredit ? Colors.green.shade50 : Colors.red.shade50;
        iconColor = isCredit ? Colors.green : Colors.red;
        amountColor = isCredit ? Colors.green : Colors.red;
    }

    // Status indicator
    Widget? statusChip;
    if (transaction.status != 'completed') {
      Color chipColor;
      switch (transaction.status) {
        case 'pending':
          chipColor = Colors.orange;
          break;
        case 'failed':
          chipColor = Colors.red;
          break;
        case 'cancelled':
          chipColor = Colors.grey;
          break;
        default:
          chipColor = Colors.blue;
      }
      
      statusChip = Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: chipColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          transaction.status?.toUpperCase() ?? '',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: chipColor,
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    if (statusChip != null) statusChip,
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('MMM dd, yyyy • h:mm a').format(transaction.createdAt!),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (transaction.description != null && transaction.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    transaction.description!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Text(
            // Show minus sign for withdrawals, plus sign for credits
            '${isWithdrawal ? '-' : (isCredit ? '+' : '')}₹${NumberFormat('#,##,###.00').format(transaction.amount.abs())}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
} 