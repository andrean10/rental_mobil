import 'dart:async';

import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:app_rental_mobil/app/modules/init/controllers/init_controller.dart';
import 'package:app_rental_mobil/app/shared/shared_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../routes/app_pages.dart';

class MainController extends GetxController {
  late final InitController _initC;
  final currentIndex = 0.obs;
  StreamSubscription<Position>? _userPositon;

  final logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _initController();
  }

  Future<void> _initController() async {
    if (Get.isRegistered<InitController>()) {
      _initC = Get.find<InitController>();
    }

    if (GetPlatform.isAndroid) {
      print('posisi di cek secara realtime');

      try {
        final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
        print('isLocationEnabled = $isLocationEnabled');

        if (isLocationEnabled) {
          await _initC.determinePosition();
          _updateRealtimeLocation();
        }
      } catch (e) {
        _initC.logger.e('Error: $e');
      }
    }
  }

  void _updateRealtimeLocation() {
    _userPositon = _initC.getPositionStream();

    if (_userPositon != null) {
      final uidUser = _initC.auth.currentUser?.uid;

      _userPositon!.onData((data) async {
        print('posisi user = ${data.latitude}, ${data.longitude}');

        // cek dulu apakah user punya kendaraan yang sedang disewa/berlangsung
        final dataPesanan = await _initC.firestore
            .collection('pesanan')
            .where(
              FieldPath.fromString('users.order.uid'),
              isEqualTo: uidUser,
            )
            .get();

        if (dataPesanan.size > 0) {
          final batch = _initC.firestore.batch(); // Use batch for bulk updates
          final listPesanan = dataPesanan.docs;

          for (var pesanan in listPesanan) {
            final pesananRef = pesanan.reference;
            batch.update(pesananRef, {
              'users.order.location': GeoPoint(data.latitude, data.longitude),
            });
          }

          try {
            await batch.commit(); // Commit all updates at once
            print('Lokasi pesanan berhasil diperbarui.');
          } catch (e) {
            logger.e('Gagal memperbarui lokasi pesanan: $e');
          }
        }
      });
    }
  }

  void changeIndexMobile(int index) {
    if (index != 2) {
      currentIndex.value = index;
    } else {
      logOut();
    }
  }

  void changeIndexRentalAdmin(int index) {
    if (index != 5) {
      currentIndex.value = index;
    } else {
      logOut();
    }
  }

  void changeIndexWebSuperAdmin(int index) {
    if (index != 4) {
      currentIndex.value = index;
    } else {
      logOut();
    }
  }

  Future<UsersModel> checkRoleUser() async {
    final uid = _initC.auth.currentUser!.uid;
    final user = await _initC.firestore
        .collection('users')
        .where(
          'uid',
          isEqualTo: uid,
        )
        .limit(1)
        .get()
        .then(
          (value) => UsersModel.fromFirestore(value.docs.first.data()),
        );
    return user;
  }

  void logOut() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.warning_rounded,
          color: Colors.red,
        ),
        title: const Text('Konfirmasi'),
        content: const Text('Apakah anda yakin ingin keluar aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _initC.auth.signOut();
                Get.offAllNamed(Routes.LOGIN);
              } on FirebaseAuthException catch (e) {
                logger.e('error: $e');
                // gagal logout
                showSnackBar(
                  content: const Text('Gagal keluar dari aplikasi'),
                  backgroundColor: Colors.red,
                );
              }
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
