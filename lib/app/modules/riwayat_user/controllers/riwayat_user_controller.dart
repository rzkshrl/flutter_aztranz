// ignore_for_file: unnecessary_overrides

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/api_controller.dart';

class RiwayatUserController extends GetxController
    with GetTickerProviderStateMixin {
  var showTitle2 = false.obs;
  final Map<int, AnimationController> cAniHistoryItem = {};
  final Map<int, bool> isItemClicked = {};

  void handleItemNotesAnimation(int index) {
    isItemClicked[index] = !isItemClicked[index]!;
    if (isItemClicked[index]!) {
      cAniHistoryItem[index]!.forward(from: 0);
    } else {
      cAniHistoryItem[index]!.reverse(from: 1);
    }
    update();
  }

  void resetAnimationOnScroll() {
    for (int index in cAniHistoryItem.keys) {
      cAniHistoryItem[index]!.reverse();
    }
    update();
  }

  TextEditingController searchRiwayatC = TextEditingController();
  var searchRiwayatFormKey = GlobalKey<FormState>().obs;
  var searchRiwayatFormKey2 = GlobalKey<FormState>().obs;

  final apiC = Get.put(APIController());

  @override
  void onInit() {
    super.onInit();
    apiC.getDataReservasi();
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
