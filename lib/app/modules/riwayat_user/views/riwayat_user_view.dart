import 'package:az_travel/app/utils/loading.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/api_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/theme.dart';
import '../../../utils/textfield.dart';
import '../controllers/riwayat_user_controller.dart';

class RiwayatUserView extends GetView<RiwayatUserController> {
  const RiwayatUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final c = Get.put(RiwayatUserController());
    final apiC = Get.put(APIController());
    apiC.getDataReservasi();

    // add scrollcontroller to listen scroll activity for appbar
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset > (125 - kToolbarHeight) &&
          !c.showTitle2.value) {
        c.showTitle2.value = true;
      } else if (scrollController.offset <= (125 - kToolbarHeight) &&
          c.showTitle2.value) {
        c.showTitle2.value = false;
      }
    });
    return Scaffold(
      body: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            c.resetAnimationOnScroll();
          }
          return false;
        },
        child: CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            Obx(
              () => SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
                pinned: true,
                snap: false,
                floating: false,
                expandedHeight: 15.h,
                centerTitle: false,
                title: c.showTitle2.value
                    ? Padding(
                        padding: EdgeInsets.only(
                          left: 2.5.w,
                          right: 2.5.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            formInput(
                              key: c.searchRiwayatFormKey2.value,
                              width: 65.w,
                              height: 5.h,
                              hintTextFontSize: 10.sp,
                              textEditingController: c.searchRiwayatC,
                              hintText: 'Cari Pesanan...',
                              iconPrefix: PhosphorIconsBold.magnifyingGlass,
                              keyboardType: TextInputType.text,
                              validator: null,
                              isDatePicker: false,
                              onChanged: (value) {
                                apiC.searchRiwayatReservasi(value);
                                c.showTitle2.value = false;
                              },
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: ClipOval(
                                    child: Container(
                                      width: 8.w,
                                      height: 4.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: blue_0C134F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding:
                        EdgeInsets.only(left: 6.5.w, right: 6.5.w, top: 7.5.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AZ Travel',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            formInput(
                              key: c.searchRiwayatFormKey.value,
                              width: 65.w,
                              height: 5.h,
                              hintTextFontSize: 10.sp,
                              textEditingController: c.searchRiwayatC,
                              hintText: 'Cari Pesanan...',
                              iconPrefix: PhosphorIconsBold.magnifyingGlass,
                              keyboardType: TextInputType.text,
                              validator: null,
                              isDatePicker: false,
                              onChanged: (value) {
                                apiC.searchRiwayatReservasi(value);
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: ClipOval(
                                    child: Container(
                                      width: 12.w,
                                      height: 6.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: blue_0C134F),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 4.w, right: 4.w),
                    child: Obx(
                      () => apiC.isLoading.value != true
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: apiC.filteredDataReservasiModel.length,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 0.001.h),
                              itemBuilder: (context, index) {
                                // initiate animation and duration for animation each index
                                if (c.cAniHistoryItem[index] == null) {
                                  c.cAniHistoryItem[index] =
                                      AnimationController(
                                    vsync: c,
                                    duration: const Duration(milliseconds: 70),
                                  );
                                  c.isItemClicked[index] = false;
                                }

                                var dataRiwayatReservasi =
                                    apiC.filteredDataReservasiModel[index];
                                final formatCurrency =
                                    NumberFormat.simpleCurrency(
                                        locale: 'id_ID', decimalDigits: 0);
                                int harga =
                                    int.parse(dataRiwayatReservasi.harga!);

                                var dateStartShort =
                                    dataRiwayatReservasi.tanggalPesanStart!;
                                var dateEndShort =
                                    dataRiwayatReservasi.tanggalPesanEnd!;

                                return AnimatedBuilder(
                                  animation: c.cAniHistoryItem[index]!,
                                  builder: (context, child) {
                                    return ScaleTransition(
                                      scale: Tween(begin: 1.0, end: 0.95)
                                          .animate(c.cAniHistoryItem[index]!),
                                      child: child,
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 4, right: 4, bottom: 2.h),
                                    child: GestureDetector(
                                      onLongPressDown: (details) {
                                        c.cAniHistoryItem[index]!.forward();
                                      },
                                      onLongPressEnd: (details) async {
                                        await c.cAniHistoryItem[index]!
                                            .reverse();
                                        await Get.toNamed(Routes.DETAIL_RIWAYAT,
                                            arguments: dataRiwayatReservasi);
                                      },
                                      child: InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        splashFactory: NoSplash.splashFactory,
                                        onTap: () {
                                          c.cAniHistoryItem[index]!.forward();
                                          Future.delayed(
                                              const Duration(milliseconds: 70),
                                              () {
                                            c.cAniHistoryItem[index]!.reverse();
                                          });
                                          Get.toNamed(Routes.DETAIL_RIWAYAT,
                                              arguments: dataRiwayatReservasi);
                                        },
                                        child: Container(
                                          height: 12.5.h,
                                          decoration: BoxDecoration(
                                            color: black.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 1.5.h,
                                                bottom: 1.5.h,
                                                left: 3.w,
                                                right: 3.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        Container(
                                                          width: 20.w,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              color: light),
                                                        ),
                                                        Icon(
                                                          PhosphorIconsBold
                                                              .dotsThree,
                                                          size: 10.w,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 3.w,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          dataRiwayatReservasi
                                                              .namaMobil!,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        12.sp,
                                                                    height: 1,
                                                                  ),
                                                        ),
                                                        SizedBox(
                                                          height: 2.h,
                                                        ),
                                                        Text(
                                                          'Status Pembayaran :',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                                fontSize: 8.sp,
                                                                height: 1,
                                                              ),
                                                        ),
                                                        SizedBox(
                                                          height: 0.5.h,
                                                        ),
                                                        Text(
                                                          dataRiwayatReservasi
                                                              .status!,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                                fontSize: 9.sp,
                                                                height: 1,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '$dateStartShort - $dateEndShort',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium!
                                                          .copyWith(
                                                            fontSize: 8.sp,
                                                            height: 1,
                                                          ),
                                                    ),
                                                    SizedBox(
                                                      height: 1.h,
                                                    ),
                                                    Text(
                                                      formatCurrency
                                                          .format(harga),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontSize: 11.sp,
                                                              height: 1,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : loadingProp(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
