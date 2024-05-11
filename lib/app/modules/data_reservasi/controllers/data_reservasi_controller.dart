// ignore_for_file: unnecessary_overrides

import 'package:az_travel/app/data/models/pesananmobilmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataReservasiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<List<PesananMobil>> firestorePesananMobillList;
  @override
  void onInit() {
    super.onInit();
    firestorePesananMobillList = firestore
        .collection('PesananMobil')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((documentSnapshot) => PesananMobil.fromJson(documentSnapshot))
            .toList());
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
