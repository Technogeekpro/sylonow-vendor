import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/supabase_service.dart';

class ExtraSpecialServiceTab extends StatefulWidget {
  const ExtraSpecialServiceTab({super.key});

  @override
  State<ExtraSpecialServiceTab> createState() => _ExtraSpecialServiceTabState();
}

class _ExtraSpecialServiceTabState extends State<ExtraSpecialServiceTab> {
  List<Map<String, dynamic>> _extraSpecialServices = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadExtraSpecialServices();
  }

  Future<void> _loadExtraSpecialServices() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final services = await SupabaseService.getExtraSpecialServices();
      setState(() {
        _extraSpecialServices = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteExtraSpecialService(String id) async {
    try {
      await SupabaseService.deleteExtraSpecialService(id);
      _loadExtraSpecialServices(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Extra special service deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete extra special service: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  final List<Map<String, dynamic>> _sampleData = [
    {
      'name': 'Live Music Performance',
      'price': 8000,
      'discountedPrice': 7200,
      'category': 'extra special services',
      'description': 'Live acoustic performance to enhance your celebration',
      'isAvailable': true,
    },
    {
      'name': 'Personal Butler Service',
      'price': 3000,
      'discountedPrice': 2500,
      'category': 'extra special services',
      'description': 'Dedicated personal service for your comfort',
      'isAvailable': false,
    },
    {
      'name': 'Premium Catering Service',
      'price': 12000,
      'discountedPrice': 10500,
      'category': 'extra special services',
      'description': 'Luxury dining experience with premium ingredients',
      'isAvailable': true,
    },
    {
      'name': 'Celebrity Host Service',
      'price': 25000,
      'discountedPrice': 22000,
      'category': 'extra special services',
      'description': 'Professional celebrity host for your special event',
      'isAvailable': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Extra Special Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState()
                    : _extraSpecialServices.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _loadExtraSpecialServices,
                            child: ListView.builder(
                              itemCount: _extraSpecialServices.length,
                              itemBuilder: (context, index) {
                                final service = _extraSpecialServices[index];
                                return _buildServiceCard(service, index);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, int index) {
    final price = service['price'] != null ? double.tryParse(service['price'].toString()) ?? 0.0 : 0.0;
    final discountedPrice = service['discounted_price'] != null ? double.tryParse(service['discounted_price'].toString()) : null;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service['name'] ?? 'Unnamed Service',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (service['description'] != null)
                        Text(
                          service['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Implement edit functionality
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmation(service['id'], service['name'] ?? 'this service');
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (discountedPrice != null) ...[
                  Text(
                    '₹${discountedPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹${price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ] else
                  Text(
                    '₹${price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                const Spacer(),
                if (service['category'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      service['category'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Extra Special Service'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteExtraSpecialService(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
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
            'Failed to load extra special services',
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
            onPressed: _loadExtraSpecialServices,
            child: const Text('Retry'),
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
          Icon(
            Icons.star_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No extra special services available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Extra special services will appear here once added',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}