import 'dart:io';

import 'package:az_travel/app/data/models/usermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/auth_controller.dart';
import '../../../theme/theme.dart';
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
                                InkWell(
                                  onTap: () {
                                    controller.pickImage();
                                  },
                                  child: Container(
                                    width: 40.w,
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                      color: yellow1_F9B401,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 5.w, left: 5.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text('Ubah gambar'),
                                          Icon(
                                            PhosphorIconsBold.camera,
                                            size: 25,
                                            color: Theme.of(Get.context!)
                                                .iconTheme
                                                .color,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                InkWell(
                                  onTap: () {
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
                                  child: Container(
                                    height: 6.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: yellow1_F9B401,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 8.w, left: 8.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            PhosphorIconsBold.floppyDisk,
                                            size: 6.w,
                                          ),
                                          const Text('Simpan'),
                                        ],
                                      ),
                                    ),
                                  ),
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
