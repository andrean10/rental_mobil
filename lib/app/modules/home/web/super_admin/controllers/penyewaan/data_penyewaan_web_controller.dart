import 'package:app_rental_mobil/app/db/models/pesanan_model.dart';
import 'package:app_rental_mobil/app/db/source/penyewaan_data_source.dart';
import 'package:app_rental_mobil/app/helper/format_date_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../../../../init/controllers/init_controller.dart';

class DataPenyewaanWebController extends GetxController {
  late InitController _initC;
  late PenyewaanDataSource penyewaanDataSource;

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

  PenyewaanDataSource setPenyewaanDataSource(List<PesananModel> data) {
    penyewaanDataSource = PenyewaanDataSource(pesanaan: data);
    return penyewaanDataSource;
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

  Stream<List<PesananModel>> streamPenyewaan() {
    return _initC.firestore.collection('pesanan').snapshots().map(
          (event) => event.docs
              .map((e) => PesananModel.fromFirestore(e.data()))
              .toList(),
        );
  }
}
