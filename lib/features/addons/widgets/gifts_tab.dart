import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/supabase_service.dart';

class GiftsTab extends StatefulWidget {
  const GiftsTab({super.key});

  @override
  State<GiftsTab> createState() => _GiftsTabState();
}

class _GiftsTabState extends State<GiftsTab> {
  List<Map<String, dynamic>> _gifts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGifts();
  }

  Future<void> _loadGifts() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final gifts = await SupabaseService.getGifts();
      setState(() {
        _gifts = gifts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteGiftFromSupabase(String id) async {
    try {
      await SupabaseService.deleteGift(id);
      _loadGifts(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gift deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete gift: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        children: [
          // Gifts List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState()
                    : _gifts.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _loadGifts,
                            child: ListView.builder(
                              itemCount: _gifts.length,
                              itemBuilder: (context, index) {
                                final gift = _gifts[index];
                                return _buildGiftCard(gift, index);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: AppTheme.borderColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_giftcard_outlined,
              size: 60,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Gifts Added',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start by adding your first gift offering',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load gifts',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error occurred',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadGifts,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildGiftCard(Map<String, dynamic> gift, int index) {
    final price = gift['price'] != null ? double.tryParse(gift['price'].toString()) ?? 0.0 : 0.0;
    final discountedPrice = gift['discounted_price'] != null ? double.tryParse(gift['discounted_price'].toString()) : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        children: [
          // Image placeholder
          Container(
            height: 150,
            decoration: const BoxDecoration(
              color: AppTheme.borderColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.card_giftcard,
                    size: 48,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: gift['isAvailable']
                          ? AppTheme.successColor
                          : AppTheme.errorColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      gift['isAvailable'] ? 'Available' : 'Unavailable',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        gift['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        gift['category'].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.accentTeal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  gift['description'],
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (discountedPrice != null) ...[
                              Text(
                                '₹${discountedPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.accentTeal,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹${price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondaryColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ] else
                              Text(
                                '₹${price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.accentTeal,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${(((price - discountedPrice!) / price) * 100).round()}% OFF',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.successColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Actions
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _editGift(index),
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: AppTheme.accentTeal,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _toggleAvailability(index),
                          icon: Icon(
                            gift['isAvailable']
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: gift['isAvailable']
                                ? AppTheme.errorColor
                                : AppTheme.successColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showDeleteConfirmation(gift['id'], gift['name'] ?? 'this gift'),
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: AppTheme.errorColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editGift(int index) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit gift functionality coming soon'),
      ),
    );
  }

  void _toggleAvailability(int index) {
    setState(() {
      _gifts[index]['isAvailable'] = !_gifts[index]['isAvailable'];
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Gift ${_gifts[index]['isAvailable'] ? 'enabled' : 'disabled'}',
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Gift'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteGiftFromSupabase(id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteGift(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Gift'),
        content:
            Text('Are you sure you want to delete "${_gifts[index]['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _gifts.removeAt(index);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gift deleted successfully'),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}
