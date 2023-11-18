import 'package:app_rental_mobil/app/modules/init/controllers/init_controller.dart';
import 'package:app_rental_mobil/app/shared/shared_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../../db/models/pesanan_model.dart';

class RiwayatTransaksiMobileController extends GetxController {
  late final InitController _initC;

  final keluhanC = TextEditingController();
  final keluhan = ''.obs;
  final isSendLocation = false.obs;

  Position? position;

  final isLoading = false.obs;

  final logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  void _init() {
    if (Get.isRegistered<InitController>()) {
      _initC = Get.find<InitController>();
    }

    keluhanC.addListener(setKeluhan);
  }

  void setKeluhan() => keluhan.value = keluhanC.text;

  Stream<List<PesananModel>> streamRiwayatTransaksi() {
    return _initC.firestore
        .collection('pesanan')
        .where('users.order.uid', isEqualTo: _initC.auth.currentUser!.uid)
        .orderBy(
          'tanggal_selesai',
          descending: true,
        )
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => PesananModel.fromFirestore(e.data()))
              .toList(),
        );
  }

  bool checkIsRented(DateTime? tanggalSelesai) {
    if (tanggalSelesai == null) return false;
    return tanggalSelesai.isAfter(DateTime.now());
  }

  Future<Position> checkGPS() {
    Get.snackbar(
      'Perhatian',
      'Sedang mengambil data lokasi, tunggu sebentar...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
    return _initC.determinePosition();
  }

  Future<void> addKeluhan(PesananModel item) async {
    isLoading.value = true;

    if (isSendLocation.value) {
      if (position != null) {
        final dataKeluhan = item.userOrder?.copyWith(
          order: item.userOrder?.order?.copyWith(
            keluhan: keluhan.value,
            locationKeluhan: GeoPoint(
              position!.latitude,
              position!.longitude,
            ),
          ),
        );

        await storeToDb(docId: item.uid!, dataKeluhan: dataKeluhan!);
      } else {
        checkGPS().then((value) {
          position = value;
          addKeluhan(item);
        }).catchError((e) {
          logger.e(e);
          isLoading.value = false;
          Get.snackbar(
            'Perhatian',
            'Gagal mengambil data lokasi, silahkan coba lagi',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        });
      }
    } else {
      final dataKeluhan = item.userOrder?.copyWith(
        order: item.userOrder?.order?.copyWith(keluhan: keluhan.value),
      );

      await storeToDb(docId: item.uid!, dataKeluhan: dataKeluhan!);
    }
  }

  Future<void> storeToDb({
    required String docId,
    required UserOrder dataKeluhan,
  }) async {
    try {
      await _initC.firestore
          .collection('pesanan')
          .doc(docId)
          .update(dataKeluhan.keluhanToFirestore());

      showSnackBar(
        content: const Text('Keluhan berhasil dikirim!'),
        backgroundColor: Colors.green,
      );
      clearKeluhan();
      Get.back();
    } catch (e) {
      logger.e('Error: $e');
      showSnackBar(
        content: const Text('Keluhan gagal dikirim!'),
        backgroundColor: Colors.red,
      );
    }
  }

  void clearKeluhan() {
    keluhanC.clear();
    keluhan.value = '';
    isSendLocation.value = false;
    position = null;
    isLoading.value = false;
  }
}
