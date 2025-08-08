import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:delivoo/CommonWidget.dart';
import 'package:delivoo/Pages/paymentselection.dart';
import 'package:delivoo/Providers.dart/Payment_provider.dart';
import 'package:delivoo/Providers.dart/ProductProvider.dart';
import 'package:delivoo/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Components/common_app_nav_bar.dart';

class WebViewScreen extends StatefulWidget {
  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebViewScreen> {
  late final flutterWebViewPlugin;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) {
    //   if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    // }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            // Execute JavaScript when the page is finished loading
            final response = await _controller.runJavaScriptReturningResult(
                "document.documentElement.innerText");

            final decodedResponse = response as String;

            if (decodedResponse.contains('Payment Failed') ||
                decodedResponse.contains('Payment cancelled')) {
              print('Payment Error: $decodedResponse');
              _handlePaymentFailure(decodedResponse);
            } else if (decodedResponse.contains('Payment Successful')) {
              print('Payment Success: $decodedResponse');
              _handlePaymentSuccess(decodedResponse);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(context.read<Paymentprovider>().sodexourl ?? ''));
  }

  void _handlePaymentFailure(String response) async {
    Future.delayed(const Duration(seconds: 2), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PaymentSelection()),
      );

      final payResult =
      await context.read<Paymentprovider>().updatepaymentstatus();

      if (payResult == '0') {
        if (response.contains('Payment cancelled')) {
          showMessage('Payment cancelled');
        } else {
          showMessage('Payment failed');
        }
      } else if (payResult == '1') {
        showMessage('Payment successful');
      }
    });
  }

  void _handlePaymentSuccess(String response) async {
    Future.delayed(const Duration(seconds: 10), () async {
      final payResult =
      await context.read<Paymentprovider>().updatepaymentstatus();

      if (payResult == '0') {
        showMessage('Payment failed');
      } else {
        context.read<ProductProvider>().instorepickup = false;
        context.read<ProductProvider>().removeallProducts();
        Navigator.popUntil(
            context, ModalRoute.withName(PageRoutes.viewCart));
        showMessage('Payment successful');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('---------whencomplete');
        await context.read<Paymentprovider>().sodexowallet();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: CommonAppNavBar(
          titleWidget: Container(),
          actions: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'images/logos/pluxee.png',
                color: Colors.white,
              ),
            ),
          ],
          // centerTitle: true,
        ),
        body: WebViewWidget(controller: _controller),
        // body: WebView(
        //   initialUrl: context.watch<Paymentprovider>().sodexourl,
        //   javascriptMode: JavascriptMode.unrestricted,
        //   onWebViewCreated: (webviewcontroller) {
        //     controller.complete(webviewcontroller);
        //     _controller = webviewcontroller;
        //   },
        //   onPageFinished: (finish) async {
        //     //reading response on finish
        //     final response = await _controller.runJavascriptReturningResult(
        //         "document.documentElement.innerText");
        //     if (response.contains('Payment Failed') ||
        //         response.contains('Payment cancelled')) {
        //       print('pppppppp' + jsonDecode(response));
        //
        //       Future.delayed(Duration(seconds: 2), () async {
        //         Navigator.pushReplacement(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => PaymentSelection()));
        //         Navigator.pop(context);
        //         var payresult =
        //             await context.read<Paymentprovider>().updatepaymentstatus();
        //         if (payresult == '0') {
        //           if (response.contains('Payment cancelled')) {
        //             showMessage('Payment cancelled');
        //           } else {
        //             showMessage('Payment failed');
        //           }
        //         } else if (payresult == '1') {
        //           showMessage('Payment successful');
        //         }
        //       });
        //     } else if (response.contains('Payment Successful')) {
        //       print('sssssss' + jsonDecode(response));
        //
        //       Future.delayed(Duration(seconds: 10), () async {
        //         var payresult =
        //             await context.read<Paymentprovider>().updatepaymentstatus();
        //
        //         if (payresult == '0') {
        //           showMessage('Payment failed');
        //         } else if (payresult != '0') {
        //           context.read<ProductProvider>().instorepickup = false;
        //           context.read<ProductProvider>().removeallProducts();
        //           Navigator.popUntil(
        //               context, ModalRoute.withName(PageRoutes.viewCart));
        //           showMessage('Payment successful');
        //         }
        //       });
        //     }
        //   },
        // ),
      ),
    );
  }
}