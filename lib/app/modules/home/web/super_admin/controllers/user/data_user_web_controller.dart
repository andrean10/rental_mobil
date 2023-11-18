import 'package:app_rental_mobil/app/modules/init/controllers/init_controller.dart';
import 'package:app_rental_mobil/app/utils/constants_lottie.dart';
import 'package:app_rental_mobil/app/widgets/dialog/custom_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../../../db/models/users_model.dart';
import '../../../../../../db/source/users_data_source.dart';
import '../../../../../../shared/shared_values.dart';

class DataUserWebController extends GetxController {
  late final InitController _initC;
  late UsersDataSource usersDataSource;

  final formKey = GlobalKey<FormState>();
  final fullNameC = TextEditingController();
  final rentalNameC = TextEditingController();
  final emailC = TextEditingController();
  final numberPhoneC = TextEditingController();
  final addressC = TextEditingController();

  final roleC = RxnString();
  var role = 0;

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

  UsersDataSource setUsersDataSource(List<UsersModel> data) {
    usersDataSource = UsersDataSource(users: data);
    return usersDataSource;
  }

  Stream<List<UsersModel>> streamUsers() {
    return _initC.firestore
        .collection('users')
        .where('role', isNotEqualTo: SharedValues.SUPER_ADMIN)
        .snapshots()
        .map(
      (event) {
        final usersModel =
            event.docs.map((e) => UsersModel.fromFirestore(e.data())).toList();
        usersModel.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
        return usersModel;
      },
    );
  }

  String generatePassword(String email) {
    String password = '${'@${email.split('@')[0].capitalize!}'}123';
    return password;
  }

  Future<void> addUser() async {
    if (formKey.currentState!.validate()) {
      final newData = UsersModel(
        email: emailC.text,
        fullName: fullNameC.text,
        rentalName: rentalNameC.text,
        numberPhone: numberPhoneC.text,
        address: addressC.text,
        role: role,
        createdAt: DateTime.now(),
      );

      try {
        final newUsers = await _initC.auth.createUserWithEmailAndPassword(
          email: newData.email!,
          password: generatePassword(newData.email!),
        );
        await _initC.firestore.collection('users').doc(newUsers.user!.uid).set(
              newData.copyWith(uid: newUsers.user!.uid).toFirestore(),
            );

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
  }

  Future<void> updateUser({
    required String uid,
    required int rowIndex,
  }) async {
    if (formKey.currentState!.validate()) {
      final newData = UsersModel(
        uid: uid,
        fullName: fullNameC.text,
        rentalName: rentalNameC.text,
        email: emailC.text,
        numberPhone: numberPhoneC.text,
        address: addressC.text,
        role: role,
        createdAt: DateTime.now(),
      );

      try {
        await _initC.firestore
            .collection('users')
            .doc(uid)
            .update(newData.toFirestore());

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
  }

  Future<void> updateIsActive({
    required String uid,
    required bool value,
  }) async {
    await _initC.firestore.collection('users').doc(uid).update({
      'is_active': value,
    });
  }

  Future<void> deleteUser({
    required String uid,
    required int rowIndex,
  }) async {
    try {
      await _initC.firestore.collection('users').doc(uid).delete();

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
    fullNameC.text = value.fullName.toString();
    rentalNameC.text = value.rentalName.toString();
    emailC.text = value.email.toString();
    numberPhoneC.text = value.numberPhone.toString();
    addressC.text = value.address.toString();
    roleC.value = (value.role == 2)
        ? SharedValues.ROLES[0]
        : (value.role == 3)
            ? SharedValues.ROLES[1]
            : null;

    if (roleC.value == SharedValues.ROLES[0]) {
      role = 2;
    } else if (roleC.value == SharedValues.ROLES[1]) {
      role = 3;
    }
  }

  void clearDataTextController() {
    fullNameC.clear();
    rentalNameC.clear();
    emailC.clear();
    numberPhoneC.clear();
    addressC.clear();
    roleC.value = null;
  }

  void changedRole(String? value) {
    if (value != null) {
      roleC.value = value;

      if (value == SharedValues.ROLES[0]) {
        role = 2;
      } else if (value == SharedValues.ROLES[1]) {
        role = 3;
      }
    }
  }
}
