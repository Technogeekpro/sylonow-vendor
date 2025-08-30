import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import '../models/service_addon.dart';
import '../providers/service_addon_provider.dart';
import '../widgets/service_addon_card.dart';
import 'create_service_addon_screen.dart';

class ServiceAddonsScreen extends ConsumerStatefulWidget {
  const ServiceAddonsScreen({super.key});

  @override
  ConsumerState<ServiceAddonsScreen> createState() =>
      _ServiceAddonsScreenState();
}

class _ServiceAddonsScreenState extends ConsumerState<ServiceAddonsScreen> {
  @override
  Widget build(BuildContext context) {
    final addonsAsync = ref.watch(serviceAddonProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(serviceAddonProvider.notifier).refresh();
        },
        color: AppTheme.primaryColor,
        child: addonsAsync.when(
          data: (addons) => _buildAddonsList(addons),
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(error),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Service Add-ons',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      leading: IconButton(
        icon: const HeroIcon(HeroIcons.arrowLeft),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToCreateAddon(),
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      icon: const HeroIcon(HeroIcons.plus, size: 20),
      label: const Text(
        'Add Service',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildAddonsList(List<ServiceAddon> addons) {
    if (addons.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: addons.length,
      itemBuilder: (context, index) {
        final addon = addons[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ServiceAddonCard(
            addon: addon,
            onTap: () => _navigateToEditAddon(addon),
            onDelete: () => _deleteAddon(addon),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_business_outlined,
                size: 60,
                color: AppTheme.primaryColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Service Add-ons Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Create your first service add-on to offer additional services to your customers.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToCreateAddon(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const HeroIcon(HeroIcons.plus, size: 20),
              label: const Text(
                'Create Add-on',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load add-ons',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  ref.read(serviceAddonProvider.notifier).refresh(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreateAddon() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateServiceAddonScreen(),
      ),
    );
  }

  void _navigateToEditAddon(ServiceAddon addon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateServiceAddonScreen(addon: addon),
      ),
    );
  }

  Future<void> _deleteAddon(ServiceAddon addon) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Add-on'),
        content: Text('Are you sure you want to delete "${addon.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(serviceAddonProvider.notifier).deleteAddon(addon.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('"${addon.name}" deleted successfully'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete add-on: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }
}
