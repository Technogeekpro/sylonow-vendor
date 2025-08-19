import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/supabase_service.dart';

class CakeTab extends StatefulWidget {
  const CakeTab({super.key});

  @override
  State<CakeTab> createState() => _CakeTabState();
}

class _CakeTabState extends State<CakeTab> {
  List<Map<String, dynamic>> _cakes = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCakes();
  }

  Future<void> _loadCakes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final cakes = await SupabaseService.getCakes();
      setState(() {
        _cakes = cakes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        children: [
          // Header Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.cake,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cake Add-ons',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage your cake offerings for theater celebrations',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Cakes List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState()
                    : _cakes.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _loadCakes,
                            child: ListView.builder(
                              itemCount: _cakes.length,
                              itemBuilder: (context, index) {
                                final cake = _cakes[index];
                                return _buildCakeCard(cake, index);
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
              Icons.cake_outlined,
              size: 60,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Cakes Added',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start by adding your first cake offering',
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

  Widget _buildCakeCard(Map<String, dynamic> cake, int index) {
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
                    Icons.cake,
                    size: 48,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cake['isAvailable'] 
                          ? AppTheme.successColor 
                          : AppTheme.errorColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cake['isAvailable'] ? 'Available' : 'Unavailable',
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
                        cake['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        cake['category'].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  cake['description'],
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
                            Text(
                              '₹${cake['discountedPrice']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '₹${cake['price']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondaryColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${(((cake['price'] - cake['discountedPrice']) / cake['price']) * 100).round()}% OFF',
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
                          onPressed: () => _editCake(index),
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _toggleAvailability(index),
                          icon: Icon(
                            cake['isAvailable'] 
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: cake['isAvailable'] 
                                ? AppTheme.errorColor
                                : AppTheme.successColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _deleteCake(index),
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

  void _editCake(int index) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit cake functionality coming soon'),
      ),
    );
  }

  void _toggleAvailability(int index) {
    setState(() {
      _cakes[index]['isAvailable'] = !_cakes[index]['isAvailable'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cake ${_cakes[index]['isAvailable'] ? 'enabled' : 'disabled'}',
        ),
      ),
    );
  }

  Future<void> _deleteCakeFromSupabase(String id) async {
    try {
      await SupabaseService.deleteCake(id);
      _loadCakes(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cake deleted successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete cake: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _deleteCake(int index) {
    final cake = _cakes[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cake'),
        content: Text('Are you sure you want to delete "${cake['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (cake['id'] != null) {
                _deleteCakeFromSupabase(cake['id']);
              } else {
                setState(() {
                  _cakes.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cake deleted successfully'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
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

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load cakes',
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error ?? 'Unknown error occurred',
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadCakes,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}