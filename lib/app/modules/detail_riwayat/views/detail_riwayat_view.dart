import 'package:az_travel/app/data/models/pesananmobilmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/api_controller.dart';
import '../../../theme/theme.dart';
import '../../../utils/button.dart';
import '../controllers/detail_riwayat_controller.dart';

class DetailRiwayatView extends GetView<DetailRiwayatController> {
  const DetailRiwayatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dataReservasi = Get.arguments as DataReservasiModel;
    final apiC = Get.put(APIController());
    final formatCurrency =
        NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);
    int harga = int.parse(dataReservasi.harga!);

    final dateFormatter = DateFormat('d MMMM yyyy', 'id-ID');
    var dateStart =
        dateFormatter.format(DateTime.parse(dataReservasi.tanggalPesanStart!));
    var dateEnd =
        dateFormatter.format(DateTime.parse(dataReservasi.tanggalPesanEnd!));
    var fotoMobilURL = dataReservasi.fotoUrl!.replaceRange(7, 21, apiC.imageIP);
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(
                          Rect.fromLTRB(0, rect.top, 0, rect.bottom));
                    },
                    blendMode: BlendMode.dstOut,
                    child: Image.network(
                      fotoMobilURL,
                      width: 100.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w, top: 8.h, right: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back(closeOverlays: true);
                          },
                          child: Icon(
                            PhosphorIconsBold.arrowLeft,
                            size: 6.w,
                          ),
                        ),
                        Text(
                          'Detail Riwayat Pesanan',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 16.sp,
                                    height: 1,
                                  ),
                        ),
                        SizedBox(
                          width: 4.w,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.w, top: 2.h, right: 5.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dataReservasi.namaMobil!,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 16.sp,
                                  ),
                        ),
                        Text(
                          formatCurrency.format(harga),
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 13.sp,
                                  height: 1,
                                  fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Row(
                      children: [
                        const Icon(PhosphorIconsBold.calendar),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Tanggal Pesan : $dateStart - $dateEnd',
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
                    Row(
                      children: [
                        const Icon(PhosphorIconsBold.userCircle),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Nama Pemesan : ${dataReservasi.namaPemesan!} ',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontSize: 12.sp,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Row(
                      children: [
                        const Icon(PhosphorIconsBold.article),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Nomor KTP Pemesan : ${dataReservasi.noKTPPemesan!} ',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontSize: 12.sp,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Row(
                      children: [
                        const Icon(PhosphorIconsBold.phoneCall),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Nomor Telepon Pemesan : ${dataReservasi.noTelpPemesan!} ',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontSize: 12.sp,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Row(
                      children: [
                        const Icon(PhosphorIconsBold.house),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Alamat Pemesan : ',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                fontSize: 12.sp,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    Text(
                      '${dataReservasi.alamatPemesan!} ',
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 12.sp,
                              ),
                    ),
                    SizedBox(
                      height: 2.5.h,
                    ),
                    Text(
                      'Status Pembayaran :',
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 12.sp,
                                height: 1,
                              ),
                    ),
                    SizedBox(
                      height: 0.5.h,
                    ),
                    dataReservasi.status == 'Belum Bayar'
                        ? Row(
                            children: [
                              Text(
                                'Belum Dibayar',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 13.sp,
                                      height: 1,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              const Icon(PhosphorIconsBold.xCircle),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                'Sudah Dibayar',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 13.sp,
                                      height: 1,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              const Icon(PhosphorIconsBold.checkCircle),
                            ],
                          ),
                    SizedBox(
                      height: 4.h,
                    ),
                    dataReservasi.status == 'Belum Bayar'
                        ? Center(
                            child: buttonNoIcon(
                              onTap: () {
                                controller.cAniBayarSekarang.forward();
                                Future.delayed(const Duration(milliseconds: 70),
                                    () {
                                  controller.cAniBayarSekarang.reverse();
                                });
                                Future.delayed(
                                        const Duration(milliseconds: 120))
                                    .then((value) {
                                  controller.pesanMobilAPI(
                                      dataReservasi.idReservasi!,
                                      dataReservasi.mobilId!,
                                      dataReservasi.harga!,
                                      dataReservasi.namaMobil!,
                                      dataReservasi.namaPemesan!,
                                      dataReservasi.noKTPPemesan!,
                                      dataReservasi.noTelpPemesan!,
                                      dataReservasi.alamatPemesan!,
                                      dataReservasi.tanggalPesanStart!,
                                      dataReservasi.tanggalPesanEnd!,
                                      dataReservasi.fotoUrl!,
                                      context);
                                });
                              },
                              animationController: controller.cAniBayarSekarang,
                              onLongPressEnd: (details) async {
                                await controller.cAniBayarSekarang.forward();
                                await controller.cAniBayarSekarang.reverse();
                                // await Get.toNamed(Routes.FORM_PESAN_MOBIL,
                                //     arguments: dataMobil);
                              },
                              elevation: 0,
                              btnColor: yellow1_F9B401,
                              width: 100.w,
                              text: 'Bayar Sekarang',
                              textColor: black,
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
