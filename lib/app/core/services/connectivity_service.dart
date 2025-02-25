import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  List<ConnectivityResult> _currentConnectivity = [];

  ConnectivityService() {
    _initConnectivity();
  }

  void _initConnectivity() async {
    // Checking initial connectivity status
    _currentConnectivity = await _connectivity.checkConnectivity();
    notifyListeners();

    // Listening for changes in connectivity
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (!_listsEqual(_currentConnectivity, results)) {
        _currentConnectivity = results;
        notifyListeners();
      }
    });
  }

  List<ConnectivityResult> get currentConnectivity => _currentConnectivity;
  // Getter to check if the device is connected
  bool get isConnected {
    return _currentConnectivity.contains(ConnectivityResult.mobile) ||
        _currentConnectivity.contains(ConnectivityResult.wifi);
  }
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  bool _listsEqual(List<ConnectivityResult> a, List<ConnectivityResult> b) {
    if (a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}