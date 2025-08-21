import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    @JsonKey(name: 'vendor_id') required String vendorId,
    @JsonKey(name: 'available_balance') required double availableBalance,
    @JsonKey(name: 'pending_balance') required double pendingBalance,
    @JsonKey(name: 'total_balance') required double totalBalance,
    @JsonKey(name: 'total_earned') required double totalEarned,
    @JsonKey(name: 'total_withdrawn') required double totalWithdrawn,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
} 