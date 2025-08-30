import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_vendor/core/providers/auth_provider.dart';
import 'package:sylonow_vendor/features/wallet/models/wallet.dart';
import 'package:sylonow_vendor/features/wallet/models/wallet_transaction.dart';
import 'package:sylonow_vendor/features/wallet/services/wallet_service.dart';

// Wallet details provider
final walletProvider = FutureProvider<Wallet>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not authenticated');
  }

  print('🔵 WalletProvider: Fetching wallet for user');
  
  try {
    final walletService = ref.watch(walletServiceProvider);
    final wallet = await walletService.getWalletDetails();
    
    print('🟢 WalletProvider: Wallet loaded successfully');
    return wallet;
  } catch (e, stackTrace) {
    print('🔴 WalletProvider: Error loading wallet: $e');
    print('🔴 WalletProvider: Stack trace: $stackTrace');
    rethrow;
  }
});

// Bank details provider
final bankDetailsProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not authenticated');
  }

  print('🔵 BankDetailsProvider: Fetching bank details');
  
  try {
    final walletService = ref.watch(walletServiceProvider);
    final bankDetails = await walletService.getBankDetails();
    
    print('🟢 BankDetailsProvider: Bank details loaded successfully');
    return bankDetails;
  } catch (e, stackTrace) {
    print('🔴 BankDetailsProvider: Error loading bank details: $e');
    print('🔴 BankDetailsProvider: Stack trace: $stackTrace');
    return null;
  }
});

// Wallet transactions provider
final walletTransactionsProvider = FutureProvider<List<WalletTransaction>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw Exception('User not authenticated');
  }

  print('🔵 WalletTransactionsProvider: Fetching transactions');
  
  try {
    final walletService = ref.watch(walletServiceProvider);
    final transactions = await walletService.getTransactions(limit: 50);
    
    print('🟢 WalletTransactionsProvider: ${transactions.length} transactions loaded');
    return transactions;
  } catch (e, stackTrace) {
    print('🔴 WalletTransactionsProvider: Error loading transactions: $e');
    print('🔴 WalletTransactionsProvider: Stack trace: $stackTrace');
    rethrow;
  }
});

// Withdrawal request state provider
final withdrawalNotifierProvider = StateNotifierProvider<WithdrawalNotifier, WithdrawalState>(
  (ref) => WithdrawalNotifier(ref.watch(walletServiceProvider)),
);

enum WithdrawalStatus { idle, loading, success, error }

class WithdrawalState {
  final WithdrawalStatus status;
  final String? message;
  final String? withdrawalId;

  WithdrawalState({
    this.status = WithdrawalStatus.idle,
    this.message,
    this.withdrawalId,
  });

  WithdrawalState copyWith({
    WithdrawalStatus? status,
    String? message,
    String? withdrawalId,
  }) {
    return WithdrawalState(
      status: status ?? this.status,
      message: message ?? this.message,
      withdrawalId: withdrawalId ?? this.withdrawalId,
    );
  }
}

class WithdrawalNotifier extends StateNotifier<WithdrawalState> {
  final WalletService _walletService;

  WithdrawalNotifier(this._walletService) : super(WithdrawalState());

  Future<void> createWithdrawal({
    required double amount,
    required String bankAccountNumber,
    required String bankIfscCode,
    required String bankAccountHolderName,
  }) async {
    state = state.copyWith(status: WithdrawalStatus.loading);

    try {
      final withdrawalId = await _walletService.createWithdrawalRequest(
        amount: amount,
        bankAccountNumber: bankAccountNumber,
        bankIfscCode: bankIfscCode,
        bankAccountHolderName: bankAccountHolderName,
      );

      state = state.copyWith(
        status: WithdrawalStatus.success,
        message: 'Withdrawal request submitted successfully',
        withdrawalId: withdrawalId,
      );
    } catch (e) {
      state = state.copyWith(
        status: WithdrawalStatus.error,
        message: e.toString(),
      );
    }
  }

  void reset() {
    state = WithdrawalState();
  }
} 