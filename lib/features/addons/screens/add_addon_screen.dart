import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/supabase_service.dart';

class AddAddonScreen extends StatefulWidget {
  const AddAddonScreen({super.key});

  @override
  State<AddAddonScreen> createState() => _AddAddonScreenState();
}

class _AddAddonScreenState extends State<AddAddonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  
  File? _selectedImage;
  String? _selectedTheaterId;
  List<Map<String, dynamic>> _theaters = [];
  bool _isLoading = false;
  bool _isLoadingTheaters = true;
  
  final ImagePicker _picker = ImagePicker();
  
  @override
  void initState() {
    super.initState();
    _loadTheaters();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
  
  Future<void> _loadTheaters() async {
    try {
      final theaters = await SupabaseService.getServiceListings();
      setState(() {
        _theaters = theaters;
        _isLoadingTheaters = false;
        if (theaters.isNotEmpty) {
          _selectedTheaterId = theaters.first['id'];
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingTheaters = false;
      });
      if (mounted) {
        _showErrorSnackBar('Failed to load theaters: $e');
      }
    }
  }
  
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }
  
  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to take photo: $e');
    }
  }
  
  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Image',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                ),
                _buildImageOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _saveAddOn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedTheaterId == null) {
      _showErrorSnackBar('Please select a theater');
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      String? imageUrl;
      
      // Upload image if selected
      if (_selectedImage != null) {
        final fileName = 'addon_${DateTime.now().millisecondsSinceEpoch}.jpg';
        imageUrl = await SupabaseService.uploadImage(
          _selectedImage!,
          'addon-images',
          fileName,
        );
      }
      
      // Prepare add-on data
      final addOnData = {
        'theater_id': _selectedTheaterId!,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim().isNotEmpty 
            ? _descriptionController.text.trim() 
            : null,
        'price': double.parse(_priceController.text.trim()),
        'category': _categoryController.text.trim().isNotEmpty 
            ? _categoryController.text.trim() 
            : null,
        'image_url': imageUrl,
        'is_available': true,
      };
      
      await SupabaseService.addAddOn(addOnData);
      
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add-on created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Failed to create add-on: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Add New Add-on',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoadingTheaters
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _theaters.isEmpty
              ? _buildEmptyState()
              : _buildForm(),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.theater_comedy_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Theaters Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You need to create a theater/service listing first before adding add-ons.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Theater Selection'),
            _buildTheaterDropdown(),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Add-on Details'),
            _buildTextField(
              controller: _nameController,
              label: 'Add-on Name',
              hint: 'Enter a catchy name for your add-on',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter add-on name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe what this add-on includes',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _priceController,
                    label: 'Price (₹)',
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter price';
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return 'Please enter valid price';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _categoryController,
                    label: 'Category',
                    hint: 'e.g., Decoration, Food, etc.',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Add-on Image'),
            _buildImageSection(),
            const SizedBox(height: 32),
            
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
  
  Widget _buildTheaterDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedTheaterId,
        decoration: const InputDecoration(
          labelText: 'Select Theater',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        items: _theaters.map((theater) {
          return DropdownMenuItem<String>(
            value: theater['id'],
            child: Text(
              theater['title'] ?? 'Unnamed Theater',
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedTheaterId = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Please select a theater';
          }
          return null;
        },
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }
  
  Widget _buildImageSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: _selectedImage != null
          ? _buildSelectedImage()
          : _buildImagePlaceholder(),
    );
  }
  
  Widget _buildSelectedImage() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _selectedImage!,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: _showImagePickerDialog,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildImagePlaceholder() {
    return InkWell(
      onTap: _showImagePickerDialog,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 40,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Add Image',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to select from gallery or camera',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveAddOn,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.secondaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
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
            : const Text(
                'Create Add-on',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}