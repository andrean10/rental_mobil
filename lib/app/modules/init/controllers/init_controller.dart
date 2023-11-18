import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../utils/constants_lottie.dart';
import '../../../widgets/buttons/custom_filled_button.dart';
import '../../../widgets/dialog/custom_dialog.dart';

class InitController extends GetxController {
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final FirebaseStorage _storage;

  late final Stream<ServiceStatus> serviceStatusStream;

  final Logger logger = Logger();

  var isAppAlreadyConnectedFirstTime = true;

  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;

  @override
  void onInit() {
    super.onInit();

    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;

    if (!kIsWeb) {
      serviceStatusStream = Geolocator.getServiceStatusStream();
    }
  }

  void showDialogError({
    required int typeRequestLocator,
    required bool isFirstRequest,
  }) {
    Get.dialog(
      CustomDialog(
        onWillPop: () async => true,
        title: (typeRequestLocator == 1)
            ? 'Aktifkan Lokasi'
            : 'Aktifkan Perizinan Lokasi',
        description: (typeRequestLocator == 1)
            ? 'Layanan lokasi diperlukan agar aplikasi dapat menentukan lokasi anda'
            : 'Perizinan lokasi diperlukan agar aplikasi dapat berjalan dengan baik',
        animation: ConstantsLottie.location,
        repeat: true,
        child: CustomFilledButton(
          width: double.infinity,
          onPressed: () async {
            try {
              if (isFirstRequest) {
                Get.back();
                determinePosition();
              } else {
                final settingsPage = switch (typeRequestLocator) {
                  1 => await Geolocator.openLocationSettings(),
                  2 => await Geolocator.openAppSettings(),
                  _ => false,
                };

                // if (settingsPage) Get.back();
              }
            } catch (e) {
              logger.e('error: $e');
            }
          },
          isFilledTonal: false,
          child: Text(
            'Aktifkan ${(typeRequestLocator == 1) ? 'Lokasi' : 'Perizinan'}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<Position> determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialogError(typeRequestLocator: 2, isFirstRequest: true);
        return Future.error('Perizinan lokasi ditolak');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialogError(typeRequestLocator: 2, isFirstRequest: false);
      return Future.error(
          'Perizinan lokasi ditolak secara permanen, buka pengaturan lokasi untuk mengaktifkan');
    }

    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      showDialogError(typeRequestLocator: 1, isFirstRequest: false);
      return Future.error('Layanan lokasi tidak aktif');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  bool isUserLogged() {
    final user = auth.currentUser;
    return user != null;
  }
}
