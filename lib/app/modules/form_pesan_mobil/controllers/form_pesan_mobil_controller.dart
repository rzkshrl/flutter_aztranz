// ignore_for_file: unnecessary_overrides, avoid_print

import 'package:az_travel/app/controller/api_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var apiC = Get.put(APIController());

  Future<void> showLoading(dynamic) async {
    Get.dialog(
      dialogLoading(),
    );
    await dynamic;
    await Future.delayed(const Duration(milliseconds: 2500));
    if (Get.isDialogOpen == true) {
      Get.back(); // Tutup dialog jika masih terbuka
    }
  }

  Future<void> pesanMobilAPI(
    int idMobil,
    String harga,
    String namaMobil,
    String namaPemesan,
    String noKTPPemesan,
    String noTelpPemesan,
    String alamatPemesan,
  ) async {
    try {
      if (kDebugMode) {
        print('ID Mobil : $idMobil');
      }
      if (kDebugMode) {
        print('Harga Mobil Total : $harga');
      }
      if (datePesanEnd.value != "") {
        await showLoading(apiC.postDataReservasi(
            idMobil,
            namaMobil,
            namaPemesan,
            alamatPemesan,
            harga,
            noKTPPemesan,
            noTelpPemesan,
            datePesanStart.value,
            datePesanEnd.value));

        await midtrans?.startPaymentUiFlow(token: apiC.snapToken);

        Get.back();
        Get.back();
      } else {
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Terjadi Kesalahan!",
            textSub: "Lengkapi form.",
            textAlert: getTextAlert(Get.context!),
            textAlertSub: getTextAlertSub(Get.context!),
          ),
        );
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
          textAlert: getTextAlert(Get.context!),
          textAlertSub: getTextAlertSub(Get.context!),
        ),
      );
    }
  }

  void pesanMobil(
    String idMobil,
    String harga,
    String namaMobil,
    String namaPemesan,
    String noKTPPemesan,
    String noTelpPemesan,
    String alamatPemesan,
  ) async {
    try {
      if (kDebugMode) {
        print('Harga Mobil Total : $harga');
      }
      var pesananMobilReference = firestore.collection('PesananMobil');
      final docRef = pesananMobilReference.doc();
      await docRef.set({
        'id': docRef.id,
        'idMobil': idMobil,
        'harga': harga,
        'namaMobil': namaMobil,
        'namaPemesan': namaPemesan,
        'noKTPPemesan': noKTPPemesan,
        'noTelpPemesan': noTelpPemesan,
        'alamatPemesan': alamatPemesan,
        'tanggalPesanStart': datePesanStart.value,
        'tanggalPesanEnd': datePesanEnd.value,
      });
      // Get.defaultDialog(
      //   title: "Berhasil",
      //   middleText: "Pesanan berhasil dikirim.",
      //   textConfirm: 'Ya',
      //   onConfirm: () {
      //     Get.back();
      //     Get.back();
      //   },
      // );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar("Error", "Pesanan tidak berhasil dikirim.");
    }
  }

  var midtransClientKey = 'SB-Mid-client-v5tvPUprZj2vnXgJ';
  var midtransSrc = 'https://app.sandbox.midtrans.com/snap/v1/transactions';

  late final MidtransSDK? midtrans;

  void initSDK() async {
    midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: dot_env.dotenv.env['MIDTRANS_CLIENT_KEY'] ?? "",
        merchantBaseUrl: "",
        colorTheme: ColorTheme(
          colorPrimary: Colors.blue,
          colorPrimaryDark: Colors.blue,
          colorSecondary: Colors.blue,
        ),
      ),
    );
    midtrans?.setUIKitCustomSetting(
      showPaymentStatus: true,
      skipCustomerDetailsPages: true,
    );
    midtrans!.setTransactionFinishedCallback((result) {
      _showToast('Transaction Completed', false);

      Get.back();
      Get.back();
      Get.back();
    });
  }

  void _showToast(String msg, bool isError) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: isError ? Colors.red : Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  late final AnimationController cAniBayarSekarang;
  bool isBayarSekarangClicked = false;

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
    midtrans?.removeTransactionFinishedCallback();
    super.onClose();
  }
}
