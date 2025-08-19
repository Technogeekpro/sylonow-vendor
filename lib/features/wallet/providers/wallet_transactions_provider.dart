import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/wallet_transaction.dart';
import '../services/wallet_service.dart';

part 'wallet_transactions_provider.g.dart';

@riverpod
class WalletTransactions extends _$WalletTransactions {
  @override
  Future<List<WalletTransaction>> build() async {
    return await _fetchTransactions();
  }

  Future<List<WalletTransaction>> _fetchTransactions() async {
    try {
      final walletService = ref.read(walletServiceProvider);
      return await walletService.getTransactions(limit: 50);
    } catch (e) {
      print('🔴 WalletTransactionsProvider: Error fetching transactions: $e');
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTransactions());
  }

  Future<void> loadMore() async {
    if (state.isLoading) return;
    
    final currentTransactions = state.value ?? [];
    try {
      final walletService = ref.read(walletServiceProvider);
      final newTransactions = await walletService.getTransactions(
        limit: 20,
        offset: currentTransactions.length,
      );
      
      if (newTransactions.isNotEmpty) {
        state = AsyncValue.data([...currentTransactions, ...newTransactions]);
      }
    } catch (e) {
      print('🔴 WalletTransactionsProvider: Error loading more transactions: $e');
    }
  }
}

@riverpod
class RecentWalletTransactions extends _$RecentWalletTransactions {
  @override
  Future<List<WalletTransaction>> build() async {
    try {
      final walletService = ref.read(walletServiceProvider);
      return await walletService.getTransactions(limit: 5);
    } catch (e) {
      print('🔴 RecentWalletTransactionsProvider: Error fetching recent transactions: $e');
      throw Exception('Failed to fetch recent transactions: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final walletService = ref.read(walletServiceProvider);
      return await walletService.getTransactions(limit: 5);
    });
  }
}