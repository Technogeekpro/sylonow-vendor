import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamController<bool>? _connectivityController;

  // Stream to listen to connectivity changes
  Stream<bool> get connectivityStream {
    _connectivityController ??= StreamController<bool>.broadcast();
    
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) async {
      final hasConnection = await _checkInternetConnection(results);
      _connectivityController?.add(hasConnection);
    });

    return _connectivityController!.stream;
  }

  // Check current internet connection status
  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      return await _checkInternetConnection(connectivityResults);
    } catch (e) {
      return false;
    }
  }

  // Check if there's actual internet connectivity (not just network connection)
  Future<bool> _checkInternetConnection(List<ConnectivityResult> results) async {
    // If no connectivity results or contains none, return false
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }

    // Check if we have mobile or wifi connection
    if (results.contains(ConnectivityResult.mobile) || 
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet)) {
      
      // Verify actual internet access by pinging a reliable server
      return await _pingInternet();
    }

    return false;
  }

  // Ping internet to verify actual connectivity
  Future<bool> _pingInternet() async {
    try {
      // Try to reach Google's DNS servers
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
    
    return false;
  }

  // Get connectivity status as string for display
  Future<String> getConnectivityStatus() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      
      if (connectivityResults.isEmpty || connectivityResults.contains(ConnectivityResult.none)) {
        return 'No Connection';
      }
      
      if (connectivityResults.contains(ConnectivityResult.wifi)) {
        final hasInternet = await _pingInternet();
        return hasInternet ? 'WiFi Connected' : 'WiFi - No Internet';
      }
      
      if (connectivityResults.contains(ConnectivityResult.mobile)) {
        final hasInternet = await _pingInternet();
        return hasInternet ? 'Mobile Data Connected' : 'Mobile Data - No Internet';
      }
      
      if (connectivityResults.contains(ConnectivityResult.ethernet)) {
        final hasInternet = await _pingInternet();
        return hasInternet ? 'Ethernet Connected' : 'Ethernet - No Internet';
      }
      
      return 'Unknown Connection';
    } catch (e) {
      return 'Connection Error';
    }
  }

  // Dispose resources
  void dispose() {
    _connectivityController?.close();
    _connectivityController = null;
  }
}