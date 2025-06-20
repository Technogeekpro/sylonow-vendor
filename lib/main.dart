import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylonow_vendor/core/theme/app_theme.dart';
import 'core/config/router_config.dart';
import 'core/config/supabase_config.dart';
import 'core/services/google_auth_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase using the config class
  await SupabaseConfig.initialize();
  
  // Initialize Google Auth Service
  GoogleAuthService().initialize();
  
  // Clean up old temporary files
  await _cleanupOldTempFiles();

  runApp(const ProviderScope(child: MyApp()));
}

/// Clean up old temporary image files on app startup
Future<void> _cleanupOldTempFiles() async {
  try {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory tempImagesDir = Directory(path.join(appDir.path, 'temp_images'));
    
    if (await tempImagesDir.exists()) {
      final List<FileSystemEntity> files = tempImagesDir.listSync();
      final DateTime cutoffTime = DateTime.now().subtract(const Duration(days: 1));
      
      for (final file in files) {
        if (file is File) {
          final stat = await file.stat();
          if (stat.modified.isBefore(cutoffTime)) {
            try {
              await file.delete();
              print('🧹 Cleaned up old temp file: ${file.path}');
            } catch (e) {
              print('⚠️ Failed to cleanup old temp file: ${file.path}');
            }
          }
        }
      }
    }
  } catch (e) {
    print('⚠️ Error during temp file cleanup: $e');
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    
    return MaterialApp.router(
      title: 'SyloNow Vendor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
