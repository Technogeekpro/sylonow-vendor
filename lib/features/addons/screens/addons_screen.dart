import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/supabase_service.dart';
import '../widgets/cake_tab.dart';
import '../widgets/gifts_tab.dart';
import '../widgets/special_service_tab.dart';
import '../widgets/extra_special_service_tab.dart';
import 'add_addon_screen.dart';

class AddonsScreen extends ConsumerStatefulWidget {
  const AddonsScreen({super.key});

  @override
  ConsumerState<AddonsScreen> createState() => _AddonsScreenState();
}

class _AddonsScreenState extends ConsumerState<AddonsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;
  bool _isFabVisible = true;

  final List<Tab> _tabs = [
    const Tab(
      icon: Icon(Icons.card_giftcard),
      text: 'Gifts',
    ),
    const Tab(
      icon: Icon(Icons.cake),
      text: 'Cakes',
    ),
    const Tab(
      icon: Icon(Icons.star),
      text: 'Special Service',
    ),
    const Tab(
      icon: Icon(Icons.diamond),
      text: 'Extra Special Service',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.borderColor,
        elevation: 0,
        title: Text(
          'Add-ons',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        bottom: _buildTabBar(),
      ),
      body: Column(
        children: [
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabWithScroll(const GiftsTab()),
                _buildTabWithScroll(const CakeTab()),
                _buildTabWithScroll(const SpecialServiceTab()),
                _buildTabWithScroll(const ExtraSpecialServiceTab()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isFabVisible ? 1.0 : 0.0,
          child: FloatingActionButton(
            onPressed: _navigateToAddAddonScreen,
            backgroundColor: AppTheme.primaryColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildTabWithScroll(Widget child) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is UserScrollNotification) {
          if (scrollNotification.direction == ScrollDirection.reverse) {
            if (_isFabVisible) {
              setState(() {
                _isFabVisible = false;
              });
            }
          } else if (scrollNotification.direction == ScrollDirection.forward) {
            if (!_isFabVisible) {
              setState(() {
                _isFabVisible = true;
              });
            }
          }
        }
        return false;
      },
      child: child,
    );
  }

  _buildTabBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          boxShadow: [AppTheme.cardShadow],
        ),
        child: TabBar(
          controller: _tabController,
          tabs: _tabs,
          labelColor: Colors.white,
          unselectedLabelColor: const Color.fromARGB(255, 211, 211, 211),
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.fromLTRB(
            8,
            8,
            8,
            0,
          ),
        ),
      ),
    );
  }

  void _navigateToAddAddonScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddAddonScreen(),
      ),
    );
    
    // If add-on was successfully created, refresh the current tab
    if (result == true) {
      _refreshCurrentTab();
    }
  }
  
  void _showAddAddonDialog() {
    String type = '';

    switch (_currentTab) {
      case 0:
        type = 'Gift';
        break;
      case 1:
        type = 'Cake';
        break;
      case 2:
        type = 'Special Service';
        break;
      case 3:
        type = 'Extra Special Service';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => _AddAddonDialog(
        type: type,
        onAddonAdded: _refreshCurrentTab,
      ),
    );
  }

  void _refreshCurrentTab() {
    // Trigger a rebuild of the current tab to refresh data
    setState(() {});
  }
}

class _AddAddonDialog extends StatefulWidget {
  final String type;
  final VoidCallback onAddonAdded;

  const _AddAddonDialog({
    required this.type,
    required this.onAddonAdded,
  });

  @override
  State<_AddAddonDialog> createState() => _AddAddonDialogState();
}

class _AddAddonDialogState extends State<_AddAddonDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountedPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedCategory = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _getDefaultCategory();
  }

  String _getDefaultCategory() {
    switch (widget.type) {
      case 'Cake':
        return 'cake';
      case 'Gift':
        return 'gifts';
      case 'Special Service':
        return 'special services';
      case 'Extra Special Service':
        return 'extra special services';
      default:
        return 'cake';
    }
  }

  List<String> _getCategories() {
    switch (widget.type) {
      case 'Cake':
        return ['cake'];
      case 'Gift':
        return ['gifts'];
      case 'Special Service':
        return ['special services'];
      case 'Extra Special Service':
        return ['extra special services'];
      default:
        return ['cake'];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _discountedPriceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New ${widget.type}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                hintText: 'Enter eye catching name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Add Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Original Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _discountedPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Discounted Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: widget.type == 'Cake' ? 'Image URL' : 'Icon URL',
                hintText: 'Enter image/icon URL (optional)',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Extra Service Type',
                border: OutlineInputBorder(),
              ),
              items: _getCategories().map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveAddon,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }

  Future<void> _saveAddon() async {
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in name and price'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final price = double.tryParse(_priceController.text.trim());
      final discountedPrice = _discountedPriceController.text.trim().isNotEmpty 
          ? double.tryParse(_discountedPriceController.text.trim()) 
          : null;
      
      if (price == null) {
        throw Exception('Invalid price format');
      }
      
      final addonData = {
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim().isNotEmpty 
            ? _descriptionController.text.trim() 
            : null,
        'price': price,
        'discounted_price': discountedPrice,
        'category': _selectedCategory,
      };
      
      // Add image_url for cakes or icon_url for services
      if (widget.type == 'Cake' && _imageUrlController.text.trim().isNotEmpty) {
        addonData['image_url'] = _imageUrlController.text.trim();
      } else if ((widget.type == 'Special Service' || widget.type == 'Extra Special Service') && 
                 _imageUrlController.text.trim().isNotEmpty) {
        addonData['icon_url'] = _imageUrlController.text.trim();
      }
      
      switch (widget.type) {
        case 'Gift':
          await SupabaseService.addGift(addonData);
          break;
        case 'Cake':
          await SupabaseService.addCake(addonData);
          break;
        case 'Special Service':
          await SupabaseService.addSpecialService(addonData);
          break;
        case 'Extra Special Service':
          await SupabaseService.addExtraSpecialService(addonData);
          break;
      }
      
      if (mounted) {
        Navigator.of(context).pop();
        widget.onAddonAdded();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.type} added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add ${widget.type.toLowerCase()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
