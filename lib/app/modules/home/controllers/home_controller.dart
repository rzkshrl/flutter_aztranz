import 'package:az_travel/app/controller/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetTickerProviderStateMixin, WidgetsBindingObserver {
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

  var apiC = Get.put(APIController());
  // var midtransC = Get.put(FormPesanMobilController());

  void fetchData() async {
    apiC.getDataMobil();
    apiC.getDataReservasi();
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchData();
    }
  }
}
