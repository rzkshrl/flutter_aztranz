// ignore_for_file: invalid_use_of_protected_member, use_build__synchronously

import 'dart:developer';

import 'package:az_travel/app/data/constants/string.dart';
import 'package:az_travel/app/data/models/datamobilmodel.dart';
import 'package:az_travel/app/data/models/pesananmobilmodel.dart';
import 'package:az_travel/app/data/models/usermodel.dart';
import 'package:az_travel/app/utils/loading.dart';
import 'package:dio/dio.dart' as dioo;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../theme/textstyle.dart';
import '../utils/dialog.dart';

class APIController extends GetxController {
  // inisiasi package dio untuk REST API
  final dio = dioo.Dio(dioo.BaseOptions(
      baseUrl: EMULATOR_IP, headers: {"Access-Control-Allow-Origin": "*"}));

  // custom IP untuk gambar
  var imageIP = EMULATOR;

  var isLoading = false.obs;

  // inisiasi model untuk tabel mobil dari SQL
  var dataMobilModel = <DataMobilModel>[].obs;
  var filteredDataMobil = <DataMobilModel>[].obs;
  var searchText = ''.obs;

  Future<void> getDataMobil() async {
    try {
      isLoading.value = true;
      dataMobilModel.clear();
      String url = 'api/mobil/';

      var res = await dio.get(url);

      // if (kDebugMode) {
      //   print(res.data);
      // }

      if (res.statusCode == 200) {
        var dataMobil = List.from(res.data['data'] as List)
            .map((e) => DataMobilModel.fromJson(e))
            .toList();
        dataMobilModel.assignAll(dataMobil);
        filteredDataMobil.assignAll(dataMobil);
        await simulateDelayShorter();
        isLoading.value = false;
      } else {
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
      throw Exception('Failed to load data');
    }
  }

  void searchMobil(String query) {
    searchText.value = query;
    if (query.isEmpty) {
      filteredDataMobil.assignAll(dataMobilModel);
    } else {
      filteredDataMobil.assignAll(
        dataMobilModel
            .where((mobil) =>
                mobil.namaMobil!.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  // inisiasi model untuk tabel reservasi dari SQL
  var dataReservasiModel = <DataReservasiModel>[].obs;
  var filteredDataReservasiModel = <DataReservasiModel>[].obs;
  var searchTextHistory = ''.obs;

  Future<void> getDataReservasi() async {
    try {
      isLoading.value = true;
      dataMobilModel.clear();
      String url = 'api/reservasi/';

      var res = await dio.get(url);

      // if (kDebugMode) {
      //   print(res.data);
      // }

      if (res.statusCode == 200) {
        var dataReservasi = List.from(res.data['data'] as List)
            .map((e) => DataReservasiModel.fromJson(e))
            .toList();
        dataReservasiModel.assignAll(dataReservasi);
        filteredDataReservasiModel.assignAll(dataReservasi);
        dataReservasiModel
            .sort((a, b) => b.idReservasi!.compareTo(a.idReservasi!));
        filteredDataReservasiModel
            .sort((a, b) => b.idReservasi!.compareTo(a.idReservasi!));
        await simulateDelayShorter();
        isLoading.value = false;
      } else {
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
      throw Exception('Failed to load data');
    }
  }

  void searchRiwayatReservasi(String query) {
    searchTextHistory.value = query;
    if (query.isEmpty) {
      filteredDataReservasiModel.assignAll(dataReservasiModel);
    } else {
      filteredDataReservasiModel.assignAll(
        dataReservasiModel
            .where(
              (item) => item.namaMobil!.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList(),
      );
    }
  }

  var snapToken = '';

  // inisiasi model untuk mengambil data tunggal dari tabel reservasi di SQL
  var hasilResponseDataReservasi = DataReservasiModel().obs;
  var hasilReservasiNow = DataReservasiModel().obs;

  Future<void> postDataReservasi(
      int idMobil,
      String namaMobil,
      String namaPemesan,
      String alamat,
      String harga,
      String noKTP,
      String telepon,
      String tanggalPesanStart,
      String tanggalPesanEnd,
      String fotoUrl) async {
    try {
      isLoading.value = true;

      String url = 'api/reservasi/store/';
      var data = {
        'mobil_id': idMobil,
        'nama_mobil': namaMobil,
        'nama_pemesan': namaPemesan,
        'gross_amount': 1,
        'alamat': alamat,
        'harga': harga,
        'no_ktp': noKTP,
        'telepon': telepon,
        'tanggalpesan_start': tanggalPesanStart,
        'tanggalpesan_end': tanggalPesanEnd,
        'foto_url': fotoUrl,
        'status': "Belum Bayar",
      };

      var res = await dio.post(
        url,
        data: data,
      );

      if (kDebugMode) {
        debugPrint('hasil response: ${res.data}');
      }

      if (res.statusCode == 200) {
        debugPrint('Pesanan terkirim ke server');
        snapToken = res.data['snap_token'];
        hasilResponseDataReservasi.value =
            DataReservasiModel.fromJson(res.data['data']);
        getDetailReservasiSingle(hasilResponseDataReservasi.value.idReservasi!);

        if (kDebugMode) {
          print('SNAP TOKEN: $snapToken');
        }
        isLoading.value = false;
      } else {
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        // Get.snackbar('Error', 'Terjadi kesalahan.');
      }
    }
  }

  Future<void> postDataMobilStatus(
    int idMobil,
  ) async {
    try {
      isLoading.value = true;

      String url = 'api/mobil/store/';
      var data = {
        'id_mobil': idMobil,
      };

      var res = await dio.post(
        url,
        data: data,
      );

      if (kDebugMode) {
        debugPrint('hasil response: ${res.data}');
      }

      if (res.statusCode == 200) {
        debugPrint('Pesanan terkirim ke server');

        if (kDebugMode) {
          print('SNAP TOKEN: $snapToken');
        }
        isLoading.value = false;
      } else {
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        // Get.snackbar('Error', 'Terjadi kesalahan.');
      }
    }
  }

  Future<void> updateStatusReservasi(int idReservasi) async {
    try {
      isLoading.value = true;

      String url = 'api/reservasi/store/';
      var data = {
        'id_reservasi': idReservasi,
      };

      var res = await dio.post(
        url,
        data: data,
      );

      if (kDebugMode) {
        debugPrint('hasil response: ${res.data}');
      }

      if (res.statusCode == 200) {
        debugPrint('Pesanan dibayar');

        isLoading.value = false;
      } else {
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        // Get.snackbar('Error', 'Terjadi kesalahan.');
      }
    }
  }

  Future<DataReservasiModel?> getDetailReservasiSingle(int idReservasi) async {
    try {
      isLoading.value = true;

      String url = 'api/reservasi/';

      var res = await dio.get(url);

      if (res.statusCode == 200) {
        log('get data pesanan single berhasil');
        var jsonData = res.data['data'] as List;

        // Seleksi data berdasarkan id_reservasi
        var item = jsonData.firstWhere(
          (item) => item['id_reservasi'] == idReservasi,
          orElse: () => '',
        );

        isLoading.value = false;

        // Jika data ditemukan, konversi ke DataReservasiModel
        if (item != null) {
          return hasilReservasiNow.value = DataReservasiModel.fromJson(item);
        } else {
          return null;
        }
      } else {
        throw Exception('Gagal, terjadi kesalahan');
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    }
    return null;
  }

  // inisiasi model untuk tabel users dari SQL, data tunggal untuk data user yang masuk saat ini
  var dataUserModel = UserSQLModel().obs;

  Future<void> postUsers(
      {required String username,
      required String email,
      String? namaLengkap,
      String? noKTP,
      String? noTelp,
      String? alamat,
      required String uid,
      required String fotoUrl}) async {
    try {
      isLoading.value = true;

      String url = 'api/user/store/';
      var data = {
        "username": username,
        "uid": uid,
        "nama_lengkap": namaLengkap,
        "email": email,
        "alamat": alamat,
        "no_ktp": noKTP,
        "no_telp": noTelp,
        "foto_url": fotoUrl,
      };

      var res = await dio.post(
        url,
        data: data,
      );

      if (kDebugMode) {
        debugPrint('hasil response: ${res.data}');
      }

      if (res.statusCode == 200) {
        debugPrint('User berhasil disimpan ke server');

        isLoading.value = false;
      } else {
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        // Get.snackbar('Error', 'Terjadi kesalahan.');
      }
    }
  }

  Future<void> updateUsersWithImage(
      {required String username,
      required String email,
      String? namaLengkap,
      String? noKTP,
      String? noTelp,
      String? alamat,
      String? uid,
      XFile? imageFile}) async {
    try {
      isLoading.value = true;

      String url = 'api/user/store/';

      dioo.FormData formData = dioo.FormData.fromMap({
        'foto_url': await dioo.MultipartFile.fromFile(
          imageFile!.path,
          filename: imageFile.name,
        ),
        "username": username,
        "uid": uid,
        "nama_lengkap": namaLengkap,
        "email": email,
        "alamat": alamat,
        "no_ktp": noKTP,
        "no_telp": noTelp, // Menambahkan data string lainnya
      });

      var res = await dio.post(
        url,
        data: formData,
      );

      if (kDebugMode) {
        debugPrint('hasil response: ${res.data}');
      }

      if (res.statusCode == 200) {
        debugPrint('User berhasil disimpan ke server');
        Get.dialog(
          dialogAlertBtn(
            onPressed: () async {
              Get.back();
              Get.back();
            },
            animationLink: 'assets/lottie/finish_aztravel.json',
            widthBtn: 26.w,
            textBtn: "OK",
            text: "Berhasil!",
            textSub: "Data berhasil diubah.",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
            textAlertBtn: getTextAlertBtn(),
          ),
        );
        isLoading.value = false;
      } else {
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        Get.dialog(
          dialogAlertOnly(
            animationLink: 'assets/lottie/warning_aztravel.json',
            text: "Terjadi Kesalahan!",
            textSub: "Data gagal diubah.",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
          ),
        );
        // Get.snackbar('Error', 'Terjadi kesalahan.');
      }
    }
  }

  Future<void> updateUsersWithoutImage({
    required String username,
    required String email,
    String? namaLengkap,
    String? noKTP,
    String? noTelp,
    String? alamat,
    String? uid,
  }) async {
    try {
      isLoading.value = true;

      String url = 'api/user/store/';
      var data = {
        "username": username,
        "uid": uid,
        "nama_lengkap": namaLengkap,
        "email": email,
        "alamat": alamat,
        "no_ktp": noKTP,
        "no_telp": noTelp,
      };

      var res = await dio.post(
        url,
        data: data,
      );

      if (kDebugMode) {
        debugPrint('hasil response: ${res.data}');
      }

      if (res.statusCode == 200) {
        debugPrint('User berhasil disimpan ke server');
        Get.dialog(
          dialogAlertBtn(
            onPressed: () async {
              Get.back();
              Get.back();
            },
            animationLink: 'assets/lottie/finish_aztravel.json',
            widthBtn: 26.w,
            textBtn: "OK",
            text: "Berhasil!",
            textSub: "Data berhasil diubah.",
            textAlert: getTextAlert(),
            textAlertSub: getTextAlertSub(),
            textAlertBtn: getTextAlertBtn(),
          ),
        );

        isLoading.value = false;
      } else {
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        // Get.snackbar('Error', 'Terjadi kesalahan.');
      }
    }
  }

  Future<UserSQLModel?> getDataUserCondition(String email) async {
    try {
      isLoading.value = true;

      String url = 'api/user/';

      var res = await dio.get(url);

      if (res.statusCode == 200) {
        log('get data user berhasil');
        var jsonData = res.data['data'] as List;

        // Seleksi data berdasarkan email
        var userData = jsonData.firstWhere(
          (item) => item['email'] == email.toLowerCase(),
          orElse: () => '',
        );

        isLoading.value = false;

        // Jika user ditemukan, konversi ke UserSQLModel
        if (userData != null) {
          return dataUserModel.value = UserSQLModel.fromJson(userData);
        } else {
          return null;
        }
      } else {
        throw Exception('Gagal, terjadi kesalahan');
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        // Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    }
    return null;
  }
}
