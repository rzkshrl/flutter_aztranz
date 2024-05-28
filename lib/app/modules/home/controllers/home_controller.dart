import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  var currentIndex = 0.obs;
  changePage(int i) {
    currentIndex.value = i;
  }

  var currentIndex2 = 0.obs;
  changePage2(int i) {
    currentIndex2.value = i;
  }

  late final AnimationController cAniDashboardUser;
  bool isDashboardUserClicked = false;

  late final AnimationController cAniRiwayatUser;
  bool isRiwayatUserClicked = false;

  late final AnimationController cAniProfileUser;
  bool isProfileUserClicked = false;

  @override
  void onInit() {
    super.onInit();

    cAniDashboardUser = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    cAniRiwayatUser = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    cAniProfileUser = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
  }
}
