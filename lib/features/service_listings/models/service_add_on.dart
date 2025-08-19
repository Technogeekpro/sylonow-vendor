import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_add_on.freezed.dart';
part 'service_add_on.g.dart';

@freezed
class ServiceAddOn with _$ServiceAddOn {
  const factory ServiceAddOn({
    String? id,
    @JsonKey(name: 'service_listing_id') required String serviceListingId,
    required String name,
    @JsonKey(name: 'original_price') required double originalPrice,
    @JsonKey(name: 'discount_price') double? discountPrice,
    String? description,
    @Default([]) List<String> images,
    @Default('add_on') String type, // add_on, upgrade, accessory
    @Default('piece') String unit, // piece, hour, set, kg, meter, liter
    @Default(0) int stock,
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ServiceAddOn;

  factory ServiceAddOn.fromJson(Map<String, dynamic> json) => _$ServiceAddOnFromJson(json);
}

// Extension for computed properties
extension ServiceAddOnExtension on ServiceAddOn {
  /// Get the effective price (discount price if available, otherwise original price)
  double get effectivePrice => (discountPrice != null && discountPrice! > 0) ? discountPrice! : originalPrice;
  
  /// Check if the add-on has a discount
  bool get hasDiscount => discountPrice != null && discountPrice! > 0 && discountPrice! < originalPrice;
  
  /// Calculate discount percentage
  int get discountPercentage {
    if (!hasDiscount) return 0;
    return ((originalPrice - discountPrice!) / originalPrice * 100).round();
  }
  
  /// Check if the add-on is in stock
  bool get inStock => stock > 0;
  
  /// Check if the add-on is available and in stock
  bool get canBeOrdered => isAvailable && (stock > 0 || stock == -1); // -1 means unlimited stock
  
  /// Format price for display
  String get formattedOriginalPrice => '₹${originalPrice.toStringAsFixed(0)}';
  
  /// Format discount price for display
  String get formattedDiscountPrice => discountPrice != null ? '₹${discountPrice!.toStringAsFixed(0)}' : '';
  
  /// Format effective price for display
  String get formattedEffectivePrice => '₹${effectivePrice.toStringAsFixed(0)}';
  
  /// Get stock status text
  String get stockStatusText {
    if (stock == -1) return 'In Stock';
    if (stock == 0) return 'Out of Stock';
    if (stock <= 5) return 'Limited Stock ($stock left)';
    return 'In Stock';
  }
  
  /// Get type display name
  String get typeDisplayName {
    switch (type) {
      case 'add_on':
        return 'Add-on';
      case 'upgrade':
        return 'Upgrade';
      case 'accessory':
        return 'Accessory';
      default:
        return 'Add-on';
    }
  }
  
  /// Get unit display name
  String get unitDisplayName {
    switch (unit) {
      case 'piece':
        return stock == 1 ? 'piece' : 'pieces';
      case 'hour':
        return stock == 1 ? 'hour' : 'hours';
      case 'set':
        return stock == 1 ? 'set' : 'sets';
      case 'kg':
        return 'kg';
      case 'meter':
        return stock == 1 ? 'meter' : 'meters';
      case 'liter':
        return stock == 1 ? 'liter' : 'liters';
      default:
        return unit;
    }
  }
}