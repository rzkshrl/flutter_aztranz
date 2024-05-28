import 'dart:io';

import 'package:az_travel/app/data/models/usermodel.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/auth_controller.dart';
import '../../../theme/theme.dart';
import '../../../utils/button.dart';
import '../../../utils/loading.dart';
import '../../../utils/textfield.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var defaultImage =
        "https://ui-avatars.com/api/?background=fff38a&color=5175c0&font-size=0.33&size=256";
    final authC = Get.put(AuthController());
    final controller = Get.put(EditProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: FutureBuilder(
          future: simulateDelay(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const LoadingView();
            }

            return StreamBuilder<UserModel>(
                stream: authC.getUserData(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const LoadingView();
                  } else {
                    if (snap.data == null) {
                      return const LoadingView();
                    } else {
                      var data = snap.data!;
                      controller.namaLengkapEditProfileC.text =
                          data.namaLengkap!;
                      controller.usernameEditProfileC.text = data.username!;
                      controller.noKtpEditProfileC.text = data.noKTP!;
                      controller.noTelpEditProfileC.text = data.nomorTelepon!;
                      controller.alamatEditProfileC.text = data.alamat!;
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding:
                            EdgeInsets.only(right: 5.w, left: 5.w, top: 2.h),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Container(
                                height: 100.h,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    color: blue_0C134F),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                buttonWithIcon(
                                  onTap: () {
                                    controller.cAniUbahGambar.forward();
                                    Future.delayed(
                                        const Duration(milliseconds: 70), () {
                                      controller.cAniUbahGambar.reverse();
                                    });
                                    Future.delayed(
                                            const Duration(milliseconds: 120))
                                        .then((value) {
                                      controller.pickImage();
                                    });
                                  },
                                  animationController:
                                      controller.cAniUbahGambar,
                                  onLongPressEnd: (details) async {
                                    await controller.cAniUbahGambar.forward();
                                    await controller.cAniUbahGambar.reverse();
                                    controller.pickImage();
                                  },
                                  elevation: 0,
                                  btnColor: yellow1_F9B401,
                                  icon: Icon(
                                    PhosphorIconsBold.camera,
                                    size: 6.w,
                                  ),
                                  width: 40.w,
                                  text: 'Ubah Gambar',
                                  textColor: black,
                                ),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                GetBuilder<EditProfileController>(builder: (c) {
                                  return Stack(
                                    children: [
                                      if (c.image == null)
                                        InkWell(
                                          onTap: () {
                                            controller.pickImage();
                                          },
                                          child: ClipOval(
                                            child: Image.network(
                                              data.photoUrl! == ''
                                                  ? defaultImage
                                                  : data.photoUrl!,
                                              width: 45.w,
                                            ),
                                          ),
                                        )
                                      else
                                        InkWell(
                                          onTap: () {
                                            controller.pickImage();
                                          },
                                          child: ClipOval(
                                            child: Image.file(
                                              File(c.image!.path),
                                              width: 45.w,
                                            ),
                                          ),
                                        )
                                    ],
                                  );
                                }),
                                SizedBox(
                                  height: 4.h,
                                ),
                                formRegister(
                                    key:
                                        controller.usernameEditProfileKey.value,
                                    textEditingController:
                                        controller.usernameEditProfileC,
                                    hintText: 'Username',
                                    iconPrefix: PhosphorIconsFill.user,
                                    keyboardType: TextInputType.name,
                                    validator: controller.normalValidator),
                                formRegister(
                                    key: controller
                                        .namaLengkapEditProfileKey.value,
                                    textEditingController:
                                        controller.namaLengkapEditProfileC,
                                    hintText: 'Nama Lengkap',
                                    iconPrefix: PhosphorIconsFill.userRectangle,
                                    keyboardType: TextInputType.name,
                                    validator: controller.normalValidator),
                                formRegister(
                                    key: controller.noKtpEditProfileKey.value,
                                    textEditingController:
                                        controller.noKtpEditProfileC,
                                    hintText: 'Nomor KTP',
                                    iconPrefix: PhosphorIconsFill.listNumbers,
                                    keyboardType: TextInputType.number,
                                    validator: controller.normalValidator),
                                formRegister(
                                    key: controller.noTelpEditProfileKey.value,
                                    textEditingController:
                                        controller.noTelpEditProfileC,
                                    hintText: 'Nomor Telepon',
                                    iconPrefix: PhosphorIconsFill.phone,
                                    keyboardType: TextInputType.number,
                                    validator: controller.normalValidator),
                                formRegister(
                                    key: controller.alamatEditProfileKey.value,
                                    textEditingController:
                                        controller.alamatEditProfileC,
                                    hintText: 'Alamat',
                                    iconPrefix: PhosphorIconsFill.house,
                                    keyboardType: TextInputType.name,
                                    validator: controller.normalValidator),
                                SizedBox(
                                  height: 4.h,
                                ),
                                buttonWithIcon(
                                  onTap: () {
                                    controller.cAniUbahGambar.forward();
                                    Future.delayed(
                                        const Duration(milliseconds: 70), () {
                                      controller.cAniUbahGambar.reverse();
                                    });
                                    Future.delayed(
                                            const Duration(milliseconds: 120))
                                        .then((value) {
                                      if (controller.usernameEditProfileKey
                                              .value.currentState!
                                              .validate() &&
                                          controller.namaLengkapEditProfileKey
                                              .value.currentState!
                                              .validate() &&
                                          controller.noKtpEditProfileKey.value
                                              .currentState!
                                              .validate() &&
                                          controller.noTelpEditProfileKey.value
                                              .currentState!
                                              .validate() &&
                                          controller.alamatEditProfileKey.value
                                              .currentState!
                                              .validate()) {
                                        controller.editProfil(
                                            controller
                                                .usernameEditProfileC.text,
                                            controller
                                                .namaLengkapEditProfileC.text,
                                            controller.noKtpEditProfileC.text,
                                            controller.noTelpEditProfileC.text,
                                            controller.alamatEditProfileC.text);
                                      }
                                    });
                                  },
                                  animationController:
                                      controller.cAniUbahGambar,
                                  onLongPressEnd: (details) async {
                                    await controller.cAniUbahGambar.forward();
                                    await controller.cAniUbahGambar.reverse();
                                    if (controller.usernameEditProfileKey.value
                                            .currentState!
                                            .validate() &&
                                        controller.namaLengkapEditProfileKey
                                            .value.currentState!
                                            .validate() &&
                                        controller.noKtpEditProfileKey.value
                                            .currentState!
                                            .validate() &&
                                        controller.noTelpEditProfileKey.value
                                            .currentState!
                                            .validate() &&
                                        controller.alamatEditProfileKey.value
                                            .currentState!
                                            .validate()) {
                                      controller.editProfil(
                                          controller.usernameEditProfileC.text,
                                          controller
                                              .namaLengkapEditProfileC.text,
                                          controller.noKtpEditProfileC.text,
                                          controller.noTelpEditProfileC.text,
                                          controller.alamatEditProfileC.text);
                                    }
                                  },
                                  elevation: 0,
                                  btnColor: yellow1_F9B401,
                                  icon: Icon(
                                    PhosphorIconsBold.floppyDisk,
                                    size: 6.w,
                                  ),
                                  width: 50.w,
                                  text: 'Simpan',
                                  textColor: black,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  }
                });
          }),
    );
  }
}
