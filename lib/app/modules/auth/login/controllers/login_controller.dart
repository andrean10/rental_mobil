import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:app_rental_mobil/app/routes/app_pages.dart';
import 'package:app_rental_mobil/app/shared/shared_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../shared/shared_values.dart';
import '../../../../utils/constants_lottie.dart';
import '../../../../widgets/dialog/custom_dialog.dart';
import '../../../init/controllers/init_controller.dart';

class LoginController extends GetxController {
  late final InitController _initC;

  final formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  final email = ''.obs;

  final isVisiblePassword = false.obs;
  final isLoading = false.obs;

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

    emailC.addListener(setEmail);
  }

  void setEmail() => email.value = emailC.text;

  void confirm() async {
    FocusScope.of(Get.context!).unfocus();
    isLoading.value = true;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      checkAuth();
    } else {
      isLoading.value = false;
    }
  }

  void checkAuth() async {
    final theme = Get.theme;

    try {
      final data = await _initC.firestore
          .collection('users')
          .where('email', isEqualTo: email.value.trim())
          .limit(1)
          .get()
          .then(
            (value) => value.docs.map(
              (e) => UsersModel.fromFirestore(e.data()),
            ),
          );

      logger.d('debug: data $data');

      if (data.isNotEmpty) {
        logger.d('debug: data ${data.toString()}');

        await _initC.auth.signInWithEmailAndPassword(
          email: email.value.trim(),
          password: passwordC.text,
        );

        final isActive = data.firstOrNull?.isActive;
        final role = data.firstOrNull?.role;

        if (isActive != null && isActive) {
          if (role != null) {
            moveToMain(role);
          }
        } else {
          showSnackBar(
            content: const Text(
              'Akunmu belum diaktifkan, beritahu admin untuk mengaktifkan akunmu terlebih dahulu!',
            ),
            backgroundColor: theme.colorScheme.error,
            duration: 3.seconds,
          );
        }
      } else {
        showSnackBar(
          content: const Text('Email salah!'),
          backgroundColor: theme.colorScheme.error,
          duration: 3.seconds,
        );
      }
    } on FirebaseAuthException catch (e) {
      logger.e('error: $e');

      final errMessage = switch (e.code) {
        'user-disabled' =>
          'Akunmu belum diaktifkan, beritahu admin untuk mengaktifkan akunmu terlebih dahulu!',
        'user-not-found' => 'User tidak ditemukan!',
        'wrong-password' => 'Password salah!',
        _ => 'Password salah!',
      };

      showSnackBar(
        content: Text(errMessage),
        backgroundColor: theme.colorScheme.error,
        duration: 3.seconds,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void moveToMain(int role) {
    if (role == SharedValues.USER && GetPlatform.isWeb) {
      Get.dialog(
        const CustomDialog(
          title: 'Perhatian!',
          description:
              'Maaf, aplikasi ini belum mendukung login user di web, silahkan login di aplikasi mobile',
          animation: ConstantsLottie.warning,
        ),
        barrierDismissible: false,
      ).whenComplete(() => _initC.auth.signOut());
    } else if ((role == SharedValues.ADMIN_RENTAL ||
            role == SharedValues.SUPER_ADMIN) &&
        GetPlatform.isMobile) {
      Get.dialog(
        const CustomDialog(
          title: 'Perhatian!',
          description:
              'Maaf, aplikasi ini belum mendukung akses login admin di mobile, silahkan login di aplikasi web',
          animation: ConstantsLottie.warning,
        ),
        barrierDismissible: false,
      ).whenComplete(() => _initC.auth.signOut());
    } else {
      Get.dialog(
        const CustomDialog(
          title: 'Login Berhasil',
          description: 'Sistem akan mengarahkan kamu ke halaman utama',
          animation: ConstantsLottie.success,
        ),
        barrierDismissible: false,
      );

      Future.delayed(3.seconds, () {
        Get.offAllNamed(Routes.MAIN);
      });
    }
  }

  void moveToRegister() => Get.toNamed(Routes.REGISTER);
}
