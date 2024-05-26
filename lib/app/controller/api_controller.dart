// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';

import 'package:az_travel/app/data/models/datamobilmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class APIController extends GetxController {
  final dio = Dio(BaseOptions(headers: {"Access-Control-Allow-Origin": "*"}));

  var dataMobilModel = <DataMobilModel>[].obs;

  var isLoading = false.obs;

  var snapToken = '';

  var searchText = ''.obs;

  Future<List<DataMobilModel>> getDataMobil() async {
    try {
      dataMobilModel.clear();
      // await Future.delayed(const Duration(seconds: 2));
      String url = 'http://10.0.2.2:8000/api/mobil/';

      var res = await dio.get(url);

      if (kDebugMode) {
        print(res.data);
      }

      if (res.statusCode == 200) {
        var dataMobil = List.from(res.data['data'] as List)
            .map((e) => DataMobilModel.fromJson(e))
            .toList();
        return dataMobil;
      } else {
        Get.snackbar('Gagal', 'Terjadi kesalahan.');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('$e');
        Get.snackbar('Gagal', 'Terjadi kesalahan.');
      }
      throw Exception('Failed to load data');
    }
  }

  // List<DataMobilModel> filteredData(List<DataMobilModel> dataMobil) {
  //   if (searchText.isEmpty) {
  //     return dataMobil;
  //   } else {
  //     return dataMobil.where((data) {
  //       return data.namaMobil!.toLowerCase().contains(searchText.toLowerCase());
  //     }).toList();
  //   }
  // }

  List<DataMobilModel> filteredData(List<DataMobilModel> dataMobil) {
    if (searchText.isEmpty) {
      return dataMobil;
    } else {
      return dataMobil
          .where((data) =>
              data.namaMobil!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
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

      String url = 'http://10.0.2.2:8000/api/reservasi/store/';
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
