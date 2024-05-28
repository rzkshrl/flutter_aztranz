import 'package:az_travel/app/controller/auth_controller.dart';
import 'package:az_travel/app/routes/app_pages.dart';
import 'package:az_travel/app/utils/button.dart';
import 'package:az_travel/app/utils/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/theme.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final authC = AuthController();
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    'assets/images/Login.svg',
                    width: 100.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 17.h),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/Logo.svg',
                        width: 35.w,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Center(
                      child: Container(
                        width: 85.w,
                        decoration: BoxDecoration(
                            color: light,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.5.h, bottom: 5.h),
                          child: Column(
                            children: [
                              Text(
                                'Masuk',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2.5.h,
                              ),
                              formLogin(
                                autofillHints: const [AutofillHints.email],
                                key: controller.emailLoginKey.value,
                                textEditingController: controller.emailC,
                                hintText: 'Email',
                                iconPrefix: PhosphorIconsFill.envelope,
                                keyboardType: TextInputType.emailAddress,
                                validator: controller.emailValidator,
                                errorStatus: authC.errorStatusLoginEmail.value,
                                errorText: authC.errorTextLoginEmail.value,
                              ),
                              formLoginPass(
                                autofillHints: const [AutofillHints.password],
                                key: controller.passLoginKey.value,
                                textEditingController: controller.passC,
                                hintText: 'Kata Sandi',
                                iconPrefix: PhosphorIconsFill.key,
                                keyboardType: TextInputType.visiblePassword,
                                validator: controller.passValidator,
                                hidePass: controller.isPasswordHidden,
                                errorStatus: authC.errorStatusLoginEmail.value,
                                errorText: authC.errorTextLoginEmail.value,
                              ),
                              SizedBox(
                                height: 0.3.h,
                              ),
                              buttonNoIcon(
                                onTap: () {
                                  controller.cAniEmailLogin.forward();
                                  Future.delayed(
                                      const Duration(milliseconds: 70), () {
                                    controller.cAniEmailLogin.reverse();
                                  });
                                  Future.delayed(
                                          const Duration(milliseconds: 120))
                                      .then((value) {
                                    if (controller
                                            .emailLoginKey.value.currentState!
                                            .validate() &&
                                        controller
                                            .passLoginKey.value.currentState!
                                            .validate()) {
                                      authC.login(
                                        controller.emailC.text,
                                        controller.passC.text,
                                      );
                                    }
                                  });
                                },
                                animationController: controller.cAniEmailLogin,
                                onLongPressEnd: (details) async {
                                  await controller.cAniEmailLogin.forward();
                                  await controller.cAniEmailLogin.reverse();
                                  if (controller
                                          .emailLoginKey.value.currentState!
                                          .validate() &&
                                      controller
                                          .passLoginKey.value.currentState!
                                          .validate()) {
                                    authC.login(
                                      controller.emailC.text,
                                      controller.passC.text,
                                    );
                                  }
                                },
                                elevation: 0,
                                btnColor: yellow1_F9B401,
                                text: 'Masuk',
                                textColor: black,
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              const Text('atau'),
                              SizedBox(
                                height: 2.h,
                              ),
                              buttonWithIcon(
                                onTap: () {
                                  controller.cAniGoogleLogin.forward();
                                  Future.delayed(
                                      const Duration(milliseconds: 70), () {
                                    controller.cAniGoogleLogin.reverse();
                                  });
                                  Future.delayed(
                                          const Duration(milliseconds: 120))
                                      .then((value) {
                                    authC.signInGoogle();
                                  });
                                },
                                animationController: controller.cAniGoogleLogin,
                                onLongPressEnd: (details) async {
                                  await controller.cAniGoogleLogin.forward();
                                  await controller.cAniGoogleLogin.reverse();
                                  await authC.signInGoogle();
                                },
                                elevation: 3,
                                btnColor: light,
                                icon: SvgPicture.asset(
                                    'assets/images/google_logo.svg'),
                                text: 'Masuk dengan Google',
                                textColor: black,
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Belum punya akun? ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(fontSize: 10.sp),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.offAllNamed(Routes.REGISTER);
                                    },
                                    child: Text(
                                      'Daftar',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
