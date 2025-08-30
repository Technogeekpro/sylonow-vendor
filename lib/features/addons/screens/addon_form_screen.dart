import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../models/addon.dart';
import '../service/addon_service.dart';
import '../../theaters/service/theater_media_service.dart';

class AddonFormScreen extends ConsumerStatefulWidget {
  final Addon? existingAddon;

  const AddonFormScreen({super.key, this.existingAddon});

  @override
  ConsumerState<AddonFormScreen> createState() => _AddonFormScreenState();
}

class _AddonFormScreenState extends ConsumerState<AddonFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _categoryController;

  String? _uploadedImageUrl;
  bool _isLoading = false;
  bool _isUploadingImage = false;

  // Predefined categories
  final List<String> _predefinedCategories = [
    'cake',
    'special service',
    'extra special service',
    'gift',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final addon = widget.existingAddon;
    _nameController = TextEditingController(text: addon?.name ?? '');
    _descriptionController =
        TextEditingController(text: addon?.description ?? '');
    _priceController =
        TextEditingController(text: addon?.price.toString() ?? '');
    _categoryController =
        TextEditingController(text: addon?.category ?? 'cake');
    _uploadedImageUrl = addon?.imageUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingAddon != null;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Add-on' : 'Create Add-on',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload Section
              const Text(
                'Add-on Image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildImageUploadSection(),

              const SizedBox(height: 24),

              // Name Field
              const Text(
                'Add-on Name *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter add-on name',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.tag),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter add-on name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Category Field
              const Text(
                'Category *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              _buildCategoryField(),

              const SizedBox(height: 20),

              // Price Field
              const Text(
                'Price *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  hintText: 'Enter price',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.banknotes),
                  prefixText: '₹ ',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  if (double.parse(value) < 0) {
                    return 'Price cannot be negative';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Description Field
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Describe your add-on service...',
                  border: OutlineInputBorder(),
                  prefixIcon: HeroIcon(HeroIcons.documentText),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                textInputAction: TextInputAction.newline,
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveAddon,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const HeroIcon(HeroIcons.check, size: 20),
                  label: Text(
                    _isLoading
                        ? (isEditing ? 'Updating...' : 'Creating...')
                        : (isEditing ? 'Update Add-on' : 'Create Add-on'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: _uploadedImageUrl!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed:
                              _isUploadingImage ? null : _pickAndUploadImage,
                          icon: const Icon(Icons.edit,
                              color: Colors.white, size: 20),
                        ),
                        IconButton(
                          onPressed: _isUploadingImage ? null : _removeImage,
                          icon: const Icon(Icons.delete,
                              color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isUploadingImage)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 8),
                          Text(
                            'Uploading image...',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            )
          : _isUploadingImage
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Uploading image...'),
                    ],
                  ),
                )
              : InkWell(
                  onTap: _pickAndUploadImage,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 48,
                          color: AppTheme.textSecondaryColor,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap to add image',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Max size: 5MB',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildCategoryField() {
    return DropdownButtonFormField<String>(
      value: _predefinedCategories.contains(_categoryController.text)
          ? _categoryController.text
          : _predefinedCategories.first,
      decoration: const InputDecoration(
        hintText: 'Select category',
        border: OutlineInputBorder(),
        prefixIcon: HeroIcon(HeroIcons.squares2x2),
      ),
      items: _predefinedCategories.map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(
            category
                .split(' ')
                .map((word) => word[0].toUpperCase() + word.substring(1))
                .join(' '),
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _categoryController.text = value;
          });
        }
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Future<void> _pickAndUploadImage() async {
    setState(() {
      _isUploadingImage = true;
    });

    try {
      final mediaService = ref.read(theaterMediaServiceProvider);
      final imageUrl = await mediaService.pickAndUploadSingleImage();

      if (imageUrl != null) {
        setState(() {
          _uploadedImageUrl = imageUrl;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }

  void _removeImage() {
    setState(() {
      _uploadedImageUrl = null;
    });
  }

  Future<void> _saveAddon() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isEditing = widget.existingAddon != null;

      if (isEditing) {
        // Update existing addon
        await ref.read(addonServiceProvider).updateAddon(
          widget.existingAddon!.id,
          {
            'name': _nameController.text.trim(),
            'description': _descriptionController.text.trim().isNotEmpty
                ? _descriptionController.text.trim()
                : null,
            'price': double.parse(_priceController.text),
            'category': _categoryController.text.trim(),
            'image_url': _uploadedImageUrl,
          },
        );
      } else {
        // Create new addon
        final newAddon = Addon(
          id: '', // Will be auto-generated
          vendorId: '', // Will be set by service
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          imageUrl: _uploadedImageUrl,
          price: double.parse(_priceController.text),
          category: _categoryController.text.trim(),
          isActive: true,
        );

        await ref.read(addonServiceProvider).createAddon(newAddon);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Add-on ${isEditing ? 'updated' : 'created'} successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to ${widget.existingAddon != null ? 'update' : 'create'} add-on: ${e.toString()}'),
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
