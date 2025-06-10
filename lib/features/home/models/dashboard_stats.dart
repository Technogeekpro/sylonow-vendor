class DashboardStats {
  final double grossSales;
  final double earnings;
  final int totalServiceListings;
  final int totalOrders;
  final DateTime lastUpdated;

  const DashboardStats({
    required this.grossSales,
    required this.earnings,
    required this.totalServiceListings,
    required this.totalOrders,
    required this.lastUpdated,
  });

  // Factory constructor for initial/empty state
  factory DashboardStats.initial() {
    return DashboardStats(
      grossSales: 0.0,
      earnings: 0.0,
      totalServiceListings: 0,
      totalOrders: 0,
      lastUpdated: DateTime.now(),
    );
  }

  // Factory constructor from JSON (for API integration)
  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      grossSales: (json['gross_sales'] ?? 0).toDouble(),
      earnings: (json['earnings'] ?? 0).toDouble(),
      totalServiceListings: json['total_service_listings'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      lastUpdated: DateTime.parse(json['last_updated'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Convert to JSON (for API integration)
  Map<String, dynamic> toJson() {
    return {
      'gross_sales': grossSales,
      'earnings': earnings,
      'total_service_listings': totalServiceListings,
      'total_orders': totalOrders,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  // Helper methods for formatted display
  String get formattedGrossSales => '₹ ${_formatCurrency(grossSales)}';
  String get formattedEarnings => '₹ ${_formatCurrency(earnings)}';
  String get formattedTotalServiceListings => _formatNumber(totalServiceListings);
  String get formattedTotalOrders => _formatNumber(totalOrders);

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  String _formatNumber(int number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(1)}Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  // Copy with method for updates
  DashboardStats copyWith({
    double? grossSales,
    double? earnings,
    int? totalServiceListings,
    int? totalOrders,
    DateTime? lastUpdated,
  }) {
    return DashboardStats(
      grossSales: grossSales ?? this.grossSales,
      earnings: earnings ?? this.earnings,
      totalServiceListings: totalServiceListings ?? this.totalServiceListings,
      totalOrders: totalOrders ?? this.totalOrders,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'DashboardStats(grossSales: $grossSales, earnings: $earnings, totalServiceListings: $totalServiceListings, totalOrders: $totalOrders, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardStats &&
        other.grossSales == grossSales &&
        other.earnings == earnings &&
        other.totalServiceListings == totalServiceListings &&
        other.totalOrders == totalOrders &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode {
    return grossSales.hashCode ^
        earnings.hashCode ^
        totalServiceListings.hashCode ^
        totalOrders.hashCode ^
        lastUpdated.hashCode;
  }
} 