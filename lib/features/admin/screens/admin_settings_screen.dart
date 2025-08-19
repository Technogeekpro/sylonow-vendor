import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/admin_settings_provider.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  void _loadCurrentSettings() async {
    final supportContact = await ref.read(supportContactProvider.future);
    _emailController.text = supportContact['email'] ?? '';
    _phoneController.text = supportContact['phone'] ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminSettingsAsync = ref.watch(adminSettingsDataProvider);
    final supportContactAsync = ref.watch(supportContactProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(adminSettingsDataProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Current Settings Display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    supportContactAsync.when(
                      data: (contact) => Column(
                        children: [
                          _SettingRow(
                            label: 'Support Email',
                            value: contact['email'] ?? 'Not set',
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 12),
                          _SettingRow(
                            label: 'Support Phone',
                            value: contact['phone'] ?? 'Not set',
                            icon: Icons.phone,
                          ),
                        ],
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Text('Error: $error'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Update Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Update Support Contact',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Support Email',
                        prefixIcon: Icon(Icons.email),
                        hintText: 'support@sylonow.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Support Phone',
                        prefixIcon: Icon(Icons.phone),
                        hintText: '+91 98765 43210',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateSettings,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Update Settings'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Cache Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cache Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Text(
                      'Settings are cached for 1 hour to improve performance. Use the refresh button to force reload.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    OutlinedButton.icon(
                      onPressed: () {
                        ref.read(adminSettingsDataProvider.notifier).clearCacheAndRefresh();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cache cleared and refreshed')),
                        );
                      },
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear Cache'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.infoColor.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Update:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.infoColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Update values directly in the Supabase admin_settings table\n'
                    '• Changes will be reflected within 1 hour (cache expiry)\n'
                    '• Use "Clear Cache" for immediate effect\n'
                    '• Settings apply app-wide including Support screen',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // For demo purposes, we'll just show a success message
      // In a real implementation, you'd update the database here
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings would be updated in database'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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

class _SettingRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _SettingRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}