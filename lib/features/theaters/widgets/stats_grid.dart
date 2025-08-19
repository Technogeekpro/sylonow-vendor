import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../models/dashboard_stats.dart' as ds;

class StatsGrid extends StatelessWidget {
  final ds.DashboardStats? stats;
  final bool isLoading;

  const StatsGrid({
    super.key,
    this.stats,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    double childAspectRatio = 0.95;
    
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
      childAspectRatio = 1.3;
    } else if (screenWidth >= 600) {
      crossAxisCount = 2;
      childAspectRatio = 1.4;
    }

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: childAspectRatio,
      children: [
        _StatCard(
          path: 'assets/animations/growth.json',
          label: 'Gross Sales',
          value: _formatCurrency(stats?.grossSales ?? 0),
          color: AppTheme.successColor,
          isLoading: isLoading,
          onTap: null, // Non-clickable
        ),
        _StatCard(
          path: 'assets/animations/earning.json',
          label: 'Earnings',
          value: _formatCurrency(stats?.totalEarnings ?? 0),
          color: AppTheme.primaryColor,
          isLoading: isLoading,
          onTap: null, // Non-clickable
        ),
        _StatCard(
          path: 'assets/animations/orders.json',
          label: 'Total Orders',
          value: '${stats?.totalOrders ?? 0}',
          color: AppTheme.accentBlue,
          isLoading: isLoading,
          onTap: (context) => context.push('/theater-bookings'),
        ),
        _StatCard(
          path: 'assets/animations/theater.json',
          label: 'Theaters Added',
          value: '${stats?.totalTheaters ?? 0}',
          color: AppTheme.accentTeal,
          isLoading: isLoading,
          onTap: (context) => context.push('/vendor-theaters'),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${amount.toStringAsFixed(0)}';
    }
  }
}

class _StatCard extends StatelessWidget {
  final String path;
  final String label;
  final String value;
  final Color color;
  final bool isLoading;
  final void Function(BuildContext)? onTap;

  const _StatCard({
    required this.path,
    required this.label,
    required this.value,
    required this.color,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            
            child: Lottie.asset(
              path,
             
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (isLoading)
                  Container(
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )
                else
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap!(context),
          borderRadius: BorderRadius.circular(16),
          child: cardContent,
        ),
      );
    }
    
    return cardContent;
  }
}