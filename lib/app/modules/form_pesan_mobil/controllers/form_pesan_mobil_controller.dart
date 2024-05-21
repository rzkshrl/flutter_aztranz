// ignore_for_file: unnecessary_overrides

import 'package:az_travel/app/controller/api_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dot_env;

class FormPesanMobilController extends GetxController {
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
    print('DateRange COY : ${dateRange.value}');
    update();
    datePesanFormPesanC.text = '$startFormatted - $endFormatted';
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var apiC = Get.put(APIController());

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
      print('ID Mobil : $idMobil');
      print('Harga Mobil Total : $harga');
      if (datePesanEnd.value != "") {
        apiC.postDataReservasi(
            idMobil,
            namaMobil,
            namaPemesan,
            alamatPemesan,
            harga,
            noKTPPemesan,
            noTelpPemesan,
            datePesanStart.value,
            datePesanEnd.value);
        Get.defaultDialog(
          title: "Berhasil",
          middleText: "Pesanan berhasil dikirim.",
          textConfirm: 'Ya',
          onConfirm: () {
            Get.back();
            Get.back();
          },
        );
      } else {
        Get.defaultDialog(
          title: "Gagal",
          middleText: "Lengkapi form",
          textConfirm: 'Ya',
          onConfirm: () {
            Get.back();
            Get.back();
          },
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar("Error", "Pesanan tidak berhasil dikirim.");
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
      print('Harga Mobil Total : $harga');
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
      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Pesanan berhasil dikirim.",
        textConfirm: 'Ya',
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar("Error", "Pesanan tidak berhasil dikirim.");
    }
  }

  var midtransClientKey = 'SB-Mid-client-v5tvPUprZj2vnXgJ';
  var midtransSrc = 'https://app.sandbox.midtrans.com/snap/snap.js';

  var midtrans = MidtransSDK();

  void initSDK() async {
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
    midtrans.setUIKitCustomSetting(
      showPaymentStatus: true,
      // skipCustomerDetailsPages: true,
    );
    midtrans.setTransactionFinishedCallback((result) {
      Get.snackbar('Berhasil', "Transaksi Berhasil");
    });
  }

  @override
  void onInit() {
    super.onInit();
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
