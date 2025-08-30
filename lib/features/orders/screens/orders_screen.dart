import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import 'package:sylonow_vendor/features/orders/models/order.dart';
import 'package:sylonow_vendor/features/orders/providers/order_provider.dart';
import 'package:sylonow_vendor/features/orders/service/order_service.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Pending',
    'Confirmed',
    'Completed',
    'Cancelled'
  ];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
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
          IconButton(
            icon: const HeroIcon(
              HeroIcons.magnifyingGlass,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = filter == _selectedFilter;
                  final filterData = _getFilterData(filter);

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? filterData['color'].withOpacity(0.15)
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? filterData['color']
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              HeroIcon(
                                filterData['icon'],
                                size: 16,
                                color: isSelected
                                    ? filterData['color']
                                    : Theme.of(context).colorScheme.onSurface,
                                style: isSelected
                                    ? HeroIconStyle.solid
                                    : HeroIconStyle.outline,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected
                                      ? filterData['color']
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Orders List
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final ordersAsync = ref.watch(ordersProvider(_selectedFilter));
                return ordersAsync.when(
                  data: (orders) {
                    // Apply search filter
                    final filteredOrders = _searchQuery.isEmpty
                        ? orders
                        : orders.where((order) {
                            final query = _searchQuery.toLowerCase();
                            return order.id.toLowerCase().contains(query) ||
                                order.serviceTitle
                                    .toLowerCase()
                                    .contains(query) ||
                                (order.customerName
                                        ?.toLowerCase()
                                        .contains(query) ??
                                    false) ||
                                (order.customerPhone?.contains(query) ?? false);
                          }).toList();

                    if (filteredOrders.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No ${_selectedFilter.toLowerCase()} orders found'
                                  : 'No orders match your search',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isEmpty
                                  ? (_selectedFilter == 'All'
                                      ? 'Orders from customers will appear here'
                                      : 'No orders with ${_selectedFilter.toLowerCase()} status')
                                  : 'Try searching with different keywords',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            if (_selectedFilter != 'All')
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedFilter = 'All';
                                  });
                                },
                                child: const Text('View All Orders'),
                              ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(ordersProvider);
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          return _buildOrderCard(filteredOrders[index]);
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading orders...'),
                      ],
                    ),
                  ),
                  error: (err, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load orders',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            err.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            ref.invalidate(ordersProvider);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final colors = {
      'pending': Colors.orange,
      'confirmed': Colors.blue,
      'completed': Colors.green,
      'cancelled': Colors.red,
    };
    final statusColor = colors[order.status.toLowerCase()] ?? Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.substring(0, 8)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  toBeginningOfSentenceCase(order.status) ?? order.status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.event,
                  color: Colors.pink,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.serviceTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('E, MMM d - h:mm a').format(order.bookingDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (order.bookingTime != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '⏰ Time: ${order.bookingTime}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    if (order.venueAddress != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '📍 ${order.venueAddress}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          // Customer Information
          if (order.customerName != null || order.customerPhone != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200, width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.blue.shade700),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (order.customerName != null)
                          Text(
                            order.customerName!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        if (order.customerPhone != null)
                          Text(
                            order.customerPhone!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade700,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (order.customerPhone != null)
                    IconButton(
                      icon: Icon(Icons.phone,
                          size: 16, color: Colors.blue.shade700),
                      onPressed: () {
                        // TODO: Implement phone call functionality
                      },
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 24, minHeight: 24),
                    ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${order.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (order.paymentStatus != null)
                    Text(
                      'Payment: ${order.paymentStatus}',
                      style: TextStyle(
                        fontSize: 11,
                        color: order.paymentStatus == 'completed'
                            ? Colors.green.shade600
                            : Colors.orange.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  if (order.status == 'pending') ...[
                    _buildActionButton('Accept', Colors.green, Colors.white,
                        () {
                      _showStatusUpdateDialog(
                          order.id,
                          'confirmed',
                          'Accept this order?',
                          'The order will be confirmed and the customer will be notified.');
                    }),
                    const SizedBox(width: 8),
                    _buildActionButton('Reject', Colors.red, Colors.white, () {
                      _showStatusUpdateDialog(
                          order.id,
                          'cancelled',
                          'Reject this order?',
                          'The order will be cancelled and the customer will be notified.');
                    }),
                  ] else if (order.status == 'confirmed') ...[
                    _buildActionButton(
                        'Mark Complete', Colors.blue, Colors.white, () {
                      _showStatusUpdateDialog(
                          order.id,
                          'completed',
                          'Mark order as completed?',
                          'This action cannot be undone. Make sure the service has been delivered.');
                    }),
                    const SizedBox(width: 8),
                    _buildActionButton(
                        'Cancel', Colors.grey.shade600, Colors.white, () {
                      _showStatusUpdateDialog(
                          order.id,
                          'cancelled',
                          'Cancel this order?',
                          'The order will be cancelled and the customer will be notified.');
                    }),
                  ] else if (order.status == 'completed') ...[
                    _buildActionButton('Completed ✓', Colors.green.shade300,
                        Colors.white, null,
                        isDisabled: true),
                  ] else if (order.status == 'cancelled') ...[
                    _buildActionButton(
                        'Cancelled', Colors.red.shade300, Colors.white, null,
                        isDisabled: true),
                  ] else ...[
                    _buildActionButton(
                        'View Details', Colors.pink, Colors.white, () {
                      _showOrderDetails(order);
                    }),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color backgroundColor, Color textColor,
      VoidCallback? onPressed,
      {bool isDisabled = false}) {
    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(
      String orderId, String status, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateOrderStatus(orderId, status);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _updateOrderStatus(String orderId, String status) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('Updating order status...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      await ref.read(orderServiceProvider).updateBookingStatus(
            bookingId: orderId,
            status: status,
          );

      // Refresh the orders list
      ref.invalidate(ordersProvider);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order ${status.toLowerCase()} successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Clear loading snackbar and show error
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _updateOrderStatus(orderId, status),
            ),
          ),
        );
      }
    }
  }

  Map<String, dynamic> _getFilterData(String filter) {
    switch (filter.toLowerCase()) {
      case 'all':
        return {'icon': HeroIcons.listBullet, 'color': AppTheme.primaryColor};
      case 'pending':
        return {'icon': HeroIcons.clock, 'color': AppTheme.warningColor};
      case 'confirmed':
        return {'icon': HeroIcons.checkBadge, 'color': AppTheme.accentBlue};
      case 'completed':
        return {'icon': HeroIcons.checkCircle, 'color': AppTheme.successColor};
      case 'cancelled':
        return {'icon': HeroIcons.xCircle, 'color': AppTheme.errorColor};
      default:
        return {
          'icon': HeroIcons.listBullet,
          'color': AppTheme.textSecondaryColor
        };
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Search Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Enter order ID, customer name...',
            prefixIcon: HeroIcon(HeroIcons.magnifyingGlass),
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = '';
              });
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = _searchController.text;
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Order ID', '#${order.id.substring(0, 8)}'),
                  _buildDetailRow('Service', order.serviceTitle),
                  _buildDetailRow('Status', order.status.toUpperCase()),
                  _buildDetailRow('Booking Date',
                      DateFormat('MMM d, yyyy').format(order.bookingDate)),
                  if (order.bookingTime != null)
                    _buildDetailRow('Booking Time', order.bookingTime!),
                  if (order.durationHours != null)
                    _buildDetailRow('Duration', '${order.durationHours} hours'),
                  _buildDetailRow('Total Amount',
                      '₹${order.totalAmount.toStringAsFixed(2)}'),
                  if (order.paymentStatus != null)
                    _buildDetailRow('Payment Status', order.paymentStatus!),
                  if (order.advanceAmount != null && order.advanceAmount! > 0)
                    _buildDetailRow('Advance Amount',
                        '₹${order.advanceAmount!.toStringAsFixed(2)}'),
                  if (order.remainingAmount != null &&
                      order.remainingAmount! > 0)
                    _buildDetailRow('Remaining Amount',
                        '₹${order.remainingAmount!.toStringAsFixed(2)}'),
                  const Divider(height: 24),
                  if (order.customerName != null) ...[
                    const Text(
                      'Customer Information',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Name', order.customerName!),
                    if (order.customerPhone != null)
                      _buildDetailRow('Phone', order.customerPhone!),
                    if (order.customerEmail != null)
                      _buildDetailRow('Email', order.customerEmail!),
                    const SizedBox(height: 16),
                  ],
                  if (order.venueAddress != null) ...[
                    const Text(
                      'Venue Information',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Address', order.venueAddress!,
                        multiline: true),
                    const SizedBox(height: 16),
                  ],
                  if (order.specialRequirements != null) ...[
                    const Text(
                      'Special Requirements',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow('Requirements', order.specialRequirements!,
                        multiline: true),
                    const SizedBox(height: 16),
                  ],
                  if (order.createdAt != null) ...[
                    const Text(
                      'Timeline',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                        'Order Created',
                        DateFormat('MMM d, yyyy - h:mm a')
                            .format(order.createdAt!)),
                    if (order.confirmedAt != null)
                      _buildDetailRow(
                          'Confirmed',
                          DateFormat('MMM d, yyyy - h:mm a')
                              .format(order.confirmedAt!)),
                    if (order.completedAt != null)
                      _buildDetailRow(
                          'Completed',
                          DateFormat('MMM d, yyyy - h:mm a')
                              .format(order.completedAt!)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment:
            multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
