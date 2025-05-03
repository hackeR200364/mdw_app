import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CalSessionScreen extends StatefulWidget {
  const CalSessionScreen({super.key});

  @override
  State<CalSessionScreen> createState() => _CalSessionScreenState();
}

class _CalSessionScreenState extends State<CalSessionScreen> {
  bool _isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
        ),
      )
      ..loadRequest(Uri.parse("https://cal.com/mdwtherapy/session"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
