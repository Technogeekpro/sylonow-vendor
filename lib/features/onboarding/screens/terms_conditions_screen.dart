import 'package:flutter/material.dart';
import 'legal_webview_screen.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalWebViewScreen(
      url: 'https://www.sylonow.com/vendor/terms-conditions',
      title: 'Terms & Conditions',
    );
  }
}