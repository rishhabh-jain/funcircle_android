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

import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWithUrlTracking extends StatefulWidget {
  const WebViewWithUrlTracking({
    Key? key,
    this.width,
    this.height,
    required this.initialUrl,
    this.onUrlChanged,
    this.triggerBack,
    this.triggerForward,
    this.triggerRefresh,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String initialUrl;
  final Function(String)? onUrlChanged;
  final bool? triggerBack;
  final bool? triggerForward;
  final bool? triggerRefresh;

  @override
  State<WebViewWithUrlTracking> createState() => _WebViewWithUrlTrackingState();
}

class _WebViewWithUrlTrackingState extends State<WebViewWithUrlTracking> {
  late WebViewController controller;
  String currentUrl = '';
  Timer? urlCheckTimer;
  bool isLoading = false;
  bool? lastTriggerBack;
  bool? lastTriggerForward;
  bool? lastTriggerRefresh;

  @override
  void initState() {
    super.initState();

    currentUrl = widget.initialUrl;
    lastTriggerBack = widget.triggerBack;
    lastTriggerForward = widget.triggerForward;
    lastTriggerRefresh = widget.triggerRefresh;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                isLoading = progress < 100;
              });
            }
          },
          onPageStarted: (String url) {
            print('Page started: $url');
            _updateUrl(url);
          },
          onPageFinished: (String url) {
            print('Page finished: $url');
            _updateUrl(url);
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation request: ${request.url}');
            _updateUrl(request.url);
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            print('URL changed: ${change.url}');
            if (change.url != null) {
              _updateUrl(change.url!);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    // Periodic check as backup (every second)
    urlCheckTimer = Timer.periodic(Duration(seconds: 1), (_) async {
      try {
        final url = await controller.currentUrl();
        if (url != null && url != currentUrl) {
          print('Periodic check found new URL: $url');
          _updateUrl(url);
        }
      } catch (e) {
        print('Error checking URL: $e');
      }
    });
  }

  @override
  void didUpdateWidget(WebViewWithUrlTracking oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if back button was triggered (detects ANY change)
    if (widget.triggerBack != null && widget.triggerBack != lastTriggerBack) {
      lastTriggerBack = widget.triggerBack;
      _goBack();
    }

    // Check if forward button was triggered (detects ANY change)
    if (widget.triggerForward != null &&
        widget.triggerForward != lastTriggerForward) {
      lastTriggerForward = widget.triggerForward;
      _goForward();
    }

    // Check if refresh was triggered (detects ANY change)
    if (widget.triggerRefresh != null &&
        widget.triggerRefresh != lastTriggerRefresh) {
      lastTriggerRefresh = widget.triggerRefresh;
      _refresh();
    }
  }

  void _updateUrl(String url) {
    if (mounted && url != currentUrl && url.isNotEmpty) {
      setState(() {
        currentUrl = url;
      });
      print('Updating URL to: $url');
      widget.onUrlChanged?.call(url);
    }
  }

  Future<void> _goBack() async {
    if (await controller.canGoBack()) {
      await controller.goBack();
    }
  }

  Future<void> _goForward() async {
    if (await controller.canGoForward()) {
      await controller.goForward();
    }
  }

  void _refresh() {
    controller.reload();
  }

  @override
  void dispose() {
    urlCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
