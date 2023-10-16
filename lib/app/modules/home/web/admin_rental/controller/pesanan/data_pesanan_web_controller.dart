import 'package:app_rental_mobil/app/db/models/pesanan_model.dart';
import 'package:app_rental_mobil/app/db/source/pesanan_data_source.dart';
import 'package:app_rental_mobil/app/helper/format_date_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../../../../init/controllers/init_controller.dart';

class DataPesananWebController extends GetxController {
  late InitController _initC;
  late PesananDataSource pesananDataSource;

  final formKey = GlobalKey<FormState>();
  final orderNameC = TextEditingController();
  final carNameC = TextEditingController();
  final dateStartC = TextEditingController();
  final timeStartC = TextEditingController();
  final dateEndC = TextEditingController();
  final timeEndC = TextEditingController();
  final priceC = TextEditingController();

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

  PesananDataSource setPesananDataSource(List<PesananModel> data) {
    pesananDataSource = PesananDataSource(pesanaan: data);
    return pesananDataSource;
  }

  void setDataTextController(PesananModel value) {
    orderNameC.text = value.userOrder?.order?.fullName ?? '';
    carNameC.text = value.kendaraanModel?.carName ?? '';
    dateStartC.text = value.tanggalMulai.toString();
    dateEndC.text = value.tanggalSelesai.toString();
    timeStartC.text = FormatDateTime.dateToString(
      newPattern: DateFormat.HOUR24_MINUTE,
      value: value.tanggalMulai.toString(),
    );
    timeEndC.text = FormatDateTime.dateToString(
      newPattern: DateFormat.HOUR24_MINUTE,
      value: value.tanggalSelesai.toString(),
    );
    priceC.text = value.harga.toString();
  }

  Stream<List<PesananModel>> streamPesanan() {
    final now = DateTime.now();
    final dateNow = DateTime(now.year, now.month, now.day);

    return _initC.firestore
        .collection('pesanan')
        .where('users.rental.uid', isEqualTo: _initC.auth.currentUser!.uid)
        .where('tanggal_mulai', isGreaterThanOrEqualTo: dateNow)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => PesananModel.fromFirestore(e.data()))
              .toList(),
        );
  }

  Stream<List<PesananModel>> streamRiwayatPesanan() {
    return _initC.firestore
        .collection('pesanan')
        .where('users.rental.uid', isEqualTo: _initC.auth.currentUser!.uid)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => PesananModel.fromFirestore(e.data()))
              .toList(),
        );
  }

  // Future<void> updatePesanan({
  //   required PesananModel newData,
  //   required int rowIndex,
  // }) async {
  //   try {
  //     await _initC.firestore
  //         .collection('pesanan')
  //         .doc(newData.uid)
  //         .update(newData.toFirestore());
  //     pesananDataSource.changeDataGridRow(
  //       rowIndex: rowIndex,
  //       newData: newData,
  //     );
  //     pesananDataSource.updateDataGridSource();

  //     Get.back();
  //     Get.dialog(
  //       const CustomDialog(
  //         title: 'Berhasil',
  //         description: 'Data berhasil diubah!',
  //         animation: ConstantsLottie.success,
  //       ),
  //     );
  //   } on FirebaseException catch (e) {
  //     logger.e('error: $e');

  //     showDialog(
  //       context: Get.context!,
  //       builder: (context) {
  //         return const CustomDialog(
  //           title: 'Gagal',
  //           description: 'Gagal mengedit pesanan',
  //           animation: ConstantsLottie.warning,
  //         );
  //       },
  //     );
  //   }
  // }

  // Future<void> deletePesanan({
  //   required String uid,
  //   required int rowIndex,
  // }) async {
  //   try {
  //     await _initC.firestore.collection('pesanan').doc(uid).delete();
  //     pesananDataSource.dataGridRows.removeAt(rowIndex);
  //     pesananDataSource.updateDataGridSource();

  //     Get.back();
  //     Get.dialog(
  //       const CustomDialog(
  //         title: 'Berhasil',
  //         description: 'Data berhasil dihapus!',
  //         animation: ConstantsLottie.success,
  //       ),
  //     );
  //   } on FirebaseException catch (e) {
  //     logger.e('error: $e');
  //   }
  // }

  
}
