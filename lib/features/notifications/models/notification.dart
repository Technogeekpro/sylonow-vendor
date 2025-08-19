import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class VendorNotification with _$VendorNotification {
  const factory VendorNotification({
    required String id,
    @JsonKey(name: 'vendor_id') required String vendorId,
    required String title,
    required String message,
    required String type, // 'booking', 'payment', 'system', 'promotion'
    String? actionData, // JSON string for additional action data
    String? imageUrl,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _VendorNotification;

  factory VendorNotification.fromJson(Map<String, dynamic> json) => 
    _$VendorNotificationFromJson(json);
}

enum NotificationType {
  booking('booking'),
  payment('payment'),
  system('system'),
  promotion('promotion');

  const NotificationType(this.value);
  final String value;
}

extension VendorNotificationX on VendorNotification {
  NotificationType get notificationType {
    switch (type) {
      case 'booking':
        return NotificationType.booking;
      case 'payment':
        return NotificationType.payment;
      case 'system':
        return NotificationType.system;
      case 'promotion':
        return NotificationType.promotion;
      default:
        return NotificationType.system;
    }
  }

  String get relativeTime {
    if (createdAt == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays > 7) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}