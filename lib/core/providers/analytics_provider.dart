import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/firebase_analytics_service.dart';

final analyticsServiceProvider = Provider<FirebaseAnalyticsService>((ref) {
  return FirebaseAnalyticsService();
});
