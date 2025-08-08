import 'dart:async';
import 'dart:io';
import 'package:delivoo/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Components/common_app_nav_bar.dart';

class Invoice extends StatefulWidget {
  final String? orderid;
  Invoice(this.orderid);

  @override
  InvoiceState createState() => InvoiceState();
}

class InvoiceState extends State<Invoice> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize WebViewController and WebView
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            // Handle page finish logic
            final response = await _controller.runJavaScriptReturningResult(
                "document.documentElement.innerText");

            // Optionally handle the page content here
            print('Page loaded with content: $response');
          },
        ),
      )
      ..loadRequest(Uri.parse('${BaseUrl}express_invoice.aspx?orderid=${widget.orderid}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppNavBar(
        titleWidget: Text(
          'Invoice',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}