import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var c = Get.put(PaymentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaymentView'),
        centerTitle: true,
      ),
      body: WebViewWidget(
        controller: c.webViewController,
      ),
    );
  }
}
