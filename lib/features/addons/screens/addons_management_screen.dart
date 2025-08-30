import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import '../../service_listings/models/service_add_on.dart';
import '../../service_listings/models/service_listing.dart';
import '../../service_listings/providers/service_add_on_provider.dart';
import '../../service_listings/providers/service_listing_provider.dart';
import '../widgets/add_on_card.dart';
import '../widgets/add_on_form_dialog.dart';

class AddOnsManagementScreen extends ConsumerStatefulWidget {
  final String? serviceListingId;
  
  const AddOnsManagementScreen({
    super.key,
    this.serviceListingId,
  });

  @override
  ConsumerState<AddOnsManagementScreen> createState() => _AddOnsManagementScreenState();
}

class _AddOnsManagementScreenState extends ConsumerState<AddOnsManagementScreen> {
  String? _selectedServiceListingId;
  String _searchQuery = '';
  String _filterType = 'all';
  bool _showOnlyAvailable = false;

  @override
  void initState() {
    super.initState();
    _selectedServiceListingId = widget.serviceListingId;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedServiceListingId == null) {
      return _buildServiceListingSelector();
    }

    final addOnsAsync = ref.watch(serviceAddOnsNotifierProvider(_selectedServiceListingId!));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Column(
        children: [
          _buildHeader(),
          _buildFiltersAndSearch(),
          Expanded(
            child: addOnsAsync.when(
              data: (addOns) => _buildAddOnsList(addOns),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(error),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: HeroIcon(
          HeroIcons.arrowLeft,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Manage Add-ons',
        style: TextStyle(
          color: Theme.of(context).textTheme.titleLarge?.color,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: HeroIcon(
            HeroIcons.adjustmentsHorizontal,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: _showFilterOptions,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const HeroIcon(
                  HeroIcons.puzzlePiece,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Add-ons',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Enhance your services with additional options',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Increase revenue with premium add-ons',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSearch() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search add-ons...',
                prefixIcon: HeroIcon(
                  HeroIcons.magnifyingGlass,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Add-ons', 'add_on'),
                const SizedBox(width: 8),
                _buildFilterChip('Upgrades', 'upgrade'),
                const SizedBox(width: 8),
                _buildFilterChip('Accessories', 'accessory'),
                const SizedBox(width: 16),
                _buildAvailabilityToggle(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String type) {
    final isSelected = _filterType == type;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => _filterType = type),
      backgroundColor: Theme.of(context).cardColor,
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.1),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected 
          ? Theme.of(context).primaryColor 
          : Theme.of(context).textTheme.bodyMedium?.color,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }

  Widget _buildAvailabilityToggle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Available only',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          value: _showOnlyAvailable,
          onChanged: (value) => setState(() => _showOnlyAvailable = value),
          activeThumbColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildAddOnsList(List<ServiceAddOn> addOns) {
    final filteredAddOns = _filterAddOns(addOns);

    if (filteredAddOns.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      itemCount: filteredAddOns.length,
      itemBuilder: (context, index) {
        final addOn = filteredAddOns[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AddOnCard(
            addOn: addOn,
            onTap: () => _editAddOn(addOn),
            onToggleAvailability: (isAvailable) => _toggleAvailability(addOn, isAvailable),
            onDelete: () => _deleteAddOn(addOn),
            onUpdateStock: (stock) => _updateStock(addOn, stock),
          ),
        );
      },
    );
  }

  List<ServiceAddOn> _filterAddOns(List<ServiceAddOn> addOns) {
    return addOns.where((addOn) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!addOn.name.toLowerCase().contains(query) &&
            !(addOn.description?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }

      // Type filter
      if (_filterType != 'all' && addOn.type != _filterType) {
        return false;
      }

      // Availability filter
      if (_showOnlyAvailable && !addOn.isAvailable) {
        return false;
      }

      return true;
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: HeroIcon(
              HeroIcons.puzzlePiece,
              color: Theme.of(context).primaryColor,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isNotEmpty || _filterType != 'all' || _showOnlyAvailable
                ? 'No add-ons match your filters'
                : 'No add-ons yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _filterType != 'all' || _showOnlyAvailable
                ? 'Try adjusting your search or filters'
                : 'Create your first add-on to boost your service offerings',
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isEmpty && _filterType == 'all' && !_showOnlyAvailable) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createAddOn,
              icon: const HeroIcon(HeroIcons.plus, size: 20),
              label: const Text('Create First Add-on'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeroIcon(
            HeroIcons.exclamationTriangle,
            color: Theme.of(context).colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load add-ons',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(serviceAddOnsNotifierProvider(_selectedServiceListingId!)),
            icon: const HeroIcon(HeroIcons.arrowPath, size: 20),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceListingSelector() {
    final serviceListingsAsync = ref.watch(serviceListingsProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: HeroIcon(
            HeroIcons.arrowLeft,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Select Service',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: serviceListingsAsync.when(
        data: (serviceListings) => _buildServiceListingsList(serviceListings),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildServiceListingsErrorState(error),
      ),
    );
  }

  Widget _buildServiceListingsList(List<ServiceListing> serviceListings) {
    if (serviceListings.isEmpty) {
      return _buildNoServiceListingsState();
    }

    return Column(
      children: [
        _buildServiceListingsHeader(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            itemCount: serviceListings.length,
            itemBuilder: (context, index) {
              final serviceListing = serviceListings[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildServiceListingCard(serviceListing),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceListingsHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const HeroIcon(
                  HeroIcons.listBullet,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose Service',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Select a service to manage its add-ons',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceListingCard(ServiceListing serviceListing) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor,


      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: () => _selectServiceListing(serviceListing),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Service Image or Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: serviceListing.photos.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          serviceListing.photos.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.photo_camera_back,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.photo_camera_back,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 16),
              // Service Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceListing.title ?? 'No Title',

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (serviceListing.category != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          serviceListing.category!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₹${serviceListing.offerPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: serviceListing.isActive 
                                ? AppTheme.successColor.withOpacity(0.1)
        : AppTheme.errorColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            serviceListing.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: serviceListing.isActive 
                                  ? AppTheme.successColor
                                  : AppTheme.errorColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow Icon
              HeroIcon(
                HeroIcons.chevronRight,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoServiceListingsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: HeroIcon(
              HeroIcons.listBullet,
              color: Theme.of(context).primaryColor,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Service Listings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first service listing to manage add-ons',
            style: TextStyle(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/add-service'),
            icon: const HeroIcon(HeroIcons.plus, size: 20),
            label: const Text('Create Service'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceListingsErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeroIcon(
            HeroIcons.exclamationTriangle,
            color: Theme.of(context).colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(serviceListingsProvider),
            icon: const HeroIcon(HeroIcons.arrowPath, size: 20),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _selectServiceListing(ServiceListing serviceListing) {
    setState(() {
      _selectedServiceListingId = serviceListing.id;
    });
  }

  Widget _buildFloatingActionButton() {
    if (_selectedServiceListingId == null) return const SizedBox.shrink();
    
    return FloatingActionButton.extended(
      onPressed: _createAddOn,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      icon: const HeroIcon(HeroIcons.plus, size: 20),
      label: const Text('Add Add-on'),
    );
  }

  void _createAddOn() {
    showDialog(
      context: context,
      builder: (context) => AddOnFormDialog(
        serviceListingId: _selectedServiceListingId!,
        onSave: (addOn) => _saveAddOn(addOn),
      ),
    );
  }

  void _editAddOn(ServiceAddOn addOn) {
    showDialog(
      context: context,
      builder: (context) => AddOnFormDialog(
        serviceListingId: _selectedServiceListingId!,
        addOn: addOn,
        onSave: (updatedAddOn) => _saveAddOn(updatedAddOn),
      ),
    );
  }

  Future<void> _saveAddOn(ServiceAddOn addOn) async {
    try {
      final notifier = ref.read(serviceAddOnsNotifierProvider(_selectedServiceListingId!).notifier);
      
      if (addOn.id == null) {
        await notifier.addAddOn(addOn);
        _showSuccessSnackBar('Add-on created successfully');
      } else {
        await notifier.updateAddOn(addOn);
        _showSuccessSnackBar('Add-on updated successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to save add-on: $e');
    }
  }

  Future<void> _toggleAvailability(ServiceAddOn addOn, bool isAvailable) async {
    if (addOn.id == null) return;
    
    try {
      final notifier = ref.read(serviceAddOnsNotifierProvider(_selectedServiceListingId!).notifier);
      await notifier.toggleAvailability(addOn.id!, isAvailable);
      _showSuccessSnackBar(isAvailable ? 'Add-on made available' : 'Add-on made unavailable');
    } catch (e) {
      _showErrorSnackBar('Failed to update availability: $e');
    }
  }

  Future<void> _deleteAddOn(ServiceAddOn addOn) async {
    if (addOn.id == null) return;
    
    final confirmed = await _showDeleteConfirmation(addOn.name);
    if (!confirmed) return;
    
    try {
      final notifier = ref.read(serviceAddOnsNotifierProvider(_selectedServiceListingId!).notifier);
      await notifier.deleteAddOn(addOn.id!);
      _showSuccessSnackBar('Add-on deleted successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to delete add-on: $e');
    }
  }

  Future<void> _updateStock(ServiceAddOn addOn, int stock) async {
    if (addOn.id == null) return;
    
    try {
      final notifier = ref.read(serviceAddOnsNotifierProvider(_selectedServiceListingId!).notifier);
      await notifier.updateStock(addOn.id!, stock);
      _showSuccessSnackBar('Stock updated successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to update stock: $e');
    }
  }

  Future<bool> _showDeleteConfirmation(String addOnName) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Add-on'),
        content: Text('Are you sure you want to delete "$addOnName"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showFilterOptions() {
    // Show filter options bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(height: 20),
            // Filter options would go here
            const Text('Filter options coming soon...'),
          ],
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}