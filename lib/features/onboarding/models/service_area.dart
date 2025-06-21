import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_area.freezed.dart';
part 'service_area.g.dart';

@freezed
class ServiceArea with _$ServiceArea {
  const factory ServiceArea({
    required String id,
    @JsonKey(name: 'vendor_id') required String vendorId,
    @JsonKey(name: 'area_name') required String areaName,
    String? city,
    String? state,
    @JsonKey(name: 'postal_code') String? postalCode,
    Map<String, dynamic>? coordinates,
    @JsonKey(name: 'radius_km') double? radiusKm,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ServiceArea;

  factory ServiceArea.fromJson(Map<String, dynamic> json) => _$ServiceAreaFromJson(json);
} 