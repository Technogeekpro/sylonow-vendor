import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../models/addon.dart';
import '../providers/addon_provider.dart';
import '../service/addon_service.dart';
import 'addon_form_screen.dart';

class AddonsListScreen extends ConsumerStatefulWidget {
  const AddonsListScreen({super.key});

  @override
  ConsumerState<AddonsListScreen> createState() => _AddonsListScreenState();
}

class _AddonsListScreenState extends ConsumerState<AddonsListScreen> {
  String _selectedCategory = 'All';
  
  // Predefined categories
  final List<String> _predefinedCategories = [
    'cake',
    'special service', 
    'extra special service',
    'gift',
  ];

  @override
  Widget build(BuildContext context) {
    final addonsAsync = ref.watch(vendorAddonsProvider);
    final categoriesAsync = ref.watch(availableCategoriesProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add-ons & Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
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
              HeroIcons.plus,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => _navigateToAddAddon(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category counts and filter
          addonsAsync.when(
            data: (addons) => _buildCategorySection(addons),
            loading: () => const SizedBox(height: 120),
            error: (_, __) => const SizedBox(height: 120),
          ),

          // Add-ons List
          Expanded(
            child: addonsAsync.when(
              data: (addons) {
                // Filter addons based on selected category
                final filteredAddons = _selectedCategory == 'All'
                    ? addons
                    : addons.where((addon) => addon.category == _selectedCategory).toList();

                if (filteredAddons.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_business_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCategory == 'All' 
                              ? 'No add-ons created yet'
                              : 'No add-ons in ${_selectedCategory.toLowerCase()}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create add-on services to increase your revenue',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _navigateToAddAddon(),
                          icon: const Icon(Icons.add),
                          label: const Text('Create Add-on'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(vendorAddonsProvider);
                    ref.invalidate(availableCategoriesProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAddons.length,
                    itemBuilder: (context, index) {
                      return _buildAddonCard(filteredAddons[index]);
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
                    Text('Loading add-ons...'),
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
                      'Failed to load add-ons',
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
                        ref.invalidate(vendorAddonsProvider);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton( 
        onPressed: () => _navigateToAddAddon(),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCategorySection(List<Addon> addons) {
    // Calculate category counts
    Map<String, int> categoryCounts = {'All': addons.length};
    for (String category in _predefinedCategories) {
      categoryCounts[category] = addons.where((addon) => addon.category == category).length;
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Category counts
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories Overview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', ..._predefinedCategories].map((category) {
                      final count = categoryCounts[category] ?? 0;
                      final isSelected = category == _selectedCategory;
                      return Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              count.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected 
                                    ? Theme.of(context).primaryColor
                                    : AppTheme.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              category == 'All' 
                                  ? 'Total'
                                  : category.split(' ').map((word) => 
                                      word[0].toUpperCase() + word.substring(1)
                                    ).join(' '),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: isSelected 
                                    ? Theme.of(context).primaryColor
                                    : AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Category filter dropdown
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                const Text(
                  'Filter by: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    items: ['All', ..._predefinedCategories].map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category == 'All' 
                              ? 'All Categories'
                              : category.split(' ').map((word) => 
                                  word[0].toUpperCase() + word.substring(1)
                                ).join(' '),
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddonCard(Addon addon) {
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
        border: Border.all(
          color: addon.isActive 
              ? Colors.green.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: addon.imageUrl != null && addon.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: addon.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.add_business,
                            size: 32,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.add_business,
                        size: 32,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
              ),
              const SizedBox(width: 16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            addon.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Row(
                                children: [
                                  Icon(Icons.edit, size: 16),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                              onTap: () => _navigateToEditAddon(addon),
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(
                                    addon.isActive ? Icons.visibility_off : Icons.visibility,
                                    size: 16,
                                    color: addon.isActive ? Colors.orange : Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(addon.isActive ? 'Deactivate' : 'Activate'),
                                ],
                              ),
                              onTap: () => _toggleAddonStatus(addon),
                            ),
                            PopupMenuItem(
                              child: const Row(
                                children: [
                                  Icon(Icons.delete, size: 16, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                              onTap: () => _showDeleteConfirmation(addon),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    if (addon.category.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          addon.category,
                          style:  TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 8),
                    Text(
                      '₹${addon.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    
                    if (addon.description != null && addon.description!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        addon.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Status and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: addon.isActive 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      addon.isActive ? Icons.check_circle : Icons.pause_circle,
                      size: 12,
                      color: addon.isActive ? Colors.green : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      addon.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color:  addon.isActive ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _navigateToEditAddon(addon),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _toggleAddonStatus(addon),
                    icon: Icon(
                      addon.isActive ? Icons.visibility_off : Icons.visibility,
                      size: 16,
                    ),
                    label: Text(addon.isActive ? 'Deactivate' : 'Activate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: addon.isActive ? Colors.orange : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToAddAddon() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddonFormScreen(),
      ),
    ).then((_) {
      ref.invalidate(vendorAddonsProvider);
      ref.invalidate(availableCategoriesProvider);
    });
  }

  void _navigateToEditAddon(Addon addon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddonFormScreen(existingAddon: addon),
      ),
    ).then((_) {
      ref.invalidate(vendorAddonsProvider);
      ref.invalidate(availableCategoriesProvider);
    });
  }

  void _toggleAddonStatus(Addon addon) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updating add-on status...')),
      );

      await ref.read(addonServiceProvider)
          .toggleAddonStatus(addon.id, !addon.isActive);
      
      ref.invalidate(vendorAddonsProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Add-on ${addon.isActive ? 'deactivated' : 'activated'}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(Addon addon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Add-on'),
        content: Text(
          'Are you sure you want to delete "${addon.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAddon(addon);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteAddon(Addon addon) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deleting add-on...')),
      );

      await ref.read(addonServiceProvider).deleteAddon(addon.id);
      
      ref.invalidate(vendorAddonsProvider);
      ref.invalidate(availableCategoriesProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add-on deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete add-on: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}