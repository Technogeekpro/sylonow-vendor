import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/supabase_service.dart';

class SpecialServiceTab extends StatefulWidget {
  const SpecialServiceTab({super.key});

  @override
  State<SpecialServiceTab> createState() => _SpecialServiceTabState();
}

class _SpecialServiceTabState extends State<SpecialServiceTab> {
  List<Map<String, dynamic>> _specialServices = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSpecialServices();
  }

  Future<void> _loadSpecialServices() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final services = await SupabaseService.getSpecialServices();
      setState(() {
        _specialServices = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteSpecialService(String id) async {
    try {
      await SupabaseService.deleteSpecialService(id);
      _loadSpecialServices(); // Refresh the list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Special service deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete special service: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Special Services',
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
                    : _specialServices.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _loadSpecialServices,
                            child: ListView.builder(
                              itemCount: _specialServices.length,
                              itemBuilder: (context, index) {
                                final service = _specialServices[index];
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
        title: const Text('Delete Special Service'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteSpecialService(id);
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
            'Failed to load special services',
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
            onPressed: _loadSpecialServices,
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
            Icons.miscellaneous_services,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No special services available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some special services to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}