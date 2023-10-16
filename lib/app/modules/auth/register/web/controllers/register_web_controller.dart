import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:app_rental_mobil/app/shared/shared_method.dart';
import 'package:app_rental_mobil/app/shared/shared_values.dart';
import 'package:app_rental_mobil/app/widgets/dialog/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../../routes/app_pages.dart';
import '../../../../../utils/constants_lottie.dart';
import '../../../../init/controllers/init_controller.dart';

class RegisterWebController extends GetxController {
  late final InitController _initC;

  final formKey = GlobalKey<FormState>();
  final rentalNameC = TextEditingController();
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final numberPhoneC = TextEditingController();
  final addressC = TextEditingController();

  final email = ''.obs;
  final rentalName = ''.obs;
  final fullName = ''.obs;
  final numberPhone = ''.obs;
  final address = ''.obs;

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
    rentalNameC.addListener(setRentalName);
    fullNameC.addListener(setFullName);
    numberPhoneC.addListener(setNumberPhone);
    addressC.addListener(setAddress);
  }

  void setEmail() => email.value = emailC.text;

  void setRentalName() => rentalName.value = rentalNameC.text;

  void setFullName() => fullName.value = fullNameC.text;

  void setNumberPhone() => numberPhone.value = numberPhoneC.text;

  void setAddress() => address.value = addressC.text;

  void confirm() {
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
      final data = await _initC.auth.fetchSignInMethodsForEmail(email.value);

      if (data.isEmpty) {
        final userCredential = await _initC.auth.createUserWithEmailAndPassword(
          email: email.value,
          password: passwordC.text,
        );

        if (userCredential.user != null) {
          await userCredential.user!.updateDisplayName(fullName.value);
          storeToDb(userCredential.user!);
        }
      } else {
        showSnackBar(
          content: const Text('Email sudah terdaftar, silahkan login'),
          duration: 3.seconds,
        );
      }
    } on FirebaseAuthException catch (e) {
      logger.e('error: $e');

      final errMessage = switch (e.code) {
        'email-already-in-use' =>
          'Email sudah digunakan, silahkan gunakan email lain',
        'operation-not-allowed' => 'Operasi tidak diizinkan',
        _ => 'Terjadi masalah saat mengecek autentikasi'
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

  Future<void> storeToDb(User user) async {
    final dataUser = UsersModel(
      uid: user.uid,
      email: user.email,
      fullName: fullName.value,
      rentalName: rentalName.value,
      numberPhone: numberPhone.value,
      address: address.value,
      role: SharedValues.ADMIN_RENTAL,
    );

    try {
      await _initC.firestore
          .collection('users')
          .doc(user.uid)
          .set(dataUser.toFirestore());
      moveToMain();
    } on FirebaseException catch (e) {
      logger.e('error: $e');

      showSnackBar(
        content:
            const Text('Terjadi masalah saat menyimpan data, harap coba lagi!'),
        duration: 3.seconds,
        backgroundColor: Get.theme.colorScheme.error,
      );
    }
  }

  void moveToMain() {
    Get.dialog(
      const CustomDialog(
        title: 'Pendaftaran Berhasil',
        description:
            'Mantap.. akun kamu sudah terdaftar, sistem akan mengarahkan kamu ke halaman utama',
        animation: ConstantsLottie.success,
      ),
      barrierDismissible: false,
    );

    Future.delayed(5.seconds, () => Get.offAllNamed(Routes.MAIN));
  }

  void moveToLogin() => Get.back();
}
