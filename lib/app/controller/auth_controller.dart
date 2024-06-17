// ignore_for_file: use_build__synchronously

import 'dart:developer';

import 'package:az_travel/app/controller/api_controller.dart';
import 'package:az_travel/app/theme/textstyle.dart';
import 'package:az_travel/app/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';

import '../data/models/usermodel.dart';
import '../routes/app_pages.dart';
import '../utils/dialog.dart';

class AuthController extends GetxController {
  var isAuth = false.obs;

  // inisiasi objek (user) yg diperoleh dari proses GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //akun yg sudah login dari GoogleSignIn disimpan di _currentUser
  GoogleSignInAccount? _currentUser;

  //data yang diperlukan untuk login disimpan di userCredential
  UserCredential? userCredential;

  // inisiasi Firebase Authentication untuk autentikasi user, baik email maupun Google Sign In
  FirebaseAuth auth = FirebaseAuth.instance;

  //inisiasi model data user
  var dataUserModel = UserSQLModel().obs;

  var apiC = Get.put(APIController());

  // variabel reactive untuk text error form
  var errorStatusPass = false.obs;
  var errorTextPass = ''.obs;
  var errorStatusPassAgain = false.obs;
  var errorTextPassAgain = ''.obs;
  var errorStatusLoginEmail = false.obs;
  var errorTextLoginEmail = ''.obs;
  var errorStatusLoginPass = false.obs;
  var errorTextLoginPass = ''.obs;

  // inisiasi fungsi untuk pertama kali login agar bisa auto-login seterusnya di app
  Future<void> firstInitialized() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;

        apiC.getDataUserCondition(auth.currentUser!.email!);
      }
    });
  }

  Future<bool> autoLogin() async {
    //auto login
    try {
      final isSignIn = auth.currentUser;
      if (isSignIn != null) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  //membuat user
  Future<UserCredential> createUser(String email, String password) async {
    try {
      // membuat user dengan email dan password di FirebaseAuth
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // mengirim verifikasi email ke email yang terdaftar
      await userCredential.user!.sendEmailVerification();
      return userCredential;
    } catch (e) {
      throw Exception(e);
    }
  }

  // register untuk membuat data user
  Future<void> register(
      String username,
      String email,
      String password,
      String passwordAgain,
      String namaLengkap,
      String noKTP,
      String noTelp,
      String alamat) async {
    try {
      // pengecekan form kata sandi dengan form ulangi kata sandi
      if (password != passwordAgain) {
        errorStatusPass.value = true;
        errorTextPass.value = 'Kata sandi harus sama!';
        errorStatusPassAgain.value = true;
        errorTextPassAgain.value = 'Kata sandi harus sama!';
      } else {
        // mengambil data user dari SQL untuk pengecekan
        apiC.getDataUserCondition(email);
        if (kDebugMode) {
          print("email dari GET user/ : ${apiC.dataUserModel.value.email}");
          print(
              "nama_lengkap dari GET user/ : ${apiC.dataUserModel.value.namaLengkap}");
        }

        // pengecekan apakah data user di SQL belum ada
        if (apiC.dataUserModel.value.email == null ||
            apiC.dataUserModel.value.email != email) {
          // jika user belum ada, buat user dengan email dan password yang akan tersimpan sebagai UserCredential
          if (kDebugMode) {
            print('buat akun');
          }
          UserCredential user = await createUser(email, password);

          Get.back();

          // mengambil uid
          String uid = user.user?.uid ?? '';
          User? userNow = await auth
              .authStateChanges()
              .firstWhere((user) => user?.uid == uid);

          // mengupdate displayName dari UserCredential
          if (userNow != null) {
            await userNow.updateDisplayName(namaLengkap);
          }

          // menyimpan user ke SQL dengan POST
          apiC.postUsers(
              username: username,
              email: email,
              namaLengkap: namaLengkap,
              noKTP: noKTP,
              noTelp: noTelp,
              alamat: alamat,
              uid: uid,
              fotoUrl: '');

          if (kDebugMode) {
            print('User berhasil dibuat dan bisa login');
          }

          user.user!
              .sendEmailVerification(); // mengirim verifikasi email untuk akun

          // dialog sukses
          await Get.dialog(
            dialogAlertOnly(
              animationLink: 'assets/lottie/finish_aztravel.json',
              text: "Berhasil!",
              textSub:
                  "Akun berhasil dibuat. Silahkan masuk dan verifikasi akun anda.",
              textAlert: getTextAlert(),
              textAlertSub: getTextAlertSub(),
            ),
          );

          // routing masuk aplikasi
          await Get.offAllNamed(Routes.LOGIN);
        } else {
          // handling error
          Get.dialog(
            dialogAlertOnly(
              animationLink: 'assets/lottie/warning_aztravel.json',
              text: "Terjadi Kesalahan!",
              textSub: "Akun sudah ada dan pernah dibuat.",
              textAlert: getTextAlert(),
              textAlertSub: getTextAlertSub(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // error handling ketika email sudah pernah dipakai
      if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('Email already in use.');
        }
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Terjadi Kesalahan!",
            textSub: "Email sudah dipakai.",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
          ),
        );
      } else {
        if (kDebugMode) {
          print('Error : $e');
        }
      }
      throw Exception();
    } catch (e) {
      if (kDebugMode) {
        log('$e');
      }
    }
  }

  // fungsi login dengan email&password
  void login(String email, String password) async {
    try {
      // login menggunakan email dan password dari form
      UserCredential myUser = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // pengecekan apakah akun sudah terverifikasi di email
      if (myUser.user!.emailVerified) {
        isAuth.value = true;
        // ambil data user dari SQL
        await apiC.getDataUserCondition(email);

        // loading prop
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/loading_aztravel.json',
            text: "Memuat...",
            textSub: "",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
          ),
        );
        await simulateDelay();
        Get.back();

        // routing masuk aplikasi
        await Get.offAllNamed(Routes.HOME);
      } else {
        // dialog peringatan verifikasi email
        Get.dialog(
          dialogAlertBtn(
            onPressed: () async {
              myUser.user!
                  .sendEmailVerification(); // mengirim verifikasi email untuk akun
              Get.back();
              Future.delayed(const Duration(microseconds: 0), () async {
                await auth.signOut();
              });
              await Get.dialog(
                dialogAlertBtn(
                  onPressed: () async {
                    Get.back();
                  },
                  animationLink: 'assets/lottie/finish_aztravel.json',
                  widthBtn: 26.w,
                  textBtn: "OK",
                  text: "Email Sukses Terkirim!",
                  textSub: "Cek inbox email Anda",
                  textAlert: getTextAlert(),
                  textAlertSub: getTextAlertSub(),
                  textAlertBtn: getTextAlertBtn(),
                ),
              );
            },
            animationLink: 'assets/lottie/warning_aztravel.json',
            widthBtn: 26.w,
            textBtn: "Kirim",
            text: "Email Belum Diverifikasi!",
            textSub: "klik tombol Kirim untuk mengirim email verifikasi",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
            textAlertBtn: getTextAlertBtn(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handling error
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Terjadi Kesalahan!",
            textSub: "Akun tidak ditemukan.",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
          ),
        );
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
        errorStatusLoginPass.value = true;
        errorTextLoginPass.value = 'Kata sandi yang dimasukkan salah.';
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Terjadi Kesalahan!",
            textSub: "Kata sandi yang dimasukkan salah.",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
          ),
        );
      } else if (e.code == 'invalid-email') {
        if (kDebugMode) {
          print('Email address is not valid.');
        }
        errorStatusLoginEmail.value = true;
        errorTextLoginEmail.value = 'Email salah. Periksa kembali email anda.';
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Email salah!",
            textSub: "Periksa kembali email anda.",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
          ),
        );
      } else {
        if (kDebugMode) {
          print('Error : $e');
        }
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Terjadi Kesalahan!",
            textSub: "Periksa isian form anda.",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      Get.dialog(
        dialogAlertOnly(
          animationLink: 'assets/lottie/warning_aztravel.json',
          text: "Terjadi Kesalahan!",
          textSub: "Tidak dapat masuk.",
          textAlert: getTextAlert(),
          textAlertSub: getTextAlertSub(),
        ),
      );
    }
  }

  Future signInGoogle() async {
    // memastikan tidak ada akun yang tertinggal/login sebelum button dijalankan
    await _googleSignIn.signOut();
    await apiC.clearData();

    // menyimpan objek user yang masuk menggunakan GoogleSignIn
    _currentUser =
        await _googleSignIn.signIn().then((value) => _currentUser = value);

    final isSignIn = await _googleSignIn.isSignedIn();

    // pengecekan untuk menyimpan informasi user ketika akun sudah login
    if (isSignIn) {
      GoogleSignInAuthentication? googleAuthSign =
          await _currentUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuthSign?.accessToken,
          idToken: googleAuthSign?.idToken);

      await auth
          .signInWithCredential(credential)
          .then((value) => userCredential = value);

      log("$userCredential");

      // mengambil email dari informasi akun masuk dari FirebaseAuth serta GET data user dari SQL untuk pengecekan data
      String emailUser = auth.currentUser!.email.toString();
      await apiC.getDataUserCondition(emailUser);
      if (kDebugMode) {
        print("email dari GET user/ : ${apiC.dataUserModel.value.email}");
        print(
            "nama_lengkap dari GET user/ : ${apiC.dataUserModel.value.namaLengkap}");
      }

      // pengecekan apakah data sudah ada atau belum
      if (apiC.dataUserModel.value.email == null ||
          apiC.dataUserModel.value.email != emailUser) {
        // jika belum ada, buat data dengan POST semua kolom
        apiC.postUsers(
            username: _currentUser!.displayName ?? '',
            email: emailUser,
            namaLengkap: '',
            noKTP: '',
            noTelp: '',
            alamat: '',
            uid: auth.currentUser!.uid,
            fotoUrl: _currentUser!.photoUrl ?? '');

        isAuth.value = true;

        // dialog sukses
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/loading_aztravel.json',
            text: "Memuat...",
            textSub: "",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
          ),
        );
        await simulateDelay();
        Get.back();

        // routing masuk aplikasi
        await Get.offAllNamed(Routes.HOME);
      } else {
        // jika akun sudah ada, POST bagian tertentu saja yang perlu di update ketika masuk aplikasi (overwrite data)
        apiC.postUsers(
            username: _currentUser!.displayName ?? '',
            email: emailUser,
            namaLengkap: apiC.dataUserModel.value.namaLengkap,
            noKTP: apiC.dataUserModel.value.noKTP,
            noTelp: apiC.dataUserModel.value.nomorTelepon,
            alamat: apiC.dataUserModel.value.alamat,
            uid: auth.currentUser!.uid,
            fotoUrl: _currentUser!.photoUrl ?? '');

        isAuth.value = true;

        // dialog sukses
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/loading_aztravel.json',
            text: "Memuat...",
            textSub: "",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
          ),
        );
        await simulateDelay();
        Get.back();

        // routing masuk aplikasi
        await Get.offAllNamed(Routes.HOME);
      }
    }
  }

  Future<void> logout() async {
    // keluar/signOut
    await auth.signOut();

    if (kDebugMode) {
      print('berhasil logout');
    }

    Get.offAllNamed(Routes.LOGIN);
  }
}
