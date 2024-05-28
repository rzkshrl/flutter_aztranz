import 'package:get/get.dart';

import '../controllers/riwayat_user_controller.dart';

class RiwayatUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatUserController>(
      () => RiwayatUserController(),
    );
  }
}
