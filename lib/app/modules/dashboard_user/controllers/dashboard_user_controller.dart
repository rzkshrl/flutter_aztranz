// ignore_for_file: unnecessary_overrides

import 'package:az_travel/app/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/api_controller.dart';
import '../../../data/models/datamobilmodel.dart';

class DashboardUserController extends GetxController
    with GetTickerProviderStateMixin {
  var showTitle = false.obs;

  final Map<int, AnimationController> cAniDashboardCategories = {};
  final Map<int, bool> isItemClicked = {};

  void handleItemNotesAnimation(int index) {
    isItemClicked[index] = !isItemClicked[index]!;
    if (isItemClicked[index]!) {
      cAniDashboardCategories[index]!.forward(from: 0);
    } else {
      cAniDashboardCategories[index]!.reverse(from: 1);
    }
    update();
  }

  void resetAnimationOnScroll() {
    for (int index in cAniDashboardCategories.keys) {
      cAniDashboardCategories[index]!.reverse();
    }
    update();
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<List<DataMobilModel>> firestoreDataMobilList;
  late Future<List<DataMobilModel>> sqlDataMobilList;

  TextEditingController searchC = TextEditingController();
  var searchFormKey = GlobalKey<FormState>().obs;
  var searchFormKey2 = GlobalKey<FormState>().obs;

  final authC = Get.put(AuthController());
  final apiC = Get.put(APIController());

  @override
  void onInit() {
    super.onInit();
    apiC.getDataUserCondition(authC.auth.currentUser!.email.toString());
    apiC.getDataMobil();
    // apiC.getDataMobil();
    // firestoreDataMobilList = firestore.collection('DataMobil').snapshots().map(
    //     (querySnapshot) => querySnapshot.docs
    //         .map(
    //             (documentSnapshot) => DataMobilModel.fromJson(documentSnapshot))
    //         .toList());
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
