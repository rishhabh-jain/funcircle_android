// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:webview_flutter/webview_flutter.dart';

class CustomWebViewPage extends StatefulWidget {
  final String initialUrl;
  final String logoAssetPath;

  const CustomWebViewPage({
    Key? key,
    required this.initialUrl,
    this.logoAssetPath = 'assets/images/logo.png',
  }) : super(key: key);

  @override
  State<CustomWebViewPage> createState() => _CustomWebViewPageState();
}

class _CustomWebViewPageState extends State<CustomWebViewPage> {
  late WebViewController _controller;
  bool _canGoBack = false;
  String _currentUrl = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentUrl = widget.initialUrl;

    // Initialize WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _currentUrl = url;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
              _currentUrl = url;
            });

            // Check if we can go back
            final canGoBack = await _controller.canGoBack();
            setState(() {
              _canGoBack = canGoBack;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // Allow all navigation requests
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  Future<void> _goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  _controller.loadRequest(Uri.parse(widget.initialUrl));
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Reload'),
                onTap: () {
                  Navigator.pop(context);
                  _controller.reload();
                },
              ),
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: const Text('Open in Browser'),
                onTap: () {
                  Navigator.pop(context);
                  // Add your logic to open in external browser
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 16,
              right: 16,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Back button (only show if can go back in WebView)
                if (_canGoBack)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: _goBack,
                    tooltip: 'Go Back',
                  )
                else
                  // Close/Exit button when on initial page
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                  ),

                const SizedBox(width: 8),

                // Logo
                Container(
                  height: 32,
                  child: Image.asset(
                    widget.logoAssetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if logo asset is not found
                      return const Text(
                        'LOGO',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(),

                // Current URL indicator (optional)
                if (_currentUrl != widget.initialUrl)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      Uri.parse(_currentUrl).host,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),

                const SizedBox(width: 8),

                // Menu button
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onPressed: _showMenu,
                  tooltip: 'Menu',
                ),
              ],
            ),
          ),

          // Loading indicator
          if (_isLoading)
            const LinearProgressIndicator(
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),

          // WebView
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}

// Usage in FlutterFlow:
// You can create this as a Custom Widget and use it in your FlutterFlow app
//
// To use in FlutterFlow:
// 1. Add this code as a Custom Widget
// 2. Add the required dependencies in pubspec.yaml:
//    - webview_flutter: ^4.4.2
// 3. Call it like this:

class WebViewScreen extends StatelessWidget {
  final String url;

  const WebViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomWebViewPage(
      initialUrl: url,
      logoAssetPath:
          'assets/images/your_logo.png', // Update with your logo path
    );
  }
}

// Alternative simpler approach for FlutterFlow Custom Action:
Future<void> openWebViewWithHeader(
  BuildContext context,
  String url,
) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CustomWebViewPage(
        initialUrl: url,
        logoAssetPath: 'assets/images/logo.png',
      ),
    ),
  );
}
