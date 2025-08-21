import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_theme.dart';
import '../../service_listings/models/service_add_on.dart';

class AddOnCard extends StatelessWidget {
  final ServiceAddOn addOn;
  final VoidCallback? onTap;
  final Function(bool)? onToggleAvailability;
  final VoidCallback? onDelete;
  final Function(int)? onUpdateStock;

  const AddOnCard({
    super.key,
    required this.addOn,
    this.onTap,
    this.onToggleAvailability,
    this.onDelete,
    this.onUpdateStock,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              _buildContent(context),
              const SizedBox(height: 12),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // Add-on Image or Icon
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: addOn.images.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    addOn.images.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(context),
                  ),
                )
              : _buildFallbackIcon(context),
        ),
        const SizedBox(width: 12),
        // Add-on Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      addOn.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildTypeChip(context),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    addOn.formattedEffectivePrice,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  if (addOn.hasDiscount) ...[
                    const SizedBox(width: 8),
                    Text(
                      addOn.formattedOriginalPrice,
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${addOn.discountPercentage}% OFF',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.successColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        // Status Toggle
        Switch(
          value: addOn.isAvailable,
          onChanged: onToggleAvailability,
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildFallbackIcon(BuildContext context) {
    IconData icon;
    switch (addOn.type) {
      case 'upgrade':
        icon = Icons.upgrade;
        break;
      case 'accessory':
        icon = Icons.extension;
        break;
      default:
        icon = Icons.add_circle_outline;
    }

    return Icon(
      icon,
      color: Theme.of(context).primaryColor,
      size: 24,
    );
  }

  Widget _buildTypeChip(BuildContext context) {
    Color chipColor;
    switch (addOn.type) {
      case 'upgrade':
        chipColor = AppTheme.accentBlue;
        break;
      case 'accessory':
        chipColor = AppTheme.accentTeal;
        break;
      default:
        chipColor = Theme.of(context).primaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        addOn.typeDisplayName,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: chipColor,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (addOn.description == null || addOn.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Text(
      addOn.description!,
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).textTheme.bodyMedium?.color,
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        // Stock Information
        Expanded(
          child: Row(
            children: [
              HeroIcon(
                HeroIcons.cube,
                size: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 6),
              Text(
                '${addOn.stock} ${addOn.unitDisplayName}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: addOn.inStock ? AppTheme.successColor.withValues(alpha: 0.1) : AppTheme.errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  addOn.stockStatusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: addOn.inStock ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Action Buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onUpdateStock != null)
              IconButton(
                onPressed: () => _showStockUpdateDialog(context),
                icon: HeroIcon(
                  HeroIcons.pencilSquare,
                  size: 18,
                  color: Theme.of(context).primaryColor,
                ),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: const EdgeInsets.all(4),
              ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: HeroIcon(
                  HeroIcons.trash,
                  size: 18,
                  color: Theme.of(context).colorScheme.error,
                ),
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: const EdgeInsets.all(4),
              ),
          ],
        ),
      ],
    );
  }

  void _showStockUpdateDialog(BuildContext context) {
    final controller = TextEditingController(text: addOn.stock.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Update stock for "${addOn.name}"'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Stock quantity',
                suffixText: addOn.unit,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final stock = int.tryParse(controller.text);
              if (stock != null && stock >= 0) {
                onUpdateStock?.call(stock);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}