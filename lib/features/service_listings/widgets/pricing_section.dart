import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/add_service_controller.dart';

class PricingSection extends StatefulWidget {
  final AddServiceController controller;

  const PricingSection({
    super.key,
    required this.controller,
  });

  @override
  State<PricingSection> createState() => _PricingSectionState();
}

class _PricingSectionState extends State<PricingSection> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pricing Fields
          _buildSectionTitle('Pricing'),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Original Price',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: widget.controller.originalPriceController,
                      decoration: _buildPriceInputDecoration('Enter price'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: widget.controller.validatePrice,
                      onChanged: (value) => setState(() {}),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Offer Price',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: widget.controller.offerPriceController,
                      decoration: _buildPriceInputDecoration('Discounted price'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: widget.controller.validateOfferPrice,
                      onChanged: (value) => setState(() {}),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Price Preview
          if (widget.controller.originalPriceController.text.isNotEmpty &&
              widget.controller.offerPriceController.text.isNotEmpty)
            _buildPricePreview(),
          
          const SizedBox(height: 24),
          
          // Promotional Tag
          _buildSectionTitle('Promotional Tag (Optional)'),
          const SizedBox(height: 8),
          TextFormField(
            controller: widget.controller.promotionalTagController,
            decoration: _buildInputDecoration(
              'e.g., "Best Deal", "Top Pick"',
              Icons.local_offer_outlined,
            ),
            validator: (_) => null,
          ),
          
          const SizedBox(height: 24),
          
          // Add-ons Section
          _buildSectionTitle('Add-ons (Optional)'),
          const SizedBox(height: 8),
          const Text(
            'Add extra items or services that customers can purchase.',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          _buildAddOnsSection(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppTheme.primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: AppTheme.surfaceColor,
    );
  }

  InputDecoration _buildPriceInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      prefixText: '₹ ',
      prefixStyle: const TextStyle(
        color: AppTheme.textPrimaryColor,
        fontWeight: FontWeight.w500,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: AppTheme.surfaceColor,
    );
  }

  Widget _buildPricePreview() {
    final originalPrice = double.tryParse(widget.controller.originalPriceController.text);
    final offerPrice = double.tryParse(widget.controller.offerPriceController.text);
    
    if (originalPrice == null || offerPrice == null) return const SizedBox();
    
    final discount = ((originalPrice - offerPrice) / originalPrice * 100).round();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price Preview',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹${originalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹${offerPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.successColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$discount% OFF',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddOnsSection() {
    return Column(
      children: [
        // Add-on input form
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: widget.controller.addOnNameController,
                      decoration: _buildInputDecoration(
                        'Add-on name (e.g., Cake)',
                        Icons.add_circle_outline,
                      ),
                      validator: (_) => null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller.addOnPriceController,
                      decoration: _buildPriceInputDecoration('Price (0 for free)'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (_) => null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addAddOn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text(
                    'Add Item',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Add-ons list
        if (widget.controller.addOns.isNotEmpty) ...[
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Added Items:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.controller.addOns.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final addOn = widget.controller.addOns[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            addOn.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            addOn.isFree ? 'Free' : '₹${addOn.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: addOn.isFree ? AppTheme.successColor : AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          widget.controller.removeAddOn(index);
                        });
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppTheme.errorColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  void _addAddOn() {
    if (widget.controller.addOnNameController.text.isNotEmpty &&
        widget.controller.addOnPriceController.text.isNotEmpty) {
      setState(() {
        widget.controller.addAddOn();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill both name and price fields'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }
} 