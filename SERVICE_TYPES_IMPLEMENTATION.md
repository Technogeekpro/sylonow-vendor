# Service Types Implementation

## Overview
The vendor onboarding screen now dynamically fetches service types from the Supabase `service_types` table instead of using hardcoded values. This allows for better management and flexibility in adding new service types.

## Database Schema

### Table: `service_types`
```sql
CREATE TABLE service_types (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for better performance
CREATE INDEX idx_service_types_active ON service_types(is_active);
CREATE INDEX idx_service_types_name ON service_types(name);
```

### Sample Data
```sql
INSERT INTO service_types (name, description, is_active) VALUES
('Plumbing', 'Water supply, drainage, and pipe repair services', true),
('Electrical', 'Electrical installation, repair, and maintenance', true),
('Cleaning', 'Home and office cleaning services', true),
('Carpentry', 'Wood work, furniture repair, and custom carpentry', true),
('Painting', 'Interior and exterior painting services', true),
('AC Repair', 'Air conditioning installation, repair, and maintenance', true),
('Appliance Repair', 'Home appliance repair and maintenance', true),
('Home Maintenance', 'General home maintenance and repair services', true),
('Gardening', 'Landscaping, plant care, and garden maintenance', true),
('Pest Control', 'Pest elimination and prevention services', true);
```

## Implementation Details

### Files Created/Modified

1. **`lib/features/onboarding/service/service_types_service.dart`**
   - Service class to fetch service types from Supabase
   - Includes error handling and logging
   - ServiceType model class with proper JSON serialization

2. **`lib/features/onboarding/providers/service_types_provider.dart`**
   - Riverpod providers for service types state management
   - FutureProvider for async data fetching
   - StateProvider for selected service type

3. **`lib/features/onboarding/screens/vendor_onboarding_screen.dart`**
   - Updated to use ServiceType objects instead of strings
   - Dynamic dropdown with loading and error states
   - Proper error handling with retry functionality

### Key Features

#### 1. **Dynamic Service Types Loading**
- Fetches active service types from database
- Ordered alphabetically for better UX
- Only shows active service types

#### 2. **Robust Error Handling**
- Loading state with spinner
- Error state with retry button
- Graceful fallback for network issues

#### 3. **Type Safety**
- Uses ServiceType model instead of strings
- Proper validation and type checking
- ID-based storage in database

#### 4. **Performance Optimized**
- Cached data using Riverpod
- Efficient database queries with indexes
- Minimal network requests

## Usage

### For Vendors
1. Navigate to vendor onboarding
2. On the "Basic Information" page
3. Service Type dropdown automatically loads available options
4. Select appropriate service type from the list

### For Administrators
1. Add new service types directly in Supabase dashboard
2. Set `is_active = false` to hide service types without deleting
3. Update descriptions to provide better context

## Database Management

### Adding New Service Types
```sql
INSERT INTO service_types (name, description) 
VALUES ('New Service', 'Description of the new service');
```

### Deactivating Service Types
```sql
UPDATE service_types 
SET is_active = false, updated_at = NOW() 
WHERE name = 'Service Name';
```

### Reactivating Service Types
```sql
UPDATE service_types 
SET is_active = true, updated_at = NOW() 
WHERE name = 'Service Name';
```

## Error Handling

### Common Issues and Solutions

1. **No Service Types Loading**
   - Check Supabase connection
   - Verify table exists and has data
   - Check RLS policies if enabled

2. **Service Type Not Saving**
   - Ensure service type ID is being passed correctly
   - Check vendor table schema accepts UUID for service_type

3. **Performance Issues**
   - Verify database indexes are created
   - Check network connectivity
   - Consider caching strategies

## Future Enhancements

1. **Service Categories**
   - Group service types into categories
   - Hierarchical service selection

2. **Service Pricing**
   - Add base pricing information
   - Service-specific pricing models

3. **Service Availability**
   - Location-based service availability
   - Time-based service restrictions

4. **Service Requirements**
   - Skill level requirements
   - Certification requirements

## Testing

### Manual Testing Steps
1. Open vendor onboarding screen
2. Navigate to basic information page
3. Verify service types dropdown loads
4. Test selection and form submission
5. Verify service type ID is saved correctly

### Database Verification
```sql
-- Check if service types are being fetched
SELECT * FROM service_types WHERE is_active = true ORDER BY name;

-- Verify vendor service type assignment
SELECT v.full_name, st.name as service_type 
FROM vendors v 
JOIN service_types st ON v.service_type = st.id;
```

## Security Considerations

1. **Row Level Security (RLS)**
   - Enable RLS on service_types table if needed
   - Allow public read access for active service types

2. **Input Validation**
   - Validate service type exists before saving
   - Prevent injection attacks

3. **Data Integrity**
   - Foreign key constraints
   - Proper data validation

## Conclusion

The service types implementation provides a flexible, maintainable solution for managing vendor service categories. It improves the user experience with dynamic loading and proper error handling while maintaining data integrity and performance. 