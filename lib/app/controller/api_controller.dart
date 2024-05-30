// ignore_for_file: invalid_use_of_protected_member

import 'package:az_travel/app/data/constants/string.dart';
import 'package:az_travel/app/data/models/datamobilmodel.dart';
import 'package:az_travel/app/data/models/pesananmobilmodel.dart';
import 'package:az_travel/app/utils/loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class APIController extends GetxController {
  final dio = Dio(BaseOptions(
      baseUrl: EMULATOR_IP, headers: {"Access-Control-Allow-Origin": "*"}));

  var imageIP = EMULATOR;

  var isLoading = false.obs;

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
        Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        Get.snackbar('Gagal', 'Terjadi kesalahan.');
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
        await simulateDelayShorter();
        isLoading.value = false;
      } else {
        Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        Get.snackbar('Gagal', 'Terjadi kesalahan.');
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

  Future<void> postDataReservasi(
      int idMobil,
      String namaMobil,
      String namaPemesan,
      String alamat,
      String harga,
      String noKTP,
      String telepon,
      String tanggalPesanStart,
      String tanggalPesanEnd) async {
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
      };

      var res = await dio.post(
        url,
        data: data,
      );

      if (kDebugMode) {
        debugPrint('hasil response: ${res.data}');
      }

      if (res.data['message'] == 'success') {
        debugPrint('Pesanan terkirim ke server');
        snapToken = res.data['snap_token'];

        if (kDebugMode) {
          print('SNAP TOKEN: $snapToken');
        }
        isLoading.value = false;
      } else {
        Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        Get.snackbar('Error', 'Terjadi kesalahan.');
      }
    }
  }
}
