// ignore_for_file: unnecessary_overrides, avoid_print

import 'package:az_travel/app/controller/api_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:midpay/midpay.dart';
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
    if (kDebugMode) {
      print('DateRange COY : ${dateRange.value}');
    }
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
      if (kDebugMode) {
        print('ID Mobil : $idMobil');
      }
      if (kDebugMode) {
        print('Harga Mobil Total : $harga');
      }
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
        // Get.defaultDialog(
        //   title: "Berhasil",
        //   middleText: "Pesanan berhasil dikirim.",
        //   textConfirm: 'Ya',
        //   onConfirm: () {
        //     Get.back();
        //     Get.back();
        //   },
        // );
      } else {
        Get.defaultDialog(
          title: "Gagal",
          middleText: "Lengkapi form",
          textConfirm: 'Ya',
          onConfirm: () {
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

  final midpay = Midpay();

  //test payment
  testPayment() {
    //for android auto sandbox when debug and production when release
    midpay.init(midtransClientKey, midtransSrc,
        environment: Environment.sandbox);
    midpay.setFinishCallback(_callback);
    var midtransCustomer = MidtransCustomer(
        'Zaki', 'Mubarok', 'kakzaki@gmail.com', '085704703691');
    List<MidtransItem> listitems = [];
    var midtransItems = MidtransItem('IDXXX', 50000, 2, 'Charger');
    listitems.add(midtransItems);
    var midtransTransaction = MidtransTransaction(
        100000, midtransCustomer, listitems,
        skipCustomer: true);
    midpay
        .makePayment(midtransTransaction)
        .catchError((err) => print("ERROR $err"));
  }

  //calback
  Future<void> _callback(TransactionFinished finished) async {
    print("Finish $finished");
    return Future.value(null);
  }

  @override
  void onInit() {
    super.onInit();
    initSDK();
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
