import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/service_addon.dart';

class ServiceAddonCard extends StatelessWidget {
  final ServiceAddon addon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ServiceAddonCard({
    super.key,
    required this.addon,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Addon Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.surfaceColor,
                      image: addon.images.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(addon.images.first),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: addon.images.isEmpty
                        ? Icon(
                            Icons.add_box_outlined,
                            color: AppTheme.primaryColor,
                            size: 30,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  // Addon Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          addon.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        if (addon.description?.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(
                            addon.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondaryColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Price
                            if (addon.discountPrice != null &&
                                addon.discountPrice! < addon.originalPrice) ...[
                              Text(
                                '₹${addon.discountPrice!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹${addon.originalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textSecondaryColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ] else ...[
                              Text(
                                '\$${addon.originalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete' && onDelete != null) {
                        onDelete!();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Stock and Type Info
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      addon.type.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (addon.stock != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (addon.stock ?? 0) > 0
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Stock: ${addon.stock}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: (addon.stock ?? 0) > 0
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${addon.quantity} ${addon.unit}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
