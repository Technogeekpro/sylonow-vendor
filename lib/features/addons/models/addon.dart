import 'package:freezed_annotation/freezed_annotation.dart';

part 'addon.freezed.dart';
part 'addon.g.dart';

@freezed
class Addon with _$Addon {
  const factory Addon({
    required String id,
    @JsonKey(name: 'vendor_id') required String vendorId,
    @JsonKey(name: 'theater_id') String? theaterId,
    required String name,
    String? description,
    @JsonKey(name: 'image_url') String? imageUrl,
    @Default(0.0) double price,
    @Default('cake') String category,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Addon;

  factory Addon.fromJson(Map<String, dynamic> json) => _$AddonFromJson(json);
}