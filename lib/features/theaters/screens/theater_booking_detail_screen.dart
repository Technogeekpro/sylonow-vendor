import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../models/theater_booking.dart';
import '../providers/theater_booking_provider.dart';
import '../service/theater_booking_service.dart';

class TheaterBookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const TheaterBookingDetailScreen({
    super.key,
    required this.bookingId,
  });

  @override
  ConsumerState<TheaterBookingDetailScreen> createState() => _TheaterBookingDetailScreenState();
}

class _TheaterBookingDetailScreenState extends ConsumerState<TheaterBookingDetailScreen> {
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final bookingAsync = ref.watch(bookingDetailProvider(widget.bookingId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Booking Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          bookingAsync.when(
            data: (booking) => booking != null
                ? PopupMenuButton<String>(
                    icon: const HeroIcon(
                      HeroIcons.ellipsisVertical,
                      color: Colors.white,
                      size: 20,
                    ),
                    onSelected: (value) => _handleMenuAction(value, booking),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'call',
                        child: Row(
                          children: [
                            HeroIcon(HeroIcons.phone, size: 16),
                            SizedBox(width: 8),
                            Text('Call Customer'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'message',
                        child: Row(
                          children: [
                            HeroIcon(HeroIcons.chatBubbleLeft, size: 16),
                            SizedBox(width: 8),
                            Text('Send Message'),
                          ],
                        ),
                      ),
                      if (booking.bookingStatus == 'confirmed')
                        const PopupMenuItem(
                          value: 'cancel',
                          child: Row(
                            children: [
                              HeroIcon(HeroIcons.xCircle, size: 16, color: AppTheme.errorColor),
                              SizedBox(width: 8),
                              Text('Cancel Booking', style: TextStyle(color: AppTheme.errorColor)),
                            ],
                          ),
                        ),
                      if (booking.bookingStatus == 'confirmed')
                        const PopupMenuItem(
                          value: 'complete',
                          child: Row(
                            children: [
                              HeroIcon(HeroIcons.checkCircle, size: 16, color: AppTheme.successColor),
                              SizedBox(width: 8),
                              Text('Mark Completed', style: TextStyle(color: AppTheme.successColor)),
                            ],
                          ),
                        ),
                    ],
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: bookingAsync.when(
        data: (booking) {
          if (booking == null) {
            return _buildNotFound();
          }
          return _buildBookingContent(booking);
        },
        loading: () => _buildLoading(),
        error: (error, stack) => _buildError(error),
      ),
      bottomNavigationBar: bookingAsync.when(
        data: (booking) {
          if (booking == null || !_shouldShowActionButtons(booking)) {
            return null;
          }
          return _buildActionButtons(booking);
        },
        loading: () => null,
        error: (error, stack) => null,
      ),
    );
  }

  Widget _buildBookingContent(TheaterBooking booking) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Theater Images
          _buildTheaterImages(booking),
          const SizedBox(height: 16),
          
          // Booking Status Card
          _buildStatusCard(booking),
          const SizedBox(height: 16),
          
          
          // Booking Information
          _buildBookingInfoCard(booking),
          const SizedBox(height: 16),
          
          // Theater Information
          _buildTheaterInfoCard(booking),
          const SizedBox(height: 16),
          
          // Payment Information
          _buildPaymentInfoCard(booking),
          const SizedBox(height: 16),
          
          // Additional Information
          if (booking.specialRequests != null || booking.celebrationName != null)
            _buildAdditionalInfoCard(booking),
          
          // Add bottom padding to account for action buttons
          if (_shouldShowActionButtons(booking))
            const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTheaterImages(TheaterBooking booking) {
    return FutureBuilder<List<String>>(
      future: _getScreenImages(booking.theaterId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final images = snapshot.data!;
          return Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [AppTheme.cardShadow],
            ),
            child: PageView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    images[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _buildTheaterImagePlaceholder();
                    },
                  ),
                );
              },
            ),
          );
        }
        
        // Fallback to placeholder if no images available
        return _buildTheaterImagePlaceholder();
      }, 
    );
  }
  
  Future<List<String>> _getScreenImages(String theaterId) async {
    try {
      final service = ref.read(theaterBookingServiceProvider);
      final response = await service.getScreenImages(theaterId);
      return response;
    } catch (e) {
      print('🔴 ERROR: Failed to fetch screen images: $e');
      return [];
    }
  }

  Widget _buildTheaterImagePlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withAlpha((255 * 0.8).round()),
            AppTheme.primaryColor,
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeroIcon(
              HeroIcons.buildingOffice2,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              'Theater Images',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Coming Soon',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldShowActionButtons(TheaterBooking booking) {
    // Show accept/reject buttons for confirmed bookings with pending payment
    // OR show QR scanner button for confirmed bookings with paid payment
    return booking.bookingStatus.toLowerCase() == 'confirmed' && 
           (booking.paymentStatus.toLowerCase() == 'pending' || 
            booking.paymentStatus.toLowerCase() == 'paid');
  }

  Widget _buildActionButtons(TheaterBooking booking) {
    final isAwaitingApproval = booking.bookingStatus.toLowerCase() == 'confirmed' && 
                              booking.paymentStatus.toLowerCase() == 'pending';
    final canVerifyBooking = booking.bookingStatus.toLowerCase() == 'confirmed' && 
                            booking.paymentStatus.toLowerCase() == 'paid';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.1).round()),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (isAwaitingApproval) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isUpdating ? null : () => _rejectBooking(booking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isUpdating 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const HeroIcon(HeroIcons.xMark, size: 18),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isUpdating ? null : () => _acceptBooking(booking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isUpdating 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const HeroIcon(HeroIcons.check, size: 18),
                  label: const Text(
                    'Accept',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ] else if (canVerifyBooking) ...[
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isUpdating ? null : () => _openQRScanner(booking),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isUpdating 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const HeroIcon(HeroIcons.qrCode, size: 18),
                  label: const Text(
                    'Scan QR to Complete',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(TheaterBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Booking Status',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatusChip(booking.bookingStatus, large: true),
                    const SizedBox(width: 12),
                    _buildPaymentStatusChip(booking.paymentStatus, large: true),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '₹${_formatNumber(booking.totalAmount)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryColor,
                ),
              ),
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildBookingInfoCard(TheaterBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            HeroIcons.calendar,
            'Date',
            _formatDate(booking.bookingDate),
          ),
          const SizedBox(height: 12),
          
          _buildInfoRow(
            HeroIcons.clock,
            'Time',
            '${_formatTimeTo12Hour(booking.startTime)} - ${_formatTimeTo12Hour(booking.endTime)}',
          ),
          const SizedBox(height: 12),
          
          _buildInfoRow(
            HeroIcons.hashtag,
            'Booking ID',
            booking.id.substring(0, 8).toUpperCase(),
          ),
          const SizedBox(height: 12),
          
          _buildInfoRow(
            HeroIcons.calendar,
            'Booked On',
            _formatDateTime(booking.createdAt ?? DateTime.now()),
          ),
        ],
      ),
    );
  }

  Widget _buildTheaterInfoCard(TheaterBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Theater Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            HeroIcons.buildingOffice,
            'Theater',
            booking.theaterName ?? 'Unknown Theater',
          ),
          const SizedBox(height: 12),
          
          _buildInfoRow(
            HeroIcons.tv,
            'Screen',
            booking.screenName ?? 'Screen ${booking.screenNumber ?? 'Unknown'}',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoCard(TheaterBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              if (booking.paymentStatus == 'pending')
                TextButton(
                  onPressed: _isUpdating ? null : () => _updatePaymentStatus(booking, 'paid'),
                  child: _isUpdating 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Mark as Paid'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildInfoRow(
            HeroIcons.banknotes,
            'Total Amount',
            '₹${_formatNumber(booking.totalAmount)}',
          ),
          const SizedBox(height: 12),
          
          _buildInfoRow(
            HeroIcons.creditCard,
            'Payment Status',
            booking.paymentStatus.toUpperCase(),
          ),
          
          if (booking.paymentId != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              HeroIcons.hashtag,
              'Payment ID',
              booking.paymentId!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoCard(TheaterBooking booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          
          if (booking.celebrationName != null) ...[
            _buildInfoRow(
              HeroIcons.gift,
              'Celebration',
              booking.celebrationName!,
            ),
            const SizedBox(height: 12),
          ],
          
          if (booking.specialRequests != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeroIcon(
                  HeroIcons.chatBubbleLeftEllipsis,
                  size: 20,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Special Requests',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.specialRequests!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(HeroIcons icon, String label, String value, {VoidCallback? onTap}) {
    Widget content = Row(
      children: [
        HeroIcon(
          icon,
          size: 20,
          color: AppTheme.textSecondaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildStatusChip(String status, {bool large = false}) {
    Color color;
    switch (status.toLowerCase()) {
      case 'confirmed':
        color = AppTheme.successColor;
        break;
      case 'cancelled':
        color = AppTheme.errorColor;
        break;
      case 'completed':
        color = AppTheme.primaryColor;
        break;
      case 'no_show':
        color = AppTheme.warningColor;
        break;
      case 'pending':
        color = AppTheme.warningColor;
        break;
      default:
        color = AppTheme.textSecondaryColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((255 * 0.3).round())),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: large ? 12 : 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPaymentStatusChip(String paymentStatus, {bool large = false}) {
    Color color;
    switch (paymentStatus.toLowerCase()) {
      case 'paid':
        color = AppTheme.successColor;
        break;
      case 'pending':
        color = AppTheme.warningColor;
        break;
      case 'failed':
        color = AppTheme.errorColor;
        break;
      case 'refunded':
        color = AppTheme.textSecondaryColor;
        break;
      default:
        color = AppTheme.textSecondaryColor;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((255 * 0.3).round())),
      ),
      child: Text(
        paymentStatus.toUpperCase(),
        style: TextStyle(
          fontSize: large ? 12 : 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HeroIcon(
            HeroIcons.exclamationTriangle,
            size: 48,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load booking details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(bookingDetailProvider(widget.bookingId)),
            icon: const HeroIcon(HeroIcons.arrowPath, size: 16),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const HeroIcon(
            HeroIcons.questionMarkCircle,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'Booking not found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The booking you are looking for does not exist',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.pop(),
            icon: const HeroIcon(HeroIcons.arrowLeft, size: 16),
            label: const Text('Go Back'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, TheaterBooking booking) {
    switch (action) {
      case 'call':
        _makePhoneCall(booking.contactPhone);
        break;
      case 'message':
        _sendMessage(booking.contactPhone);
        break;
      case 'cancel':
        _showCancelDialog(booking);
        break;
      case 'complete':
        _showCompleteDialog(booking);
        break;
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot make phone call'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _sendMessage(String phoneNumber) async {
    final uri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot send message'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _showCancelDialog(TheaterBooking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _updateBookingStatus(booking, 'cancelled');
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompleteDialog(TheaterBooking booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Booking'),
        content: const Text('Mark this booking as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _updateBookingStatus(booking, 'completed');
            },
            child: const Text(
              'Mark Completed',
              style: TextStyle(color: AppTheme.successColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _acceptBooking(TheaterBooking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Booking'),
        content: const Text('Are you sure you want to accept this booking and mark payment as received?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Accept',
              style: TextStyle(color: AppTheme.successColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Mark payment as paid when accepting
      await _updatePaymentStatus(booking, 'paid');
    }
  }

  Future<void> _rejectBooking(TheaterBooking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _updateBookingStatus(booking, 'cancelled');
    }
  }

  Future<void> _updateBookingStatus(TheaterBooking booking, String status) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await ref.read(bookingDetailProvider(widget.bookingId).notifier)
          .updateBookingStatus(booking.id, status);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking ${status == 'cancelled' ? 'cancelled' : 'completed'} successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update booking: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  Future<void> _updatePaymentStatus(TheaterBooking booking, String paymentStatus) async {
    setState(() {
      _isUpdating = true;
    });

    try {
      await ref.read(bookingDetailProvider(widget.bookingId).notifier)
          .updatePaymentStatus(booking.id, paymentStatus);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment status updated successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update payment status: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final bookingDate = DateTime(date.year, date.month, date.day);
    
    if (bookingDate == today) {
      return 'Today';
    } else if (bookingDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatNumber(double number) {
    if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  String _formatTimeTo12Hour(String time24) {
    try {
      final parts = time24.split(':');
      if (parts.length != 2) return time24;
      
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);
      
      String period = hour >= 12 ? 'PM' : 'AM';
      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour = hour - 12;
      }
      
      return '${hour.toString()}:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time24;
    }
  }

  Future<void> _openQRScanner(TheaterBooking booking) async {
    try {
      print('🔍 Opening QR scanner for booking: ${booking.id}');
      
      final result = await context.push<bool>('/qr-scanner/${booking.id}');
      
      if (result == true && mounted) {
        // QR verification was successful, update booking status to completed
        await _updateBookingStatus(booking, 'completed');
      }
    } catch (e) {
      print('🔴 Failed to open QR scanner: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open QR scanner: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}