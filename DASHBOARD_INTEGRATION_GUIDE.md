# Dashboard Integration Guide

## Overview
The home screen dashboard has been updated to show initial values of 0 for all statistics cards and includes a proper data structure for future integration with real backend data.

## Current Implementation

### Dashboard Statistics Cards
- **Gross Sales**: ₹ 0
- **Earnings**: ₹ 0  
- **Total Products**: 0
- **Total Orders**: 0

### Architecture

#### 1. **Data Model** (`lib/features/home/models/dashboard_stats.dart`)
```dart
class DashboardStats {
  final double grossSales;
  final double earnings;
  final int totalProducts;
  final int totalOrders;
  final DateTime lastUpdated;
}
```

**Features:**
- ✅ Formatted display methods (`formattedGrossSales`, `formattedEarnings`, etc.)
- ✅ Smart number formatting (K, L, Cr for large numbers)
- ✅ JSON serialization for API integration
- ✅ Initial/empty state factory constructor

#### 2. **Provider** (`lib/features/home/providers/dashboard_provider.dart`)
```dart
final dashboardStatsProvider = AsyncNotifierProvider<DashboardStatsNotifier, DashboardStats>
```

**Features:**
- ✅ Watches auth state changes
- ✅ Returns initial stats (all zeros) by default
- ✅ Error handling with fallback to zero values
- ✅ Manual refresh capability
- ✅ Real-time update methods

#### 3. **UI Components** (`lib/features/home/screens/home_screen.dart`)
- ✅ Loading skeleton states
- ✅ Error handling with retry button
- ✅ Refresh button in header
- ✅ Responsive design

## Integration with Real Data

### Step 1: Create Database Tables
Create the following table in Supabase:

```sql
CREATE TABLE vendor_dashboard_stats (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  vendor_id UUID REFERENCES vendors(id) ON DELETE CASCADE,
  gross_sales DECIMAL(12,2) DEFAULT 0,
  earnings DECIMAL(12,2) DEFAULT 0,
  total_products INTEGER DEFAULT 0,
  total_orders INTEGER DEFAULT 0,
  last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX idx_vendor_dashboard_stats_vendor_id ON vendor_dashboard_stats(vendor_id);

-- Create RLS policies
ALTER TABLE vendor_dashboard_stats ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Vendors can view own dashboard stats" ON vendor_dashboard_stats
  FOR SELECT USING (vendor_id = auth.uid());

CREATE POLICY "Vendors can update own dashboard stats" ON vendor_dashboard_stats
  FOR UPDATE USING (vendor_id = auth.uid());
```

### Step 2: Update the Provider
Replace the `_fetchDashboardStats` method in `dashboard_provider.dart`:

```dart
Future<DashboardStats> _fetchDashboardStats(String userId) async {
  try {
    final response = await SupabaseConfig.client
        .from('vendor_dashboard_stats')
        .select('*')
        .eq('vendor_id', userId)
        .maybeSingle();
    
    if (response == null) {
      // Create initial stats record for new vendor
      await SupabaseConfig.client
          .from('vendor_dashboard_stats')
          .insert({
            'vendor_id': userId,
            'gross_sales': 0,
            'earnings': 0,
            'total_products': 0,
            'total_orders': 0,
          });
      
      return DashboardStats.initial();
    }
    
    return DashboardStats.fromJson(response);
  } catch (e) {
    print('Error fetching dashboard stats: $e');
    return DashboardStats.initial();
  }
}
```

### Step 3: Create Update Triggers
Set up database triggers to automatically update dashboard stats when orders/products change:

```sql
-- Function to update dashboard stats
CREATE OR REPLACE FUNCTION update_vendor_dashboard_stats()
RETURNS TRIGGER AS $$
BEGIN
  -- Update stats when orders are inserted/updated/deleted
  INSERT INTO vendor_dashboard_stats (vendor_id, gross_sales, earnings, total_orders, last_updated)
  SELECT 
    v.id,
    COALESCE(SUM(o.total_amount), 0) as gross_sales,
    COALESCE(SUM(o.vendor_earnings), 0) as earnings,
    COUNT(o.id) as total_orders,
    NOW()
  FROM vendors v
  LEFT JOIN orders o ON o.vendor_id = v.id
  WHERE v.id = COALESCE(NEW.vendor_id, OLD.vendor_id)
  GROUP BY v.id
  ON CONFLICT (vendor_id) 
  DO UPDATE SET
    gross_sales = EXCLUDED.gross_sales,
    earnings = EXCLUDED.earnings,
    total_orders = EXCLUDED.total_orders,
    last_updated = EXCLUDED.last_updated;
    
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Create triggers
CREATE TRIGGER trigger_update_dashboard_stats_on_orders
  AFTER INSERT OR UPDATE OR DELETE ON orders
  FOR EACH ROW EXECUTE FUNCTION update_vendor_dashboard_stats();
```

### Step 4: Real-time Updates (Optional)
Add real-time subscriptions for live dashboard updates:

```dart
void _setupRealtimeSubscription() {
  final currentUser = ref.read(currentUserProvider);
  if (currentUser == null) return;
  
  SupabaseConfig.client
    .from('vendor_dashboard_stats')
    .stream(primaryKey: ['id'])
    .eq('vendor_id', currentUser.id)
    .listen((data) {
      if (data.isNotEmpty) {
        final stats = DashboardStats.fromJson(data.first);
        state = AsyncData(stats);
      }
    });
}
```

## Testing the Integration

### 1. **Test with Sample Data**
```dart
// Temporarily add sample data in _fetchDashboardStats for testing
return DashboardStats(
  grossSales: 230440.0,
  earnings: 60020.0,
  totalProducts: 107,
  totalOrders: 1043,
  lastUpdated: DateTime.now(),
);
```

### 2. **Test Error Handling**
- Disconnect internet to test error states
- Test with invalid user IDs
- Verify fallback to zero values

### 3. **Test Loading States**
- Add artificial delays to see skeleton loading
- Test refresh functionality

## Current Features

✅ **Zero Initial Values**: All cards show 0 by default  
✅ **Smart Formatting**: Large numbers display as K, L, Cr  
✅ **Loading States**: Skeleton placeholders during data fetch  
✅ **Error Handling**: Graceful fallback with retry option  
✅ **Refresh Capability**: Manual refresh button  
✅ **Responsive Design**: Works on all screen sizes  
✅ **Type Safety**: Full TypeScript/Dart type checking  

## Future Enhancements

- 📊 **Charts & Graphs**: Add visual representations of data
- 📈 **Trends**: Show percentage changes and trends
- 🔄 **Auto-refresh**: Periodic automatic data updates
- 📱 **Push Notifications**: Real-time alerts for new orders
- 📊 **Analytics**: Detailed breakdown of earnings and sales
- 🎯 **Goals**: Set and track business targets 