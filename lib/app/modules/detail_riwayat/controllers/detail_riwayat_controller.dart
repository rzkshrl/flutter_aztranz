// ignore_for_file: unnecessary_overrides, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

import '../../../controller/api_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/textstyle.dart';
import '../../../utils/dialog.dart';
import '../../../utils/loading.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;

class DetailRiwayatController extends GetxController
    with GetTickerProviderStateMixin {
  late final AnimationController cAniBayarSekarang;
  bool isPesanSekarangClicked = false;

  Future<void> showLoading(dynamic, BuildContext context) async {
    Get.dialog(
      dialogLoading(context),
    );
    await dynamic;
    await Future.delayed(const Duration(milliseconds: 2500));
    if (Get.isDialogOpen == true) {
      Get.back(); // Tutup dialog jika masih terbuka
    }
  }

  var apiC = Get.put(APIController());

  Future<void> pesanMobilAPI(
    int idReservasi,
    int idMobil,
    String harga,
    String namaMobil,
    String namaPemesan,
    String noKTPPemesan,
    String noTelpPemesan,
    String alamatPemesan,
    String datePesanStart,
    String datePesanEnd,
    String fotoUrl,
    BuildContext context,
  ) async {
    try {
      if (kDebugMode) {
        print('ID Reservasi : $idReservasi');
        print('ID Mobil : $idMobil');
        print('Harga Mobil Total : $harga');
      }

      await showLoading(
        apiC.updateDataReservasi(
          idReservasi,
          idMobil,
          namaMobil,
          namaPemesan,
          alamatPemesan,
          harga,
          noKTPPemesan,
          noTelpPemesan,
          datePesanStart,
          datePesanEnd,
          fotoUrl,
        ),
        context,
      );

      await midtrans!.startPaymentUiFlow(token: apiC.snapToken);

      Get.back();
      Get.back();
      Get.back();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.dialog(
        dialogAlertOnly(
          animationLink: 'assets/lottie/warning_aztravel.json',
          text: "Terjadi Kesalahan!",
          textSub: "Pesanan gagal.",
          textAlert: getTextAlert(),
          textAlertSub: getTextAlertSub(),
        ),
      );
    }
  }

  // var midtransClientKey = 'SB-Mid-client-v5tvPUprZj2vnXgJ';
  var midtransSrc = 'https://app.sandbox.midtrans.com/snap/v2/';

  late final MidtransSDK? midtrans;

  var resultMidtrans = TransactionResult().obs;

  void initSDK() async {
    log('midtrans init');
    midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: dot_env.dotenv.env['MIDTRANS_CLIENT_KEY'] ?? "",
        merchantBaseUrl: midtransSrc,
        colorTheme: ColorTheme(
          colorPrimary: Colors.blue,
          colorPrimaryDark: Colors.blue,
          colorSecondary: Colors.blue,
        ),
      ),
    );
    midtrans!.setUIKitCustomSetting(
      // showPaymentStatus: true,
      skipCustomerDetailsPages: true,
    );
    midtrans!.setTransactionFinishedCallback((result) async {
      log('PESANAN BERHASIL DAN DIBAYAR lewat showPaymentStatus di form controller');

      resultMidtrans.value = result;

      if (result.isTransactionCanceled == true) {
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Pembayaran dibatalkan",
            textSub: "Lanjutkan pembayaran di menu Riwayat.",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
          ),
        );
      } else {
        if (kDebugMode) {
          print(result.statusMessage);
        }
        if (result.transactionStatus == TransactionResultStatus.settlement) {
          await apiC.updateStatusReservasi(
              apiC.hasilResponseDataReservasi.value.idReservasi!);
          await apiC.postDataMobilStatus(
              apiC.hasilResponseDataReservasi.value.mobilId!);
          await apiC.getDetailReservasiSingle(
              apiC.hasilResponseDataReservasi.value.idReservasi!);

          await Get.toNamed(Routes.DETAIL_RIWAYAT,
              arguments: apiC.hasilReservasiNow.value);
          showToast('Transaction Completed', false);
        } else if (result.transactionStatus! == TransactionResultStatus.deny) {
          Get.dialog(
            dialogAlertOnly(
              animationLink: 'assets/lottie/warning_aztravel.json',
              text: "Pembayaran gagal",
              textSub: "Silahkan ulangi pembayaran.",
              textAlert: getTextAlert(),
              textAlertSub: getTextAlertSub(),
            ),
          );
        } else {
          Get.dialog(
            dialogAlertOnly(
              animationLink: 'assets/lottie/warning_aztravel.json',
              text: "Pembayaran gagal",
              textSub: "Terjadi kesalahan.",
              textAlert: getTextAlert(),
              textAlertSub: getTextAlertSub(),
            ),
          );
        }
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    initSDK();
    cAniBayarSekarang = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
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
