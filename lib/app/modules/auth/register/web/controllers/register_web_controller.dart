import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:app_rental_mobil/app/shared/shared_method.dart';
import 'package:app_rental_mobil/app/shared/shared_values.dart';
import 'package:app_rental_mobil/app/widgets/dialog/custom_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

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
  final multipleImgC = TextEditingController();

  final email = ''.obs;
  final rentalName = ''.obs;
  final fullName = ''.obs;
  final numberPhone = ''.obs;
  final address = ''.obs;
  final fileImages = Rxn<List<XFile>>();

  final _imagePicker = ImagePicker();

  final isVisiblePassword = false.obs;
  final isLoading = false.obs;
  final imageUploadCurrent = 1.obs;

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

  Future<void> pickMultipleImage() async {
    try {
      final files = await _imagePicker.pickMultiImage(imageQuality: 60);
      if (files.isNotEmpty && files.length >= 3) {
        if (files.isNotEmpty) {
          multipleImgC.text = files
              .map(
                (e) => e.name.replaceAll('scaled_', ''),
              )
              .join(', ');
          fileImages.value = files;
        }
      } else {
        showSnackBar(
          content: const Text('Pilih minimal 3 gambar'),
          duration: 3.seconds,
          backgroundColor: Get.theme.colorScheme.error,
        );
      }
    } catch (e) {
      logger.e('Error: $e');
    }
  }

  Future<List<String>> uploadImages() async {
    final imageUrls = await Future.wait(
      fileImages.value!.map((file) async {
        logger.d(
          'debug: area map fileImages dijalankan di current file ${file.name}',
        );

        final refStorage = _initC.storage
            .ref()
            .child('images/bukti_kendaraan/${generateRandomFileName()}.png');

        final uploadTask = refStorage.putData(
          await file.readAsBytes(),
          SettableMetadata(contentType: 'image/png'),
        );

        return await uploadTask.then((snapshot) {
          logger.d('debug: snapshot = ${snapshot.toString()}');
          return refStorage.getDownloadURL();
        }).catchError((e) {
          logger.e('Error: $e');
          return '';
        }).whenComplete(() {
          logger.d(
              'debug: fileImages ${imageUploadCurrent.value} sudah di upload');

          final currentIndexFile = fileImages.value!.indexOf(file);
          if (currentIndexFile == fileImages.value!.length) {
            imageUploadCurrent.value = 0;
          } else {
            imageUploadCurrent.value += 1;
          }
        });
      }),
    );

    return imageUrls;
  }

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
        Get.dialog(
          Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Loading....'),
                    Text(
                        'Sedang mengupload gambar ${imageUploadCurrent.value}/${fileImages.value?.length}...'),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        SizedBox(
                          width: Get.size.width * 0.5,
                          child: const LinearProgressIndicator(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          barrierDismissible: false,
        );

        final urlImages = await uploadImages();
        if (urlImages.isNotEmpty) {
          Get.back();

          final userCredential =
              await _initC.auth.createUserWithEmailAndPassword(
            email: email.value,
            password: passwordC.text,
          );

          if (userCredential.user != null) {
            await userCredential.user!.updateDisplayName(fullName.value);
            storeToDb(
              user: userCredential.user!,
              urlKendaraanImages: urlImages,
            );
          }
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

  Future<void> storeToDb({
    required User user,
    required List<String> urlKendaraanImages,
  }) async {
    final dataUser = UsersModel(
      uid: user.uid,
      email: user.email,
      fullName: fullName.value,
      rentalName: rentalName.value,
      numberPhone: numberPhone.value,
      address: address.value,
      role: SharedValues.ADMIN_RENTAL,
      urlKendaraanImages: urlKendaraanImages,
      createdAt: DateTime.now(),
    );

    try {
      await _initC.firestore
          .collection('users')
          .doc(user.uid)
          .set(dataUser.toFirestore());
      showDialogSuccess();
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

  void showDialogSuccess() {
    Get.dialog(
      const CustomDialog(
        title: 'Pendaftaran Berhasil',
        description:
            'Mantap.. akun kamu sudah terdaftar, silahkan hubungi admin untuk pengaktifkan akun',
        animation: ConstantsLottie.success,
      ),
      barrierDismissible: false,
    );

    Future.delayed(5.seconds, () => moveToLogin());
  
  }

  void moveToLogin() => Get.back();
}
