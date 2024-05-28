// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailMobilController extends GetxController
    with GetTickerProviderStateMixin {
  late final AnimationController cAniPesanSekarang;
  bool isPesanSekarangClicked = false;

  @override
  void onInit() {
    super.onInit();
    cAniPesanSekarang = AnimationController(
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
    super.onClose();
  }
}
