import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Components/common_app_nav_bar.dart';
import '../Components/common_home_nav_bar.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the WebViewController and WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            // Handle when page finishes loading
            final response = await _controller.runJavaScriptReturningResult(
                "document.documentElement.innerText");

            // Optionally, you can handle the response here
            print('Page loaded with content: $response');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.kisanserv.com/PrivacyPolicynew.aspx'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppNavBar(
        titleWidget: Text('Privacy Policy', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white)),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}