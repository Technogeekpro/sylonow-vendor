import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';
import '../../service_listings/models/service_add_on.dart';

class AddOnFormDialog extends StatefulWidget {
  final String serviceListingId;
  final ServiceAddOn? addOn;
  final Function(ServiceAddOn) onSave;

  const AddOnFormDialog({
    super.key,
    required this.serviceListingId,
    this.addOn,
    required this.onSave,
  });

  @override
  State<AddOnFormDialog> createState() => _AddOnFormDialogState();
}

class _AddOnFormDialogState extends State<AddOnFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _originalPriceController;
  late final TextEditingController _discountPriceController;
  late final TextEditingController _stockController;
  
  String _selectedType = 'add_on';
  String _selectedUnit = 'piece';
  bool _isAvailable = true;
  bool _isLoading = false;

  final List<String> _typeOptions = [
    'add_on',
    'upgrade',
    'accessory',
  ];

  final List<String> _unitOptions = [
    'piece',
    'hour',
    'set',
    'kg',
    'meter',
    'liter',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.addOn?.name ?? '');
    _descriptionController = TextEditingController(text: widget.addOn?.description ?? '');
    _originalPriceController = TextEditingController(
      text: widget.addOn?.originalPrice.toString() ?? '',
    );
    _discountPriceController = TextEditingController(
      text: widget.addOn?.discountPrice?.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.addOn?.stock.toString() ?? '0',
    );
    
    if (widget.addOn != null) {
      _selectedType = widget.addOn!.type;
      _selectedUnit = widget.addOn!.unit;
      _isAvailable = widget.addOn!.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _discountPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildForm(),
              ),
            ),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          const HeroIcon(
            HeroIcons.puzzlePiece,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.addOn == null ? 'Create Add-on' : 'Edit Add-on',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const HeroIcon(
              HeroIcons.xMark,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Add-on Name *',
            hint: 'e.g., Premium Decoration Package',
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
            hint: 'Describe what this add-on includes...',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdownField(
                  label: 'Type *',
                  value: _selectedType,
                  items: _typeOptions.map((type) {
                    String displayName;
                    switch (type) {
                      case 'add_on':
                        displayName = 'Add-on';
                        break;
                      case 'upgrade':
                        displayName = 'Upgrade';
                        break;
                      case 'accessory':
                        displayName = 'Accessory';
                        break;
                      default:
                        displayName = type;
                    }
                    return DropdownMenuItem(value: type, child: Text(displayName));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedType = value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdownField(
                  label: 'Unit *',
                  value: _selectedUnit,
                  items: _unitOptions.map((unit) {
                    return DropdownMenuItem(value: unit, child: Text(unit));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedUnit = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _originalPriceController,
                  label: 'Original Price *',
                  hint: '0.00',
                  prefixText: '₹ ',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter original price';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Please enter valid price';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _discountPriceController,
                  label: 'Discount Price',
                  hint: '0.00',
                  prefixText: '₹ ',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      final discountPrice = double.tryParse(value);
                      final originalPrice = double.tryParse(_originalPriceController.text);
                      
                      if (discountPrice == null || discountPrice <= 0) {
                        return 'Please enter valid discount price';
                      }
                      
                      if (originalPrice != null && discountPrice >= originalPrice) {
                        return 'Discount price must be less than original price';
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _stockController,
            label: 'Stock Quantity *',
            hint: '0',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter stock quantity';
              }
              final stock = int.tryParse(value);
              if (stock == null || stock < 0) {
                return 'Please enter valid stock quantity';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Available for customers',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              Switch(
                value: _isAvailable,
                onChanged: (value) => setState(() => _isAvailable = value),
                activeColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? prefixText,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefixText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveAddOn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.addOn == null ? 'Create' : 'Update',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAddOn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final originalPrice = double.parse(_originalPriceController.text);
      final discountPrice = _discountPriceController.text.trim().isNotEmpty
          ? double.parse(_discountPriceController.text)
          : null;
      final stock = int.parse(_stockController.text);

      final addOn = ServiceAddOn(
        id: widget.addOn?.id,
        serviceListingId: widget.serviceListingId,
        name: _nameController.text.trim(),
        originalPrice: originalPrice,
        discountPrice: discountPrice,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        images: widget.addOn?.images ?? [],
        type: _selectedType,
        unit: _selectedUnit,
        stock: stock,
        isAvailable: _isAvailable,
        sortOrder: widget.addOn?.sortOrder ?? 0,
        createdAt: widget.addOn?.createdAt,
        updatedAt: DateTime.now(),
      );

      widget.onSave(addOn);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving add-on: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}