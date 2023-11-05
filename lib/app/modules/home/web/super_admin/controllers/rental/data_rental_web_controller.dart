import 'package:app_rental_mobil/app/db/source/rental_data_source.dart';
import 'package:app_rental_mobil/app/shared/shared_values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../../../db/models/users_model.dart';
import '../../../../../../utils/constants_lottie.dart';
import '../../../../../../widgets/dialog/custom_dialog.dart';
import '../../../../../init/controllers/init_controller.dart';

class DataRentalWebController extends GetxController {
  late InitController _initC;
  late RentalDataSource rentalDataSource;

  final formKey = GlobalKey<FormState>();
  final rentalNameC = TextEditingController();
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final numberPhoneC = TextEditingController();
  final addressC = TextEditingController();

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

  RentalDataSource setRentalDataSource(List<UsersModel> data) {
    rentalDataSource = RentalDataSource(users: data);
    return rentalDataSource;
  }

  Stream<List<UsersModel>> streamRental() {
    return _initC.firestore
        .collection('users')
        .where('role', isEqualTo: SharedValues.ADMIN_RENTAL)
        .snapshots()
        .map(
          (value) => value.docs
              .map((e) => UsersModel.fromFirestore(e.data()))
              .toList(),
        );
  }

  Future<void> updateUser({
    required UsersModel newData,
    required int rowIndex,
  }) async {
    try {
      await _initC.firestore
          .collection('users')
          .doc(newData.uid)
          .update(newData.toFirestore());
      rentalDataSource.changeDataGridRow(
        rowIndex: rowIndex,
        newData: newData,
      );
      rentalDataSource.updateDataGridSource();

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
            description: 'Gagal mengedit user',
            animation: ConstantsLottie.warning,
          );
        },
      );
    }
  }

  Future<void> deleteUser({
    required String uid,
    required int rowIndex,
  }) async {
    try {
      await _initC.firestore.collection('users').doc(uid).delete();
      rentalDataSource.dataGridRows.removeAt(rowIndex);
      rentalDataSource.updateDataGridSource();

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

  void setDataTextController(UsersModel value) {
    rentalNameC.text = value.rentalName.toString();
    fullNameC.text = value.fullName.toString();
    emailC.text = value.email.toString();
    numberPhoneC.text = value.numberPhone.toString();
    addressC.text = value.address.toString();
  }
}
