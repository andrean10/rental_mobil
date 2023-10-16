import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:app_rental_mobil/app/modules/init/controllers/init_controller.dart';
import 'package:app_rental_mobil/app/shared/shared_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../routes/app_pages.dart';

class MainController extends GetxController {
  late final InitController _initC;
  final currentIndex = 0.obs;

  final logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _initController();
  }

  void _initController() {
    if (Get.isRegistered<InitController>()) {
      _initC = Get.find<InitController>();
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
