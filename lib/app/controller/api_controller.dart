import 'package:az_travel/app/data/models/datamobilmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class APIController extends GetxController {
  final dio = Dio();

  var dataMobilModel = <DataMobilModel>[].obs;

  var isLoading = false.obs;

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
}
