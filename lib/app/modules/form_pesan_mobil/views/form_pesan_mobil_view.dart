// ignore_for_file: use_build_context_synchronously

import 'package:az_travel/app/controller/auth_controller.dart';
import 'package:az_travel/app/theme/theme.dart';
import 'package:az_travel/app/utils/loading.dart';
import 'package:az_travel/app/utils/textfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../controller/api_controller.dart';
import '../../../data/models/datamobilmodel.dart';
import '../../../theme/textstyle.dart';
import '../../../utils/button.dart';
import '../../../utils/dialog.dart';
import '../controllers/form_pesan_mobil_controller.dart';

class FormPesanMobilView extends GetView<FormPesanMobilController> {
  const FormPesanMobilView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    final c = Get.put(FormPesanMobilController());
    final apiC = Get.put(APIController());

    final dataMobil = Get.arguments as DataMobilModel;
    final formatCurrency =
        NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);
    int hargaPerHariIDR = int.parse(dataMobil.hargaPerHari!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan dan Bayar Mobil'),
      ),
      body: FutureBuilder(
          future: simulateDelay(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            }

            var data = apiC.dataUserModel.value;

            c.namaLengkapFormPesanC.text = data.namaLengkap ?? '';
            c.noKtpFormPesanC.text = data.noKTP ?? '';
            c.noTelpFormPesanC.text = data.nomorTelepon ?? '';
            c.alamatFormPesanC.text = data.alamat ?? '';
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(right: 6.w, left: 6.w, top: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataMobil.namaMobil!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontSize: 16.sp,
                                  ),
                            ),
                            Text(
                              '${dataMobil.merek!} ',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    fontSize: 12.sp,
                                  ),
                            ),
                          ],
                        ),
                        Text(
                          '${formatCurrency.format(hargaPerHariIDR)}/hari',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 12.sp,
                                    height: 1,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    formInput(
                      key: controller.namaLengkapFormPesanKey.value,
                      textEditingController: controller.namaLengkapFormPesanC,
                      hintText: 'Nama Lengkap',
                      iconPrefix: PhosphorIconsFill.userRectangle,
                      keyboardType: TextInputType.name,
                      validator: controller.normalValidator,
                      isDatePicker: false,
                    ),
                    formInput(
                      key: controller.noKtpFormPesanKey.value,
                      textEditingController: controller.noKtpFormPesanC,
                      hintText: 'Nomor KTP',
                      iconPrefix: PhosphorIconsFill.listNumbers,
                      keyboardType: TextInputType.number,
                      validator: controller.normalValidator,
                      isDatePicker: false,
                    ),
                    formInput(
                      key: controller.noTelpFormPesanKey.value,
                      textEditingController: controller.noTelpFormPesanC,
                      hintText: 'Nomor Telepon',
                      iconPrefix: PhosphorIconsFill.phone,
                      keyboardType: TextInputType.number,
                      validator: controller.normalValidator,
                      isDatePicker: false,
                    ),
                    formInput(
                      key: controller.alamatFormPesanKey.value,
                      textEditingController: controller.alamatFormPesanC,
                      hintText: 'Alamat',
                      iconPrefix: PhosphorIconsFill.house,
                      keyboardType: TextInputType.name,
                      validator: controller.normalValidator,
                      isDatePicker: false,
                    ),
                    formInput(
                      key: controller.datePesanFormPesanKey.value,
                      textEditingController:
                          controller.end.value.isAtSameMomentAs(DateTime.now())
                              ? TextEditingController(text: '')
                              : c.datePesanFormPesanC,
                      readOnly: true,
                      hintText: 'Tanggal Pesan',
                      iconPrefix: PhosphorIconsFill.calendar,
                      keyboardType: TextInputType.name,
                      validator: controller.normalValidator,
                      isDatePicker: true,
                      onPressedDatePicker: () {
                        Get.dialog(Dialog(
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 1.h, bottom: 1.h, right: 5.w, left: 5.w),
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: light,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: SfDateRangePicker(
                              backgroundColor: light,
                              headerStyle: DateRangePickerHeaderStyle(
                                  backgroundColor: light),
                              viewSpacing: 10,
                              todayHighlightColor: blue_0C134F,
                              selectionColor: blue_0C134F,
                              rangeSelectionColor: blue_0C134F.withOpacity(0.2),
                              startRangeSelectionColor:
                                  blue_0C134F.withOpacity(0.5),
                              endRangeSelectionColor:
                                  blue_0C134F.withOpacity(0.5),
                              view: DateRangePickerView.month,
                              monthViewSettings:
                                  const DateRangePickerMonthViewSettings(
                                firstDayOfWeek: 7,
                              ),
                              selectionMode: DateRangePickerSelectionMode.range,
                              enablePastDates: false,
                              showActionButtons: true,
                              onCancel: () => Get.back(),
                              controller: c.datePesanController,
                              onSubmit: (value) {
                                if (value != null) {
                                  if ((value as PickerDateRange).endDate !=
                                      null) {
                                    c.selectDatePesan(
                                        value.startDate!, value.endDate!);
                                    // Get.back(closeOverlays: true);
                                    Navigator.pop(context);
                                  } else {
                                    Get.dialog(
                                      dialogAlertOnly(
                                        animationLink:
                                            'assets/lottie/warning_aztravel.json',
                                        text: "Terjadi Kesalahan.",
                                        textSub:
                                            "Pilih tanggal jangkauan\n(Senin-Sabtu, dsb)\n(tekan tanggal dua kali \nuntuk memilih tanggal yang sama)",
                                        textAlert: getTextAlert(),
                                        textAlertSub: getTextAlertSub(),
                                      ),
                                    );
                                  }
                                } else {
                                  Get.dialog(
                                    dialogAlertOnly(
                                      animationLink:
                                          'assets/lottie/warning_aztravel.json',
                                      text: "Terjadi Kesalahan.",
                                      textSub: "Tanggal tidak dipilih.",
                                      textAlert: getTextAlert(),
                                      textAlertSub: getTextAlertSub(),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ));
                      },
                    ),
                    Obx(
                      () => Text(
                        'Total Bayar : ${formatCurrency.format(c.dateRange.value == 0 ? hargaPerHariIDR : hargaPerHariIDR * c.dateRange.value)}',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 12.sp,
                                  height: 1,
                                ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    buttonNoIcon(
                      onTap: () {
                        controller.cAniBayarSekarang.forward();
                        Future.delayed(const Duration(milliseconds: 70), () {
                          controller.cAniBayarSekarang.reverse();
                        });
                        Future.delayed(const Duration(milliseconds: 120))
                            .then((value) {
                          c.hargaPerHariCalculated.value =
                              c.dateRange.value == 0
                                  ? hargaPerHariIDR
                                  : hargaPerHariIDR * c.dateRange.value;

                          if (c.namaLengkapFormPesanKey.value.currentState!
                                  .validate() &&
                              c.noKtpFormPesanKey.value.currentState!
                                  .validate() &&
                              c.noTelpFormPesanKey.value.currentState!
                                  .validate() &&
                              c.alamatFormPesanKey.value.currentState!
                                  .validate()) {
                            c.pesanMobilAPI(
                                dataMobil.id!,
                                c.hargaPerHariCalculated.value.toString(),
                                dataMobil.namaMobil!,
                                c.namaLengkapFormPesanC.text,
                                c.noKtpFormPesanC.text,
                                c.noTelpFormPesanC.text,
                                c.alamatFormPesanC.text,
                                dataMobil.fotoMobil!,
                                context);
                          }
                        });
                      },
                      animationController: controller.cAniBayarSekarang,
                      onLongPressEnd: (details) async {
                        await controller.cAniBayarSekarang.forward();
                        await controller.cAniBayarSekarang.reverse();
                        c.hargaPerHariCalculated.value = c.dateRange.value == 0
                            ? hargaPerHariIDR
                            : hargaPerHariIDR * c.dateRange.value;

                        if (c.namaLengkapFormPesanKey.value.currentState!
                                .validate() &&
                            c.noKtpFormPesanKey.value.currentState!
                                .validate() &&
                            c.noTelpFormPesanKey.value.currentState!
                                .validate() &&
                            c.alamatFormPesanKey.value.currentState!
                                .validate()) {
                          await c.pesanMobilAPI(
                              dataMobil.id!,
                              c.hargaPerHariCalculated.value.toString(),
                              dataMobil.namaMobil!,
                              c.namaLengkapFormPesanC.text,
                              c.noKtpFormPesanC.text,
                              c.noTelpFormPesanC.text,
                              c.alamatFormPesanC.text,
                              dataMobil.fotoMobil!,
                              context);
                        }
                      },
                      elevation: 0,
                      btnColor: yellow1_F9B401,
                      width: 100.w,
                      text: 'Bayar Sekarang',
                      textColor: black,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
