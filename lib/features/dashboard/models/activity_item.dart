import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_item.freezed.dart';

enum ActivityType {
  booking,
  payment,
  withdrawal,
  serviceListing,
  documentVerification,
  withdrawalRequest,
}

@freezed
class ActivityItem with _$ActivityItem {
  const factory ActivityItem({
    required String id,
    required ActivityType type,
    required String title,
    required String subtitle,
    required DateTime timestamp,
    required IconData icon,
    required Color iconColor,
    String? amount,
    String? status,
    String? referenceId,
  }) = _ActivityItem;
}

extension ActivityItemExtension on ActivityItem {
  String get displayStatus {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'pending':
        return 'Pending';
      case 'verified':
        return 'Verified';
      case 'rejected':
        return 'Rejected';
      default:
        return status ?? 'New';
    }
  }

  Color get statusColor {
    switch (status?.toLowerCase()) {
      case 'confirmed':
      case 'completed':
      case 'verified':
        return const Color(0xFF10B981); // Green
      case 'pending':
        return const Color(0xFFF59E0B); // Orange
      case 'rejected':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }
} 