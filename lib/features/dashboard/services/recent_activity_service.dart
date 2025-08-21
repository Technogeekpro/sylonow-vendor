import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/activity_item.dart';

class RecentActivityService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ActivityItem>> getRecentActivities(String vendorId) async {
    try {
      final List<ActivityItem> activities = [];

      // Fetch recent bookings
      final bookingActivities = await _fetchBookingActivities(vendorId);
      activities.addAll(bookingActivities);

      // Fetch recent wallet transactions
      final walletActivities = await _fetchWalletActivities(vendorId);
      activities.addAll(walletActivities);

      // Fetch recent service listings
      final serviceActivities = await _fetchServiceListingActivities(vendorId);
      activities.addAll(serviceActivities);

      // Fetch recent document verifications
      final documentActivities = await _fetchDocumentActivities(vendorId);
      activities.addAll(documentActivities);

      // Fetch recent withdrawal requests
      final withdrawalActivities = await _fetchWithdrawalActivities(vendorId);
      activities.addAll(withdrawalActivities);

      // Sort by timestamp (newest first) and return top 10
      activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return activities.take(10).toList();
    } catch (e) {
      print('Error fetching recent activities: $e');
      return [];
    }
  }

  Future<List<ActivityItem>> _fetchBookingActivities(String vendorId) async {
    final response = await _supabase
        .from('bookings')
        .select('id, booking_date, status, total_amount, created_at, service_listings(title)')
        .eq('vendor_id', vendorId)
        .gte('created_at', DateTime.now().subtract(const Duration(days: 7)).toIso8601String())
        .order('created_at', ascending: false)
        .limit(5);

    return response.map<ActivityItem>((booking) {
      final serviceTitle = booking['service_listings']?['title'] ?? 'Service';
      final status = booking['status'] as String;
      final amount = booking['total_amount']?.toString() ?? '0';

      return ActivityItem(
        id: 'booking_${booking['id']}',
        type: ActivityType.booking,
        title: _getBookingTitle(status, serviceTitle),
        subtitle: _getBookingSubtitle(status, booking['booking_date']),
        timestamp: DateTime.parse(booking['created_at']),
        icon: _getBookingIcon(status),
        iconColor: _getBookingColor(status),
        amount: amount,
        status: status,
        referenceId: booking['id'],
      );
    }).toList();
  }

  Future<List<ActivityItem>> _fetchWalletActivities(String vendorId) async {
    final response = await _supabase
        .from('wallet_transactions')
        .select('id, transaction_type, amount, status, description, created_at')
        .eq('vendor_id', vendorId)
        .gte('created_at', DateTime.now().subtract(const Duration(days: 7)).toIso8601String())
        .order('created_at', ascending: false)
        .limit(5);

    return response.map<ActivityItem>((transaction) {
      final type = transaction['transaction_type'] as String;
      final amount = transaction['amount']?.toString() ?? '0';
      final status = transaction['status'] as String;

      return ActivityItem(
        id: 'wallet_${transaction['id']}',
        type: _getWalletActivityType(type),
        title: _getWalletTitle(type, amount),
        subtitle: _getWalletSubtitle(type, status),
        timestamp: DateTime.parse(transaction['created_at']),
        icon: _getWalletIcon(type),
        iconColor: _getWalletColor(type, status),
        amount: amount,
        status: status,
        referenceId: transaction['id'],
      );
    }).toList();
  }

  Future<List<ActivityItem>> _fetchServiceListingActivities(String vendorId) async {
    final response = await _supabase
        .from('service_listings')
        .select('id, title, category, is_active, is_featured, created_at, updated_at')
        .eq('vendor_id', vendorId)
        .gte('created_at', DateTime.now().subtract(const Duration(days: 7)).toIso8601String())
        .order('created_at', ascending: false)
        .limit(3);

    return response.map<ActivityItem>((listing) {
      final title = listing['title'] as String;
      final category = listing['category'] as String? ?? '';
      final isFeatured = listing['is_featured'] as bool? ?? false;

      return ActivityItem(
        id: 'service_${listing['id']}',
        type: ActivityType.serviceListing,
        title: 'New service "$title" listed',
        subtitle: isFeatured ? '$category • Featured' : category,
        timestamp: DateTime.parse(listing['created_at']),
        icon: Icons.list_alt_rounded,
        iconColor: const Color(0xFF3B82F6), // Blue
        status: 'active',
        referenceId: listing['id'],
      );
    }).toList();
  }

  Future<List<ActivityItem>> _fetchDocumentActivities(String vendorId) async {
    final response = await _supabase
        .from('vendor_documents')
        .select('id, document_type, verification_status, verified_at, updated_at')
        .eq('vendor_id', vendorId)
        .gte('updated_at', DateTime.now().subtract(const Duration(days: 7)).toIso8601String())
        .order('updated_at', ascending: false)
        .limit(3);

    return response.map<ActivityItem>((document) {
      final docType = document['document_type'] as String;
      final status = document['verification_status'] as String;

      return ActivityItem(
        id: 'document_${document['id']}',
        type: ActivityType.documentVerification,
        title: '${_formatDocumentType(docType)} ${_getDocumentStatusText(status)}',
        subtitle: _getDocumentSubtitle(status),
        timestamp: DateTime.parse(document['updated_at']),
        icon: _getDocumentIcon(status),
        iconColor: _getDocumentColor(status),
        status: status,
        referenceId: document['id'],
      );
    }).toList();
  }

  Future<List<ActivityItem>> _fetchWithdrawalActivities(String vendorId) async {
    final response = await _supabase
        .from('withdrawal_requests')
        .select('id, amount, status, created_at, processed_at')
        .eq('vendor_id', vendorId)
        .gte('created_at', DateTime.now().subtract(const Duration(days: 7)).toIso8601String())
        .order('created_at', ascending: false)
        .limit(3);

    return response.map<ActivityItem>((withdrawal) {
      final amount = withdrawal['amount']?.toString() ?? '0';
      final status = withdrawal['status'] as String;

      return ActivityItem(
        id: 'withdrawal_${withdrawal['id']}',
        type: ActivityType.withdrawalRequest,
        title: 'Withdrawal request ₹$amount',
        subtitle: _getWithdrawalSubtitle(status),
        timestamp: DateTime.parse(withdrawal['created_at']),
        icon: _getWithdrawalIcon(status),
        iconColor: _getWithdrawalColor(status),
        amount: amount,
        status: status,
        referenceId: withdrawal['id'],
      );
    }).toList();
  }

  // Helper methods for bookings
  String _getBookingTitle(String status, String serviceTitle) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Booking confirmed for $serviceTitle';
      case 'completed':
        return 'Booking completed for $serviceTitle';
      case 'pending':
        return 'New booking for $serviceTitle';
      case 'cancelled':
        return 'Booking cancelled for $serviceTitle';
      default:
        return 'Booking update for $serviceTitle';
    }
  }

  String _getBookingSubtitle(String status, String? bookingDate) {
    if (bookingDate != null) {
      final date = DateTime.parse(bookingDate);
      final now = DateTime.now();
      final difference = date.difference(now).inDays;
      
      if (difference == 0) {
        return 'Today';
      } else if (difference == 1) {
        return 'Tomorrow';
      } else if (difference > 1) {
        return 'In $difference days';
      } else {
        return '${difference.abs()} days ago';
      }
    }
    return status.toUpperCase();
  }

  IconData _getBookingIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.event_available_rounded;
      case 'completed':
        return Icons.check_circle_rounded;
      case 'pending':
        return Icons.schedule_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Color _getBookingColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        return const Color(0xFF10B981); // Green
      case 'pending':
        return const Color(0xFFF59E0B); // Orange
      case 'cancelled':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  // Helper methods for wallet transactions
  ActivityType _getWalletActivityType(String type) {
    return type.contains('withdrawal') ? ActivityType.withdrawal : ActivityType.payment;
  }

  String _getWalletTitle(String type, String amount) {
    switch (type.toLowerCase()) {
      case 'order_payment':
        return 'Payment received ₹$amount';
      case 'withdrawal':
        return 'Withdrawal ₹$amount';
      case 'order_refund':
        return 'Refund processed ₹$amount';
      case 'bonus':
        return 'Bonus earned ₹$amount';
      default:
        return 'Transaction ₹$amount';
    }
  }

  String _getWalletSubtitle(String type, String status) {
    switch (type.toLowerCase()) {
      case 'order_payment':
        return status == 'completed' ? 'Added to wallet' : 'Payment pending';
      case 'withdrawal':
        return status == 'completed' ? 'Transferred to bank' : 'Processing withdrawal';
      default:
        return status.toUpperCase();
    }
  }

  IconData _getWalletIcon(String type) {
    switch (type.toLowerCase()) {
      case 'order_payment':
        return Icons.payments_rounded;
      case 'withdrawal':
        return Icons.money_off_rounded;
      case 'order_refund':
        return Icons.replay_rounded;
      case 'bonus':
        return Icons.star_rounded;
      default:
        return Icons.account_balance_wallet_rounded;
    }
  }

  Color _getWalletColor(String type, String status) {
    if (status.toLowerCase() == 'failed') {
      return const Color(0xFFEF4444); // Red
    }
    
    switch (type.toLowerCase()) {
      case 'order_payment':
      case 'bonus':
        return const Color(0xFF10B981); // Green
      case 'withdrawal':
        return const Color(0xFF3B82F6); // Blue
      case 'order_refund':
        return const Color(0xFFF59E0B); // Orange
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  // Helper methods for documents
  String _formatDocumentType(String docType) {
    switch (docType.toLowerCase()) {
      case 'identity_aadhaar_front':
        return 'Aadhaar front';
      case 'identity_aadhaar_back':
        return 'Aadhaar back';
      case 'identity_pan':
        return 'PAN card';
      case 'business_license':
        return 'Business license';
      default:
        return docType.replaceAll('_', ' ');
    }
  }

  String _getDocumentStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return 'verified';
      case 'rejected':
        return 'rejected';
      case 'pending':
        return 'under review';
      default:
        return status;
    }
  }

  String _getDocumentSubtitle(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return 'Document approved';
      case 'rejected':
        return 'Needs resubmission';
      case 'pending':
        return 'Verification in progress';
      default:
        return status.toUpperCase();
    }
  }

  IconData _getDocumentIcon(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return Icons.verified_rounded;
      case 'rejected':
        return Icons.error_rounded;
      case 'pending':
        return Icons.pending_rounded;
      default:
        return Icons.description_rounded;
    }
  }

  Color _getDocumentColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return const Color(0xFF10B981); // Green
      case 'rejected':
        return const Color(0xFFEF4444); // Red
      case 'pending':
        return const Color(0xFFF59E0B); // Orange
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  // Helper methods for withdrawals
  String _getWithdrawalSubtitle(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Awaiting approval';
      case 'approved':
        return 'Processing transfer';
      case 'completed':
        return 'Transfer completed';
      case 'rejected':
        return 'Request declined';
      default:
        return status.toUpperCase();
    }
  }

  IconData _getWithdrawalIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty_rounded;
      case 'approved':
        return Icons.check_rounded;
      case 'completed':
        return Icons.done_all_rounded;
      case 'rejected':
        return Icons.close_rounded;
      default:
        return Icons.money_off_rounded;
    }
  }

  Color _getWithdrawalColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981); // Green
      case 'approved':
        return const Color(0xFF3B82F6); // Blue
      case 'pending':
        return const Color(0xFFF59E0B); // Orange
      case 'rejected':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }
} 