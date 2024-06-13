// ignore_for_file: unnecessary_overrides, use_build_context_synchronously

import 'package:az_travel/app/controller/api_controller.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class EditProfileController extends GetxController
    with GetTickerProviderStateMixin {
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

  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ImagePicker picker = ImagePicker();
  XFile? image;

  var apiC = Get.put(APIController());

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
          textAlert: getTextAlert(),
          textAlertSub: getTextAlertSub(),
        ),
      );
    } else {
      Get.dialog(
        dialogAlertOnly(
          animationLink: 'assets/lottie/warning_aztravel.json',
          text: "Terjadi Kesalahan!",
          textSub: "Akses ke penyimpanan ditolak! {err}",
          textAlert: getTextAlert(),
          textAlertSub: getTextAlertSub(),
        ),
      );
    }
  }

  Future<void> editProfil(String username, String namaLengkap, String noKTP,
      String nomorTelepon, String alamat) async {
    var email = auth.currentUser!.email;
    var uid = auth.currentUser!.uid;
    // var dataMobilReference = firestore.collection('users');
    // final docRef = dataMobilReference.doc(email);

    if (image != null) {
      // File file = File(image!.path);
      // String ext = image!.name.split(".").last;
      if (kDebugMode) {
        print('ada gambar');
      }
      apiC.updateUsersWithImage(
        username: username,
        namaLengkap: namaLengkap,
        noKTP: noKTP,
        noTelp: nomorTelepon,
        alamat: alamat,
        email: email!,
        uid: uid,
        imageFile: image,
      );

      // await storage.ref('datamobil/${docRef.id}.$ext').putFile(file);
      // String urlImage =
      //     await storage.ref('datamobil/${docRef.id}.$ext').getDownloadURL();
      // await docRef.update({
      //   'username': username,
      //   'namaLengkap': namaLengkap,
      //   'noKTP': noKTP,
      //   'nomorTelepon': nomorTelepon,
      //   'photoUrl': urlImage,
      //   'alamat': alamat
      // });
    } else {
      if (kDebugMode) {
        print('tidak ada gambar');
      }
      apiC.updateUsersWithoutImage(
        username: username,
        namaLengkap: namaLengkap,
        noKTP: noKTP,
        noTelp: nomorTelepon,
        alamat: alamat,
        email: email!,
        uid: uid,
      );
      // await docRef.update({
      //   'username': username,
      //   'namaLengkap': namaLengkap,
      //   'noKTP': noKTP,
      //   'nomorTelepon': nomorTelepon,
      //   'alamat': alamat
      // });
    }
  }

  late final AnimationController cAniUbahGambar;
  bool isUbahGambar = false;

  late final AnimationController cAniSimpan;
  bool isSimpan = false;

  @override
  void onInit() {
    super.onInit();
    cAniUbahGambar = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 70),
    );
    cAniSimpan = AnimationController(
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
