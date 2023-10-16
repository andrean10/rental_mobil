import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:app_rental_mobil/app/shared/shared_values.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../../../utils/constants_lottie.dart';
import '../../../../../../widgets/dialog/custom_dialog.dart';
import '../../../../../init/controllers/init_controller.dart';

class ProfileWebController extends GetxController {
  late final InitController _initC;

  final formKey = GlobalKey<FormState>();
  final fullNameC = TextEditingController();
  final rentalNameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final addressC = TextEditingController();
  final urlImage = RxnString();

  final fileImage = Rxn<XFile>();

  final progressUpload = 0.0.obs;

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

  Stream<UsersModel> streamUser() {
    return _initC.firestore
        .collection('users')
        .doc(_initC.auth.currentUser!.uid)
        .snapshots()
        .map(
          (event) => UsersModel.fromFirestore(event.data()!),
        );
  }

  void setDataTextController(UsersModel value) {
    fullNameC.text = value.fullName.toString();
    emailC.text = value.email.toString();
    rentalNameC.text = value.rentalName.toString();
    phoneC.text = value.numberPhone.toString();
    addressC.text = value.address.toString();
    urlImage.value = value.urlImage;
  }

  Future<void> updateUser() async {
    if (formKey.currentState!.validate()) {
      final newData = UsersModel(
        uid: _initC.auth.currentUser!.uid,
        email: emailC.text,
        fullName: fullNameC.text,
        rentalName: rentalNameC.text,
        numberPhone: phoneC.text,
        address: addressC.text,
        role: SharedValues.ADMIN_RENTAL,
        urlImage: urlImage.value,
      );

      try {
        await _initC.firestore
            .collection('users')
            .doc(_initC.auth.currentUser!.uid)
            .update(
              newData.toFirestore(),
            );

        Get.back();
        Get.dialog(
          const CustomDialog(
            title: 'Berhasil',
            description: 'Data berhasil diubah!',
            animation: ConstantsLottie.success,
          ),
        );
      } on FirebaseException catch (e) {
        logger.e('Error: $e');

        showDialog(
          context: Get.context!,
          builder: (context) {
            return const CustomDialog(
              title: 'Gagal',
              description: 'Gagal mengedit user',
              animation: ConstantsLottie.warning,
            );
          },
        );
      }
    }
  }

  Future<void> pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      fileImage.value = file;
      uploadImage();
    }
  }

  Future<void> uploadImage() async {
    if (fileImage.value != null) {
      try {
        final refStorage = _initC.storage
            .ref()
            .child('images/profile/${_initC.auth.currentUser?.uid}}.png');

        Get.dialog(
          Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Loading....'),
                  const Text('Sedang mengupload gambar...'),
                  Obx(
                    () => Column(
                      children: [
                        SizedBox(
                          width: Get.size.width * 0.5,
                          child: LinearProgressIndicator(
                              value: progressUpload.value / 100),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${progressUpload.value.toStringAsFixed(1)}%',
                          style: Theme.of(Get.context!).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );

        refStorage
            .putData(
              await fileImage.value!.readAsBytes(),
              SettableMetadata(contentType: 'image/png'),
            )
            .snapshotEvents
            .listen((event) async {
          switch (event.state) {
            case TaskState.running:
              progressUpload.value =
                  100.0 * (event.bytesTransferred / event.totalBytes);

              logger.i("debug: Upload is ${progressUpload.value}% complete.");
              break;
            case TaskState.paused:
              logger.d('debug: Upload is paused');
              break;
            case TaskState.canceled:
              logger.d("debug: Upload was canceled");
              break;
            case TaskState.error:
              logger.d("debug: Upload failed with error");
              break;
            case TaskState.success:
              logger.d("debug: Upload complete");

              final urlImage = await refStorage.getDownloadURL();
              await _initC.firestore
                  .collection('users')
                  .doc(_initC.auth.currentUser!.uid)
                  .update({'url_img': urlImage});
              break;
          }
        });
      } on FirebaseException catch (e) {
        logger.e('error: upload image = $e');
      }
    }
  }

  void closeDialog({
    required Duration duration,
  }) {
    Future.delayed(duration, () {
      Get.back();
    });
  }
}
