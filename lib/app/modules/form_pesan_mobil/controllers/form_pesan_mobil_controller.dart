// ignore_for_file: unnecessary_overrides, avoid_print, use_build_context_synchronously

import 'dart:developer';

import 'package:az_travel/app/controller/api_controller.dart';

import 'package:az_travel/app/modules/home/controllers/home_controller.dart';
import 'package:az_travel/app/routes/app_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;

import '../../../theme/textstyle.dart';
import '../../../utils/dialog.dart';
import '../../../utils/loading.dart';

class FormPesanMobilController extends GetxController
    with GetTickerProviderStateMixin {
  TextEditingController namaLengkapFormPesanC = TextEditingController();
  var namaLengkapFormPesanKey = GlobalKey<FormState>().obs;
  TextEditingController noKtpFormPesanC = TextEditingController();
  var noKtpFormPesanKey = GlobalKey<FormState>().obs;
  TextEditingController alamatFormPesanC = TextEditingController();
  var alamatFormPesanKey = GlobalKey<FormState>().obs;
  TextEditingController noTelpFormPesanC = TextEditingController();
  var noTelpFormPesanKey = GlobalKey<FormState>().obs;
  TextEditingController datePesanFormPesanC = TextEditingController();
  var datePesanFormPesanKey = GlobalKey<FormState>().obs;

  final normalValidator =
      MultiValidator([RequiredValidator(errorText: "Kolom harus diisi")]);

  DateTime? start;
  final end = DateTime.now().obs;
  final dateFormatter = DateFormat('d MMMM yyyy', 'id-ID');
  final dateFormatterDefault = DateFormat('yyyy-MM-dd');
  var dateRange = 0.obs;
  var datePesanStart = ''.obs;
  var datePesanEnd = ''.obs;

  var hargaPerHariCalculated = 0.obs;

  DateRangePickerController datePesanController = DateRangePickerController();

  void selectDatePesan(DateTime pickStart, DateTime pickEnd) {
    start = pickStart;
    end.value = pickEnd;
    update();
    var startFormatted = dateFormatter.format(start!);
    var endFormatted = dateFormatter.format(end.value);
    datePesanStart.value = dateFormatterDefault.format(start!);
    datePesanEnd.value = dateFormatterDefault.format(end.value);
    dateRange.value = end.value.difference(start!).inDays + 1;
    if (kDebugMode) {
      print('DateRange COY : ${dateRange.value}');
    }
    update();
    datePesanFormPesanC.text = '$startFormatted - $endFormatted';
  }

  var apiC = Get.put(APIController());

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

  var midtransC = Get.put(HomeController());

  Future<void> pesanMobilAPI(
    int idMobil,
    String harga,
    String namaMobil,
    String namaPemesan,
    String noKTPPemesan,
    String noTelpPemesan,
    String alamatPemesan,
    String fotoUrl,
    BuildContext context,
  ) async {
    try {
      if (kDebugMode) {
        print('ID Mobil : $idMobil');
      }
      if (kDebugMode) {
        print('Harga Mobil Total : $harga');
      }
      if (datePesanEnd.value != "") {
        await showLoading(
          apiC.postDataReservasi(
            idMobil,
            namaMobil,
            namaPemesan,
            alamatPemesan,
            harga,
            noKTPPemesan,
            noTelpPemesan,
            datePesanStart.value,
            datePesanEnd.value,
            fotoUrl,
          ),
          context,
        );

        await midtrans!.startPaymentUiFlow(token: apiC.snapToken);

        Get.back();
        Get.back();
        Get.back();
      } else {
        Get.dialog(dialogAlertOnly(
          animationLink: 'assets/lottie/warning_aztravel.json',
          text: "Terjadi Kesalahan!",
          textSub: "Lengkapi form.",
          textAlert: getTextAlert(),
          textAlertSub: getTextAlertSub(),
        ));
      }
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

  late final AnimationController cAniBayarSekarang;
  bool isBayarSekarangClicked = false;

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
        print(result.statusMessage);
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
    // midtrans?.removeTransactionFinishedCallback();
    super.onClose();
  }
}
