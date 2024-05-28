import 'package:az_travel/app/data/models/datamobilmodel.dart';
import 'package:az_travel/app/routes/app_pages.dart';
import 'package:az_travel/app/utils/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/theme.dart';
import '../controllers/detail_mobil_controller.dart';

class DetailMobilView extends GetView<DetailMobilController> {
  const DetailMobilView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final dataMobil = Get.arguments as DataMobilModel;
    final formatCurrency =
        NumberFormat.simpleCurrency(locale: 'id_ID', decimalDigits: 0);
    int hargaPerHariIDR = int.parse(dataMobil.hargaPerHari!);
    var fotoMobilURL =
        dataMobil.fotoMobil!.replaceRange(7, 21, '10.0.2.2:8000');
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
                            Get.back();
                          },
                          child: Icon(
                            PhosphorIconsBold.arrowLeft,
                            size: 6.w,
                          ),
                        ),
                        Text(
                          'Detail Mobil',
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
                      height: 1.5.h,
                    ),
                    Row(
                      children: [
                        const Icon(PhosphorIconsBold.squareHalfBottom),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          '${dataMobil.noPolisi}',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 12.sp,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(PhosphorIconsBold.calendar),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Tahun ${dataMobil.tahun}',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 12.sp,
                                  ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(PhosphorIconsBold.engine),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          'Bahan Bakar : ${dataMobil.tipeBahanBakar}',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 12.sp,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      '${dataMobil.deskripsi}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 12.sp,
                          ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Center(
                      child: buttonNoIcon(
                        onTap: () {
                          controller.cAniPesanSekarang.forward();
                          Future.delayed(const Duration(milliseconds: 70), () {
                            controller.cAniPesanSekarang.reverse();
                          });
                          Future.delayed(const Duration(milliseconds: 120))
                              .then((value) {
                            Get.toNamed(Routes.FORM_PESAN_MOBIL,
                                arguments: dataMobil);
                          });
                        },
                        animationController: controller.cAniPesanSekarang,
                        onLongPressEnd: (details) async {
                          await controller.cAniPesanSekarang.forward();
                          await controller.cAniPesanSekarang.reverse();
                          await Get.toNamed(Routes.FORM_PESAN_MOBIL,
                              arguments: dataMobil);
                        },
                        elevation: 0,
                        btnColor: yellow1_F9B401,
                        width: 100.w,
                        text: 'Pesan Sekarang',
                        textColor: black,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
