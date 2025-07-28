// Only imported when building for web

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenWebState();
}

class _DashboardScreenWebState extends State<DashboardScreen> {
  bool _hasError = false;
  bool _isWebViewLoaded = false;

  @override
  void initState() {
    super.initState();

    ui.platformViewRegistry.registerViewFactory(
      'angular-iframe',
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = 'http://localhost:4200'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allow = 'fullscreen';

        iframe.onError.listen((_) {
          if (mounted) setState(() => _hasError = true);
        });

        iframe.onLoad.listen((_) {
          if (mounted) setState(() => _isWebViewLoaded = true);
        });

        return iframe;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _hasError
          ? _buildErrorWidget(context)
          : const HtmlElementView(viewType: 'angular-iframe'),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return const Center(
      child: Text('Failed to load web dashboard'),
    );
  }
}
