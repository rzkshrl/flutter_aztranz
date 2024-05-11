import 'package:az_travel/app/data/models/usermodel.dart';
import 'package:az_travel/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/auth_controller.dart';
import '../../../theme/theme.dart';
import '../../../utils/loading.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var defaultImage =
        "https://ui-avatars.com/api/?background=fff38a&color=5175c0&font-size=0.33&size=256";
    final authC = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'AZ Travel',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 1.5.h,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<UserModel>(
          stream: authC.getUserData(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const LoadingView();
            } else {
              if (snap.data == null) {
                return const LoadingView();
              } else {
                var data = snap.data!;
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(right: 5.w, left: 5.w, top: 4.h),
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
                            onTap: () {},
                            child: ClipOval(
                                child: Image.network(
                              data.photoUrl! == ''
                                  ? defaultImage
                                  : data.photoUrl!,
                              width: 45.w,
                            )),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            data.username!,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .copyWith(
                                  fontSize: 18.sp,
                                ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            data.email!,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6.w, right: 6.w),
                            child: Container(
                              height: 10.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: light,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 5.w,
                                    right: 5.w,
                                    top: 1.h,
                                    bottom: 1.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kelola akun',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontSize: 12.5.sp,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.EDIT_PROFILE);
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(PhosphorIconsRegular.user),
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Text(
                                            'Edit Profil',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontSize: 10.5.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          InkWell(
                            onTap: () {
                              authC.logout();
                            },
                            child: Container(
                              height: 6.h,
                              width: 50.w,
                              decoration: BoxDecoration(
                                color: yellow1_F9B401,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(right: 8.w, left: 8.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      PhosphorIconsBold.door,
                                      size: 6.w,
                                    ),
                                    const Text('Keluar'),
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
          }),
    );
  }
}
