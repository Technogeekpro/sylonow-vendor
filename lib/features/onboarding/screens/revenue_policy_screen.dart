import 'package:flutter/material.dart';
import 'legal_webview_screen.dart';

class RevenuePolicyScreen extends StatelessWidget {
  const RevenuePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalWebViewScreen(
      url: 'https://www.sylonow.com/vendor/revenue-policy',
      title: 'Revenue Policy',
    );
  }
}