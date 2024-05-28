import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/riwayat_user_controller.dart';

class RiwayatUserView extends GetView<RiwayatUserController> {
  const RiwayatUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final c = Get.put(RiwayatUserController());
    // add scrollcontroller to listen scroll activity for appbar
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset > (125 - kToolbarHeight) &&
          !c.showTitle.value) {
        c.showTitle.value = true;
      } else if (scrollController.offset <= (125 - kToolbarHeight) &&
          c.showTitle.value) {
        c.showTitle.value = false;
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
              slivers: [],
            )));
  }
}
