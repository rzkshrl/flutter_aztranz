// ignore_for_file: unnecessary_overrides

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../theme/textstyle.dart';
import '../../../theme/theme.dart';
import '../../../utils/dialog.dart';

class EditProfileController extends GetxController {
  TextEditingController usernameEditProfileC = TextEditingController();
  var usernameEditProfileKey = GlobalKey<FormState>().obs;
  TextEditingController namaLengkapEditProfileC = TextEditingController();
  var namaLengkapEditProfileKey = GlobalKey<FormState>().obs;
  TextEditingController noKtpEditProfileC = TextEditingController();
  var noKtpEditProfileKey = GlobalKey<FormState>().obs;
  TextEditingController alamatEditProfileC = TextEditingController();
  var alamatEditProfileKey = GlobalKey<FormState>().obs;
  TextEditingController noTelpEditProfileC = TextEditingController();
  var noTelpEditProfileKey = GlobalKey<FormState>().obs;

  final normalValidator =
      MultiValidator([RequiredValidator(errorText: "Kolom harus diisi")]);

  var context = Get.context!;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ImagePicker picker = ImagePicker();
  XFile? image;

  Future<void> pickImage() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    final storageStatus = android.version.sdkInt < 33
        ? await Permission.storage.request()
        : PermissionStatus.granted;
    // var status = await Permission.storage.request();
    if (storageStatus == PermissionStatus.granted) {
      var pickedImage =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
      if (pickedImage != null) {
        var croppedImage = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Potong Gambar',
                toolbarColor: yellow1_F9B401,
                toolbarWidgetColor: light,
                backgroundColor: light,
                statusBarColor: dark),
          ],
        );
        if (croppedImage != null) {
          image = XFile.fromData(await croppedImage.readAsBytes(),
              path: croppedImage.path);
          if (kDebugMode) {
            print(image!.name);
            print(image!.path);
          }
        } else {
          if (kDebugMode) {
            print("Image cropping cancelled");
          }
        }
      } else {
        if (kDebugMode) {
          print(image);
        }
      }
      update();
    } else if (storageStatus == PermissionStatus.denied) {
      Get.dialog(
        dialogAlertOnly(
          animationLink: 'assets/lottie/warning_aztravel.json',
          text: "Terjadi Kesalahan!",
          textSub: "Akses ke penyimpanan ditolak!",
          textAlert: getTextAlert(context),
          textAlertSub: getTextAlertSub(context),
        ),
      );
    } else {
      Get.dialog(
        dialogAlertOnly(
          animationLink: 'assets/lottie/warning_aztravel.json',
          text: "Terjadi Kesalahan!",
          textSub: "Akses ke penyimpanan ditolak! {err}",
          textAlert: getTextAlert(context),
          textAlertSub: getTextAlertSub(context),
        ),
      );
    }
  }

  Future<void> editProfil(String username, String namaLengkap, String noKTP,
      String nomorTelepon, String alamat) async {
    try {
      var email = auth.currentUser!.email;
      var dataMobilReference = firestore.collection('users');
      final docRef = dataMobilReference.doc(email);

      if (image != null) {
        File file = File(image!.path);
        String ext = image!.name.split(".").last;

        await storage.ref('datamobil/${docRef.id}.$ext').putFile(file);
        String urlImage =
            await storage.ref('datamobil/${docRef.id}.$ext').getDownloadURL();
        await docRef.update({
          'username': username,
          'namaLengkap': namaLengkap,
          'noKTP': noKTP,
          'nomorTelepon': nomorTelepon,
          'photoUrl': urlImage,
          'alamat': alamat
        });
      } else {
        await docRef.update({
          'username': username,
          'namaLengkap': namaLengkap,
          'noKTP': noKTP,
          'nomorTelepon': nomorTelepon,
          'alamat': alamat
        });
      }

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Data berhasil diubah.",
        textConfirm: 'Ya',
        onConfirm: () {
          Get.back();
          Get.back();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.snackbar("Error", "Data tidak berhasil ditambahkan.");
    }
  }

  @override
  void onInit() {
    super.onInit();
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
