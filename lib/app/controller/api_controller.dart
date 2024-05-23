// ignore_for_file: invalid_use_of_protected_member

import 'package:az_travel/app/data/models/datamobilmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class APIController extends GetxController {
  final dio = Dio();

  var dataMobilModel = <DataMobilModel>[].obs;

  var isLoading = false.obs;

  var snapToken = '';

  Future<List<DataMobilModel>> getDataMobil() async {
    try {
      isLoading.value = true;
      dataMobilModel.clear();
      Future.delayed(const Duration(seconds: 2));
      String url = 'http://10.0.2.2:8000/api/mobil';

      var res = await dio.get(url);

      if (res.data['message'] == 'succes') {
        dataMobilModel.value = List.from(res.data['data'] as List)
            .map((e) => DataMobilModel.fromJson(e))
            .toList();

        isLoading.value = false;
      } else {
        Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
    }
    List<DataMobilModel> dataMobilList = dataMobilModel.value;
    return dataMobilList;
  }

  var searchText = ''.obs;

  List<DataMobilModel> get filteredUsers {
    if (searchText.isEmpty) {
      return dataMobilModel;
    } else {
      return dataMobilModel.where((data) {
        return data.namaMobil!
                .toLowerCase()
                .contains(searchText.toLowerCase()) ||
            data.merek!.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }
  }

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

      String url = 'http://10.0.2.2:8000/api/reservasi/store';
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
