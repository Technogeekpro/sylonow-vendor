import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/providers/theme_provider.dart';
import '../../../core/theme/models/theme_config.dart';

class ThemeManagementScreen extends ConsumerStatefulWidget {
  const ThemeManagementScreen({super.key});

  @override
  ConsumerState<ThemeManagementScreen> createState() => _ThemeManagementScreenState();
}

class _ThemeManagementScreenState extends ConsumerState<ThemeManagementScreen> {
  String? selectedThemeId;

  @override
  Widget build(BuildContext context) {
    final themesAsync = ref.watch(themeManagerProvider);
    final activeThemeAsync = ref.watch(activeThemeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Management'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Active Theme Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: activeThemeAsync.when(
              data: (activeTheme) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Theme',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activeTheme?.configName ?? 'Default Theme',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (activeTheme != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _ColorPreview('Primary', activeTheme.primaryColorValue),
                        const SizedBox(width: 8),
                        _ColorPreview('Secondary', activeTheme.secondaryColorValue),
                        const SizedBox(width: 8),
                        _ColorPreview('Success', activeTheme.successColorValue),
                      ],
                    ),
                  ],
                ],
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => Text('Error: $error'),
            ),
          ),

          // Theme List
          Expanded(
            child: themesAsync.when(
              data: (themes) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: themes.length,
                itemBuilder: (context, index) {
                  final theme = themes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.primaryColorValue,
                        child: Text(
                          theme.configName[0].toUpperCase(),
                          style: TextStyle(
                            color: theme.textOnPrimaryValue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(theme.configName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Version: ${theme.version}'),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _ColorPreview('P', theme.primaryColorValue),
                              const SizedBox(width: 4),
                              _ColorPreview('S', theme.secondaryColorValue),
                              const SizedBox(width: 4),
                              _ColorPreview('E', theme.errorColorValue),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (theme.isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'ACTIVE',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else
                            ElevatedButton(
                              onPressed: () => _activateTheme(theme.id),
                              child: const Text('Activate'),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('Error loading themes: $error'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateThemeDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Theme'),
      ),
    );
  }

  Widget _ColorPreview(String label, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _activateTheme(String themeId) async {
    try {
      await ref.read(activeThemeProvider.notifier).setActiveTheme(themeId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Theme activated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error activating theme: $e')),
        );
      }
    }
  }

  void _showCreateThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => const _CreateThemeDialog(),
    );
  }
}

class _CreateThemeDialog extends ConsumerStatefulWidget {
  const _CreateThemeDialog();

  @override
  ConsumerState<_CreateThemeDialog> createState() => _CreateThemeDialogState();
}

class _CreateThemeDialogState extends ConsumerState<_CreateThemeDialog> {
  final _nameController = TextEditingController();
  final _primaryColorController = TextEditingController(text: '#FF0080');
  final _secondaryColorController = TextEditingController(text: '#42A5F5');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Theme'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Theme Name',
                hintText: 'Enter theme name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _primaryColorController,
              decoration: const InputDecoration(
                labelText: 'Primary Color',
                hintText: '#FF0080',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _secondaryColorController,
              decoration: const InputDecoration(
                labelText: 'Secondary Color',
                hintText: '#42A5F5',
              ),
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
          onPressed: _createTheme,
          child: const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createTheme() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a theme name')),
      );
      return;
    }

    try {
      final themeData = {
        'config_name': _nameController.text.trim(),
        'primary_color': _primaryColorController.text.trim(),
        'secondary_color': _secondaryColorController.text.trim(),
        'is_active': false,
      };

      await ref.read(themeManagerProvider.notifier).createTheme(themeData);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Theme created successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating theme: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _primaryColorController.dispose();
    _secondaryColorController.dispose();
    super.dispose();
  }
}