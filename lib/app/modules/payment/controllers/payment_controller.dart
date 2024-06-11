// ignore_for_file: unnecessary_overrides, unnecessary_brace_in_string_interps

import 'package:az_travel/app/controller/api_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentController extends GetxController {
  late final WebViewController webViewController;
  var apiC = Get.put(APIController());
  var midtransClientKey = 'SB-Mid-client-v5tvPUprZj2vnXgJ';
  var midtransSrc = 'https://app.sandbox.midtrans.com/snap/snap.js';

  late final MidtransSDK? midtrans;

  // void initSDK() async {
  //   midtrans = await MidtransSDK.init(
  //     config: MidtransConfig(
  //       clientKey: midtransClientKey,
  //       merchantBaseUrl: "https://app.sandbox.midtrans.com/snap/snap.js",
  //       colorTheme: ColorTheme(
  //         colorPrimary: Colors.blue,
  //         colorPrimaryDark: Colors.blue,
  //         colorSecondary: Colors.blue,
  //       ),
  //     ),
  //   );
  //   midtrans?.setUIKitCustomSetting(
  //     skipCustomerDetailsPages: true,
  //   );
  //   midtrans!.setTransactionFinishedCallback((result) {
  //     Get.snackbar('Berhasil', "Transaksi Berhasil");
  //   });
  // }

  @override
  void onInit() {
    super.onInit();
    // initSDK();
    if (kDebugMode) {
      print('SNAP TOKEN di payment: ${apiC.snapToken}');
    }

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.dataFromString(
        '''<html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script 
          type="text/javascript"
          src="$midtransSrc"
          data-client-key="${midtransClientKey}"
        ></script>
      </head>

      <body onload="setTimeout(function(){pay()}, 1000)">
        <script type="text/javascript">
            function pay() {
                snap.pay('${apiC.snapToken}', {
                  // Optional
                  onSuccess: function(result) {
                    Android.postMessage('ok');
                    Print.postMessage(result);
                  },
                  // Optional
                  onPending: function(result) {
                    Android.postMessage('pending');
                    Print.postMessage(result);
                  },
                  // Optional
                  onError: function(result) {
                    Android.postMessage('error');
                    Print.postMessage(result);
                  },
                  onClose: function() {
                    Android.postMessage('close');
                    Print.postMessage('close');
                  }
                });
            }
        </script>
      </body>
    </html>''',
      ));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
