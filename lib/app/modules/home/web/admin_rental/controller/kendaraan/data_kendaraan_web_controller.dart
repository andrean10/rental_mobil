import 'package:app_rental_mobil/app/db/models/kendaraan_model.dart';
import 'package:app_rental_mobil/app/db/source/kendaraan_data_source.dart';
import 'package:app_rental_mobil/app/shared/shared_method.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../../../utils/constants_lottie.dart';
import '../../../../../../widgets/dialog/custom_dialog.dart';
import '../../../../../init/controllers/init_controller.dart';

class DataKendaraanWebController extends GetxController {
  late InitController _initC;
  late KendaraanDataSource kendaraanDataSource;

  final formKey = GlobalKey<FormState>();
  final carNameC = TextEditingController();
  final hargaC = TextEditingController();
  final deskripsiC = TextEditingController();

  final fileImage = Rxn<XFile>();
  final urlImage = RxnString();

  final isImageAvailable = true.obs;
  final progressUpload = 0.0.obs;

  final logger = Logger();

  @override
  void onInit() {
    super.onInit();
    initController();
  }

  void initController() {
    if (Get.isRegistered<InitController>()) {
      _initC = Get.find<InitController>();
    }
  }

  KendaraanDataSource setKendaraanDataSource(List<KendaraanModel> data) {
    kendaraanDataSource = KendaraanDataSource(kendaraan: data);
    return kendaraanDataSource;
  }

  Stream<List<KendaraanModel>> streamKendaraan() {
    return _initC.firestore
        .collection('kendaraan')
        .where('users.uid', isEqualTo: _initC.auth.currentUser!.uid)
        .orderBy('created_at')
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => KendaraanModel.fromFirestore(e.data()))
              .toList(),
        );
  }

  void checkImage() {
    if (fileImage.value != null || urlImage.value != null) {
      isImageAvailable.value = true;
    } else {
      isImageAvailable.value = false;
    }
  }

  Future<void> addKendaraan() async {
    if (formKey.currentState!.validate()) {
      checkImage();

      if (isImageAvailable.value) {
        uploadImage(isEdit: false);
      }
    } else {
      checkImage();
    }
  }

  Future<void> updateKendaraan(String uid) async {
    if (formKey.currentState!.validate()) {
      if (fileImage.value != null) {
        uploadImage(isEdit: true, uid: uid);
      } else {
        updateDataToDB(uid: uid);
      }
    }
  }

  Future<void> updateDataToDB({
    required String uid,
    String? urlImg,
  }) async {
    final newData = KendaraanModel(
      uid: uid,
      carName: carNameC.text,
      harga: int.tryParse(hargaC.text) ?? 0,
      deskripsi: deskripsiC.text,
      urlImg: urlImg ?? urlImage.value!,
      user: UserKendaraan(uid: _initC.auth.currentUser!.uid),
    );

    try {
      await _initC.firestore
          .collection('kendaraan')
          .doc(uid)
          .update(newData.toFirestore());

      // kendaraanDataSource.changeDataGridRow(
      //   rowIndex: rowIndex,
      //   newData: newData,
      // );
      // kendaraanDataSource.updateDataGridSource();

      Get.back();
      Get.dialog(
        const CustomDialog(
          title: 'Berhasil',
          description: 'Data berhasil diubah!',
          animation: ConstantsLottie.success,
        ),
      );
    } on FirebaseException catch (e) {
      logger.e('error: $e');

      showDialog(
        context: Get.context!,
        builder: (context) {
          return const CustomDialog(
            title: 'Gagal',
            description: 'Gagal mengedit kendaraan',
            animation: ConstantsLottie.warning,
          );
        },
      );
    }
  }

  Future<void> deleteKendaraan({
    required String uid,
    required int rowIndex,
  }) async {
    try {
      await _initC.firestore.collection('kendaraan').doc(uid).delete();
      // kendaraanDataSource.dataGridRows.removeAt(rowIndex);
      // kendaraanDataSource.updateDataGridSource();

      Get.back();
      Get.dialog(
        const CustomDialog(
          title: 'Berhasil',
          description: 'Data berhasil dihapus!',
          animation: ConstantsLottie.success,
        ),
      );
    } on FirebaseException catch (e) {
      logger.e('error: $e');
    }
  }

  void setDataTextController(KendaraanModel value) {
    carNameC.text = value.carName.toString();
    hargaC.text = value.harga.toString();
    deskripsiC.text = value.deskripsi.toString();
    urlImage.value = value.urlImg;
  }

  Future<void> uploadImage({
    required bool isEdit,
    String? uid,
  }) async {
    if (fileImage.value != null) {
      try {
        final refStorage = _initC.storage
            .ref()
            .child('images/kendaraan/${generateRandomFileName()}.png');

        Get.back();
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
              closeDialog(duration: 0.seconds);

              final urlImage = await refStorage.getDownloadURL();
              if (isEdit) {
                updateKendaraan(uid!);
              } else {
                storeDataToDB(urlImage);
              }
              break;
          }
        });
      } on FirebaseException catch (e) {
        logger.e('error: upload image = $e');
      }
    }
  }

  Future<void> storeDataToDB(String urlImage) async {
    final newData = KendaraanModel(
      carName: carNameC.text,
      harga: int.tryParse(hargaC.text) ?? 0,
      deskripsi: deskripsiC.text,
      urlImg: urlImage,
      user: UserKendaraan(uid: _initC.auth.currentUser!.uid),
    );

    try {
      final docRef = await _initC.firestore
          .collection('kendaraan')
          .add(newData.toFirestore());
      docRef.update({'uid': docRef.id});

      // kendaraanDataSource.addDataGridRow(newData);
      // kendaraanDataSource.updateDataGridSource();

      Get.back();
      Get.dialog(
        const CustomDialog(
          title: 'Berhasil',
          description: 'Data berhasil ditambahkan!',
          animation: ConstantsLottie.success,
        ),
      ).whenComplete(() => clearDataTextController());
    } on FirebaseException catch (e) {
      logger.e('error: $e');

      showDialog(
        context: Get.context!,
        builder: (context) {
          return const CustomDialog(
            title: 'Gagal',
            description: 'Gagal menambahkan user',
            animation: ConstantsLottie.warning,
          );
        },
      );
    }
  }

  void closeDialog({
    required Duration duration,
    String? namePageNavigation,
  }) {
    Future.delayed(duration, () {
      Get.back();

      if (namePageNavigation != null) {
        Get.offAllNamed(namePageNavigation);
      }
    });
  }

  void clearDataTextController() {
    carNameC.clear();
    hargaC.clear();
    deskripsiC.clear();
    fileImage.value = null;
    urlImage.value = null;
    isImageAvailable.value = true;
  }

  Future<void> pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) {
      fileImage.value = file;
      isImageAvailable.value = true;
    }
  }
}
