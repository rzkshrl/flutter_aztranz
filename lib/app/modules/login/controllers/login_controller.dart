// ignore_for_file: unnecessary_overrides

import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';

import '../../../controller/api_controller.dart';

class LoginController extends GetxController with GetTickerProviderStateMixin {
  late final AnimationController cAniEmailLogin;
  bool isEmailLoginClicked = false;

  late final AnimationController cAniGoogleLogin;
  bool isGoogleLoginClicked = false;

  TextEditingController emailC = TextEditingController();
  var emailLoginKey = GlobalKey<FormState>().obs;
  TextEditingController passC = TextEditingController();
  var passLoginKey = GlobalKey<FormState>().obs;

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
    EmailValidator(errorText: 'Email harus valid'),
  ]);
  final passValidator = MultiValidator([
    RequiredValidator(errorText: "Kolom harus diisi"),
    MinLengthValidator(6, errorText: 'Kata sandi minimal 6 karakter')
  ]);

  final isPasswordHidden = true.obs;

  final apiC = Get.put(APIController());

  @override
  void onInit() {
    super.onInit();
    cAniEmailLogin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    cAniGoogleLogin = AnimationController(
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
