import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ServicesTab extends StatefulWidget {
  const ServicesTab({super.key});

  @override
  State<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  final List<Map<String, dynamic>> _services = [
    {
      'name': 'Professional Photography',
      'price': 5000,
      'discountedPrice': 4200,
      'category': 'special services',
      'description': 'Capture your special moments with professional photographers',
      'isAvailable': true,
    },
    {
      'name': 'Live Music Performance',
      'price': 8000,
      'discountedPrice': 7200,
      'category': 'extra special services',
      'description': 'Live acoustic performance to enhance your celebration',
      'isAvailable': true,
    },
    {
      'name': 'Balloon Decoration',
      'price': 2500,
      'discountedPrice': 2000,
      'category': 'special services',
      'description': 'Colorful balloon arrangements for festive atmosphere',
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
  ];

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
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.successColor.withOpacity(0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppTheme.successColor,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Add-ons',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Provide premium services for exceptional experiences',
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
          
          // Services List
          Expanded(
            child: _services.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      final service = _services[index];
                      return _buildServiceCard(service, index);
                    },
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
              Icons.star_outline,
              size: 60,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Services Added',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start by adding your first service offering',
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

  Widget _buildServiceCard(Map<String, dynamic> service, int index) {
    final isExtraSpecial = service['category'] == 'extra special services';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppTheme.cardShadow],
        border: isExtraSpecial 
            ? Border.all(color: Colors.amber, width: 2)
            : null,
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
                Center(
                  child: Icon(
                    isExtraSpecial ? Icons.diamond : Icons.star,
                    size: 48,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                if (isExtraSpecial)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.amber, Colors.orange],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.diamond,
                            size: 12,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'PREMIUM',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: service['isAvailable'] 
                          ? AppTheme.successColor 
                          : AppTheme.errorColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      service['isAvailable'] ? 'Available' : 'Unavailable',
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
                        service['name'],
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
                        color: isExtraSpecial 
                            ? Colors.amber.withOpacity(0.1)
                            : AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isExtraSpecial ? 'EXTRA SPECIAL' : 'SPECIAL',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isExtraSpecial 
                              ? Colors.amber.shade700
                              : AppTheme.successColor,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  service['description'],
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
                              '₹${service['discountedPrice']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isExtraSpecial 
                                    ? Colors.amber.shade700 
                                    : AppTheme.successColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '₹${service['price']}',
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
                            '${(((service['price'] - service['discountedPrice']) / service['price']) * 100).round()}% OFF',
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
                          onPressed: () => _editService(index),
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: isExtraSpecial 
                                ? Colors.amber.shade700 
                                : AppTheme.successColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _toggleAvailability(index),
                          icon: Icon(
                            service['isAvailable'] 
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20,
                            color: service['isAvailable'] 
                                ? AppTheme.errorColor
                                : AppTheme.successColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _deleteService(index),
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

  void _editService(int index) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit service functionality coming soon'),
      ),
    );
  }

  void _toggleAvailability(int index) {
    setState(() {
      _services[index]['isAvailable'] = !_services[index]['isAvailable'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Service ${_services[index]['isAvailable'] ? 'enabled' : 'disabled'}',
        ),
      ),
    );
  }

  void _deleteService(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text('Are you sure you want to delete "${_services[index]['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _services.removeAt(index);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Service deleted successfully'),
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