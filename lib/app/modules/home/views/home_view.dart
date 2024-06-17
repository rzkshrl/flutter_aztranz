import 'package:az_travel/app/modules/dashboard_user/views/dashboard_user_view.dart';
import 'package:az_travel/app/modules/profile_user/views/profile_user_view.dart';
import 'package:az_travel/app/modules/riwayat_user/views/riwayat_user_view.dart';
import 'package:az_travel/app/utils/loading.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/api_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/theme.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(APIController());

    return FutureBuilder(
        future: simulateDelay(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }

          var pagesUser = <Widget>[
            const DashboardUserView(),
            const RiwayatUserView(),
            const ProfileUserView(),
          ];

          return Scaffold(
            body: Obx(() => pagesUser[controller.currentIndex2.value]),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: light,
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 2.w, left: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    navBarItem2(context, PhosphorIconsLight.house, 'Beranda', 0,
                        controller.cAniDashboardUser),
                    navBarItem2(context, PhosphorIconsLight.clipboardText,
                        'Riwayat', 1, controller.cAniRiwayatUser),
                    navBarItem2(context, PhosphorIconsLight.user, 'Profil', 2,
                        controller.cAniProfileUser),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget navBarItem2(BuildContext context, IconData icon, String text,
      int index, AnimationController animationController) {
    final controller = Get.put(HomeController());
    return GestureDetector(
        onTap: () {
          animationController.forward();
          Future.delayed(const Duration(milliseconds: 70), () {
            animationController.reverse();
          });
          Future.delayed(const Duration(milliseconds: 120)).then((value) {
            controller.changePage2(index);
          });
        },
        onLongPressDown: (details) {
          animationController.forward();
        },
        onLongPressEnd: (details) async {
          await animationController.forward();
          await animationController.reverse();
          await Get.offAllNamed(Routes.HOME);
        },
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return ScaleTransition(
              scale: Tween(begin: 1.0, end: 0.90).animate(animationController),
              child: child,
            );
          },
          child: SizedBox(
            height: 81,
            child: Obx(
              () => Padding(
                padding: EdgeInsets.only(top: 2.h),
                child: SizedBox(
                  width: 20.w,
                  child: Column(
                    children: [
                      Icon(
                        icon,
                        size: 8.w,
                        color: (index == controller.currentIndex2.value ||
                                Get.currentRoute == Routes.DASHBOARD_USER)
                            ? black
                            : black.withOpacity(0.4),
                      ),
                      Text(
                        text,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontSize: 9.sp,
                              color: (index == controller.currentIndex2.value ||
                                      Get.currentRoute == Routes.DASHBOARD_USER)
                                  ? black
                                  : black.withOpacity(0.4),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
