// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletTransactionsHash() =>
    r'f4f36049e2aaeb05e98506b964938e4ee05770e6';

/// See also [WalletTransactions].
@ProviderFor(WalletTransactions)
final walletTransactionsProvider = AutoDisposeAsyncNotifierProvider<
    WalletTransactions, List<WalletTransaction>>.internal(
  WalletTransactions.new,
  name: r'walletTransactionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletTransactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WalletTransactions
    = AutoDisposeAsyncNotifier<List<WalletTransaction>>;
String _$recentWalletTransactionsHash() =>
    r'ac4fddc28badf00ee404f39f98ee35c81736b6e0';

/// See also [RecentWalletTransactions].
@ProviderFor(RecentWalletTransactions)
final recentWalletTransactionsProvider = AutoDisposeAsyncNotifierProvider<
    RecentWalletTransactions, List<WalletTransaction>>.internal(
  RecentWalletTransactions.new,
  name: r'recentWalletTransactionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentWalletTransactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentWalletTransactions
    = AutoDisposeAsyncNotifier<List<WalletTransaction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
