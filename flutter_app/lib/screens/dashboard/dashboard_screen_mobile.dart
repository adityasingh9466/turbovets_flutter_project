// Only imported when building for Android/iOS

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenMobileState();
}

class _DashboardScreenMobileState extends State<DashboardScreen> {
  bool _hasError = false;
  bool _isWebViewLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              initialUrl: 'http://10.0.0.53:4200',
              javascriptMode: JavascriptMode.unrestricted,
              onWebResourceError: (_) {
                if (mounted) setState(() => _hasError = true);
              },
              onPageFinished: (_) {
                if (mounted) setState(() => _isWebViewLoaded = true);
              },
            ),
            if (!_isWebViewLoaded && !_hasError)
              const Center(child: CircularProgressIndicator()),
            if (_hasError) _buildErrorWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return const Center(
      child: Text('Failed to load dashboard'),
    );
  }
}
