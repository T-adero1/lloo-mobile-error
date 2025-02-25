import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:magic_sdk/modules/web3/eth_network.dart';
import 'package:lloo_mobile/app/debug/channel_logger.dart' as L;
import 'dart:convert';
import 'dart:typed_data';

/// Possible states for the Magic authentication flow
enum MagicAuthState {
  otpSent,
  invalidOtp,
  success,
  error
}

/// Result of a Magic authentication event
class MagicAuthResult {
  final MagicAuthState state;
  final String? didToken;
  final String? error;

  MagicAuthResult({
    required this.state,
    this.didToken,
    this.error,
  });

  @override
  String toString() => 'MagicAuthResult(state: $state, didToken: $didToken, error: $error)';
}

/// Service for handling Magic Link authentication through a hidden WebView
class MagicService extends GetxService {
  final String apiKey;
  final String network;

  MagicService({
    required this.apiKey,
    required this.network,
  }) {
    L.debug('MAGIC_SERVICE', 'Created MagicService with network: ${network}');
  }

  WebViewController? _webViewController;
  final _isInitialized = false.obs;
  OverlayEntry? _overlayEntry;
  BuildContext? _overlayContext;
  
  // Single stream controller for all auth events
  StreamController<MagicAuthResult>? _authEvents;
  
  // Expose stream
  Stream<MagicAuthResult> get authEvents => 
    _authEvents?.stream ?? (throw Exception('Service not initialized'));

  /// Initialize the Magic WebView service
  /// Must be called with the root context for overlay management
  Future<void> init({BuildContext? context}) async {
    L.info('MAGIC_SERVICE', 'Initializing Magic service...');
    
    // If already initialized with same context, skip
    if (_isInitialized.value) {
      L.warn('MAGIC_SERVICE', 'Service already initialized');
      return;
    }
    
    // Clean up any existing resources
    await dispose();
    
    // Get the context and verify it has an overlay
    final overlayContext = context ?? Get.context;
    if (overlayContext == null) {
      throw Exception('Cannot initialize Magic service: No context available');
    }
    
    // Find the nearest Overlay
    final overlay = Overlay.maybeOf(overlayContext);
    if (overlay == null) {
      throw Exception('Cannot initialize Magic service: No Overlay widget found in context. Make sure to initialize after MaterialApp is ready.');
    }
    
    _overlayContext = overlayContext;
    _authEvents = StreamController<MagicAuthResult>.broadcast();

    // Load the Magic SDK JavaScript
    L.debug('MAGIC_SERVICE', 'Loading Magic SDK JavaScript...');
    final magicSdkJs = await rootBundle.loadString('assets/js/magic-sdk.js');
    
    L.debug('MAGIC_SERVICE', 'Initializing Magic SDK with apiKey: $apiKey, network: $network');
    
    bool pageLoaded = false;
    
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            L.debug('MAGIC_SERVICE', 'WebView page started loading: $url');
          },
          onPageFinished: (url) {
            L.debug('MAGIC_SERVICE', 'WebView page finished loading: $url');
            pageLoaded = true;
          },
          onNavigationRequest: (request) {
            L.debug('MAGIC_SERVICE', 'Navigation requested to: ${request.url}');
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            L.error('MAGIC_SERVICE', 'WebView error: ${error.description} (${error.errorCode})');
            if (!pageLoaded) {
              L.error('MAGIC_SERVICE', 'Initial page load failed, trying with data URL');
              _webViewController!.loadRequest(
                Uri.parse('data:text/html;base64,${base64Encode(utf8.encode('''
                  <!DOCTYPE html>
                  <html>
                    <head>
                      <meta charset="utf-8">
                      <meta name="viewport" content="width=device-width, initial-scale=1.0">
                      <meta http-equiv="Content-Security-Policy" content="default-src * 'unsafe-inline' 'unsafe-eval' data: blob:;">
                    </head>
                    <body style="margin:0;padding:0;background:transparent">
                      <div id="magic-iframe"></div>
                    </body>
                  </html>
                '''))}')
              );
            }
          },
        ),
      )
      ..addJavaScriptChannel(
        'MagicFlutter',
        onMessageReceived: _handleJavaScriptMessage,
      )
      ..addJavaScriptChannel(
        'Console',
        onMessageReceived: (message) {
          L.debug('MAGIC_SERVICE:JS', message.message);
        },
      );

    // Try loading example.com first
    await _webViewController!.loadRequest(
      Uri.parse('https://example.com')
    );

    // Wait for either page load or timeout
    await Future.any([
      Future.delayed(const Duration(seconds: 5)).then((_) {
        if (!pageLoaded) {
          L.warn('MAGIC_SERVICE', 'Page load timed out, proceeding anyway');
        }
      }),
      Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return !pageLoaded;
      })
    ]);

    // Add console overrides and initialize Magic SDK
    await _webViewController!.runJavaScript('''
      // Clear existing content while keeping secure context
      document.body.innerHTML = '<div id="magic-iframe"></div>';
      document.head.innerHTML = '';
      document.body.style.margin = '0';
      document.body.style.padding = '0';
      document.body.style.background = 'transparent';

      // Console override with timestamps
      console = {
        log: function(msg) { 
          Console.postMessage(new Date().toLocaleTimeString() + '  🐛 DEBUG  ' + (typeof msg === 'object' ? JSON.stringify(msg) : msg)); 
        },
        error: function(msg) { 
          Console.postMessage(new Date().toLocaleTimeString() + '  ❌ ERROR  ' + (typeof msg === 'object' ? JSON.stringify(msg) : msg)); 
        },
        warn: function(msg) { 
          Console.postMessage(new Date().toLocaleTimeString() + '  ⚠️ WARN   ' + (typeof msg === 'object' ? JSON.stringify(msg) : msg)); 
        }
      };

      // Debug WebView environment
      console.log('WebView environment check:');
      console.log('window.crypto: ' + (typeof window.crypto));
      console.log('window.crypto.subtle: ' + (window.crypto ? typeof window.crypto.subtle : 'N/A'));
      console.log('isSecureContext: ' + window.isSecureContext);
      console.log('protocol: ' + window.location.protocol);

      // Load Magic SDK with error handling
      try {
        const script = document.createElement('script');
        script.src = '$magicSdkJs';
        script.onload = function() {
          console.log('Magic SDK script loaded successfully');
          checkWebCrypto().then(() => {
            console.log('WebCrypto available, initializing Magic SDK...');
            const magic = new Magic('$apiKey', {
              network: '$network',
              platform: 'flutter'
            });
            window.magic = magic;
            console.log('Magic SDK initialized successfully');
            MagicFlutter.postMessage(JSON.stringify({
              event: 'init',
              status: 'OK'
            }));
          }).catch(error => {
            console.error('WebCrypto check failed:', error);
            MagicFlutter.postMessage(JSON.stringify({
              event: 'init',
              status: error.message || 'WebCrypto not available'
            }));
          });
        };
        script.onerror = function(error) {
          console.error('Failed to load Magic SDK script:', error);
          MagicFlutter.postMessage(JSON.stringify({
            event: 'init',
            status: 'Failed to load Magic SDK script'
          }));
        };
        document.head.appendChild(script);
      } catch (error) {
        console.error('Error during Magic SDK initialization:', error);
        MagicFlutter.postMessage(JSON.stringify({
          event: 'init',
          status: 'Error during initialization: ' + error
        }));
      }

      // Check WebCrypto availability
      function checkWebCrypto() {
        return new Promise((resolve, reject) => {
          if (window.crypto && window.crypto.subtle) {
            // Test WebCrypto with a simple operation
            window.crypto.subtle.digest('SHA-256', new TextEncoder().encode('test'))
              .then(() => {
                console.log('WebCrypto API verified working');
                resolve();
              })
              .catch(error => {
                console.error('WebCrypto API available but not working:', error);
                reject(new Error('WebCrypto API not working: ' + error.message));
              });
          } else {
            console.error('WebCrypto API not available');
            reject(new Error('WebCrypto API not available'));
          }
        });
      }
    ''');
    
    // Verify WebCrypto and Magic SDK initialization
    try {
      final checkResult = await _webViewController!.runJavaScriptReturningResult('''
        (function() {
          if (!window.crypto || !window.crypto.subtle) {
            return 'WebCrypto API not available';
          }
          if (typeof magic === 'undefined' || magic === null) {
            return 'Magic SDK not initialized';
          }
          return 'OK';
        })()
      ''');
      
      if (checkResult != 'OK') {
        L.error('MAGIC_SERVICE', 'Initialization check failed: $checkResult');
        throw Exception('Failed to initialize Magic service: $checkResult');
      }
      
      L.debug('MAGIC_SERVICE', 'Magic SDK initialized successfully');
    } catch (e) {
      L.error('MAGIC_SERVICE', 'Failed to verify initialization: $e');
      throw Exception('Failed to initialize Magic service: $e');
    }
    
    // Create and insert overlay
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        top: 0,
        child: Opacity(
          opacity: 0,
          child: SizedBox(
            width: 1,
            height: 1,
            child: WebViewWidget(controller: _webViewController!),
          ),
        ),
      ),
    );

    // Insert overlay into the root context
    if (_overlayContext != null && _overlayContext!.mounted) {
      try {
        Overlay.of(_overlayContext!).insert(_overlayEntry!);
      } catch (e) {
        L.error('MAGIC_SERVICE', 'Failed to insert overlay: $e');
      }
    } else {
      L.error('MAGIC_SERVICE', 'Failed to initialize - invalid overlay context');
      throw Exception('Invalid overlay context provided');
    }
  }

  /// Dispose of all resources used by the service
  Future<void> dispose() async {
    L.debug('MAGIC_SERVICE', 'Disposing Magic service...');
    _removeOverlay();
    await _authEvents?.close();
    _authEvents = null;
    _isInitialized.value = false;
    
    // Dispose of WebViewController resources
    await _webViewController?.clearCache();
    await _webViewController?.clearLocalStorage();
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _overlayContext = null;
  }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      final data = jsonDecode(message.message);
      
      if (data['event'] == 'init') {
        if (data['status'] == 'OK') {
          L.debug('MAGIC_SERVICE', 'Magic SDK initialized successfully');
          _isInitialized.value = true;
        } else {
          L.error('MAGIC_SERVICE', 'Magic SDK initialization failed: ${data['status']}');
          _authEvents?.add(MagicAuthResult(
            state: MagicAuthState.error,
            error: data['status']
          ));
        }
        return;
      }

      switch (data['event']) {
        case 'otpSent':
          L.info('MAGIC_SERVICE', 'OTP sent successfully');
          _authEvents!.add(MagicAuthResult(state: MagicAuthState.otpSent));
          break;
        case 'invalidOtp':
          L.info('MAGIC_SERVICE', 'Invalid OTP entered');
          _authEvents!.add(MagicAuthResult(state: MagicAuthState.invalidOtp));
          break;
        case 'success':
          L.info('MAGIC_SERVICE', 'Login successful');
          _authEvents!.add(MagicAuthResult(
            state: MagicAuthState.success,
            didToken: data['didToken'],
          ));
          break;
        case 'error':
          L.error('MAGIC_SERVICE', 'Login error: ${data['error']}');
          _authEvents!.add(MagicAuthResult(
            state: MagicAuthState.error,
            error: data['error'],
          ));
          break;
      }
    } catch (e) {
      L.error('MAGIC_SERVICE', 'Failed to handle JavaScript message: $e');
    }
  }

  /// Get the wallet address for the currently logged in user
  Future<String?> getWalletAddress() async {
    if (_webViewController == null) {
      L.error('MAGIC_SERVICE', 'Magic service not initialized!');
      throw Exception('Magic service not initialized!');
    }
    try {
      final result = await _webViewController!.runJavaScriptReturningResult('''
        (async () => {
          try {
            const userInfo = await magic.user.getInfo();
            return userInfo.publicAddress;
          } catch (e) {
            console.error('Failed to get wallet address:', e);
            return null;
          }
        })()
      ''');
      
      return result?.toString();
    } catch (e) {
      L.error('MAGIC_SERVICE', 'Failed to get wallet address: $e');
      return null;
    }
  }

  /// Check if a user is currently logged in
  Future<bool> isLoggedIn() async {
    if (_webViewController == null) {
      L.error('MAGIC_SERVICE', 'Magic service not initialized!');
      throw Exception('Magic service not initialized!');
    }
    try {
      final result = await _webViewController!.runJavaScriptReturningResult('''
        (async () => {
          try {
            return await magic.user.isLoggedIn();
          } catch (e) {
            console.error('Failed to check login status:', e);
            return false;
          }
        })()
      ''');
      
      return result == true;
    } catch (e) {
      L.error('MAGIC_SERVICE', 'Failed to check login status: $e');
      return false;
    }
  }

  /// Logout the current user
  Future<void> logout() async {
    if (_webViewController == null) {
      L.error('MAGIC_SERVICE', 'Magic service not initialized!');
      throw Exception('Magic service not initialized!');
    }
    try {
      await _webViewController!.runJavaScript('''
        (async () => {
          try {
            await magic.user.logout();
          } catch (e) {
            console.error('Failed to logout:', e);
          }
        })()
      ''');
    } catch (e) {
      L.error('MAGIC_SERVICE', 'Failed to logout: $e');
    }
  }

  /// Start the email OTP login process
  /// 
  /// Listen to [authEvents] stream to handle the login flow states
  Future<void> startEmailLogin(String email) async {
    L.debug('MAGIC_SERVICE', 'Starting email login for: $email');
    
    if (_webViewController == null) {
      throw Exception('Cannot start email login: WebView controller not initialized');
    }
    
    try {
      await _webViewController!.runJavaScript('''
        console.log('Starting email login for: $email');
        startEmailLogin("$email");
        console.log('Email login JavaScript executed');
      ''');
      L.debug('MAGIC_SERVICE', 'Email login JavaScript executed');
    } catch (e) {
      L.error('MAGIC_SERVICE', 'Failed to execute email login JavaScript: $e');
      throw Exception('Failed to start email login: $e');
    }
  }

  /// Submit the OTP for verification
  Future<void> verifyOtp(String otp) async {
    if (!_isInitialized.value) {
      throw Exception('MagicService not initialized. Call init() first.');
    }
    
    L.info('MAGIC_SERVICE', 'Verifying OTP...');
    await _webViewController!.runJavaScript(
      'verifyOtp("$otp")'
    );
  }

  /// Cancel the current login attempt
  Future<void> cancelLogin() async {
    if (!_isInitialized.value) {
      throw Exception('MagicService not initialized. Call init() first.');
    }
    
    L.info('MAGIC_SERVICE', 'Cancelling login...');
    await _webViewController!.runJavaScript('cancelLogin()');
  }
}
