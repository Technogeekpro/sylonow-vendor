import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/supabase_config.dart';

final serviceTypesServiceProvider = Provider((ref) => ServiceTypesService());

class ServiceTypesService {
  final SupabaseClient _client = SupabaseConfig.client;
  static const String _tableName = 'service_types';

  /// Fetch all active service types from the database
  Future<List<ServiceType>> getServiceTypes() async {
    try {
      print('🔵 ServiceTypesService: Fetching service types from database');
      
      final response = await _client
          .from(_tableName)
          .select('id, name, description, is_active')
          .eq('is_active', true)
          .order('name', ascending: true);
      
      print('🔵 ServiceTypesService: Found ${response.length} service types');
      
      return response.map((json) => ServiceType.fromJson(json)).toList();
    } catch (e) {
      print('🔴 ServiceTypesService: Error fetching service types: $e');
      throw Exception('Failed to fetch service types: $e');
    }
  }

  /// Get a specific service type by ID
  Future<ServiceType?> getServiceTypeById(String id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select('id, name, description, is_active')
          .eq('id', id)
          .eq('is_active', true)
          .maybeSingle();
      
      if (response == null) return null;
      
      return ServiceType.fromJson(response);
    } catch (e) {
      print('🔴 ServiceTypesService: Error fetching service type by ID: $e');
      throw Exception('Failed to fetch service type: $e');
    }
  }
}

/// Model class for service types
class ServiceType {
  final String id;
  final String name;
  final String? description;
  final bool isActive;

  ServiceType({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
  });

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_active': isActive,
    };
  }

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceType && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
} 