import 'package:flutter/material.dart';
import 'legal_webview_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalWebViewScreen(
      url: 'https://www.sylonow.com/vendor/privacy-policy',
      title: 'Privacy Policy',
    );
  }
}