import 'package:app_rental_mobil/app/db/models/kendaraan_model.dart';
import 'package:app_rental_mobil/app/db/models/pesanan_model.dart';
import 'package:app_rental_mobil/app/helper/format_date_time.dart';
import 'package:app_rental_mobil/app/modules/init/controllers/init_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../../routes/app_pages.dart';

class HomeDetailController extends GetxController {
  late final InitController _initC;

  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final dateStartC = TextEditingController();
  final dateEndC = TextEditingController();
  final timeStartC = TextEditingController();
  final timeEnd = ''.obs;

  DateTime? dateStart;
  DateTime? dateEnd;
  TimeOfDay? timeStart;

  late final KendaraanModel data;

  Position? position;

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

    setData();
  }

  Future<Position> checkGPS() {
    return _initC.determinePosition();
  }

  void setData() {
    final kendaraan = Get.arguments as KendaraanModel;
    data = kendaraan;
  }

  void changeDateStart(DateTime date) {
    dateStart = date;
    dateStartC.text = FormatDateTime.dateToString(
      newPattern: 'dd MMMM yyyy',
      value: date.toString(),
    );
  }

  void changeDateEnd(DateTime date) {
    dateEnd = date;
    dateEndC.text = FormatDateTime.dateToString(
      newPattern: 'dd MMMM yyyy',
      value: date.toString(),
    );
  }

  void changeTimeStart(TimeOfDay time) {
    final formatedTime = FormatDateTime.timeToString(
      newPattern: DateFormat.HOUR24_MINUTE,
      value: time,
    );
    timeStart = time;
    timeStartC.text = formatedTime;
    timeEnd.value = formatedTime;
  }

  void clearDate() {
    dateStartC.clear();
    dateEndC.clear();
    timeStartC.clear();
    timeEnd.value = '';
  }

  String? validatorDate({
    required String? value,
    required String title,
  }) {
    if (value == null || value.isEmpty) {
      return '$title tidak boleh kosong';
    }

    return null;
  }

  Future<void> moveToCheckout() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      if (position != null) {
        final user = _initC.auth.currentUser;
        final formatedStartDateTime = dateStart!.copyWith(
          hour: timeStart!.hour,
          minute: timeStart!.minute,
        );
        final formatedEndDateTime = dateEnd!.copyWith(
          hour: timeStart!.hour,
          minute: timeStart!.minute,
        );
        final differenceDate =
            formatedEndDateTime.difference(formatedStartDateTime);
        final harga = (data.harga ?? 0) * differenceDate.inDays;

        final dataOrder = PesananModel(
          userOrder: UserOrder(
            order: User(
              uid: user?.uid,
              fullName: user?.displayName,
              location: GeoPoint(
                position!.latitude,
                position!.longitude,
              ),
            ),
            rental: User(uid: data.user?.uid, fullName: ''),
          ),
          kendaraanModel: data,
          tanggalMulai: formatedStartDateTime,
          tanggalSelesai: formatedEndDateTime,
          harga: harga,
        );

        isLoading.value = false;
        Get.back();
        Get.toNamed(
          Routes.CHECKOUT,
          arguments: dataOrder,
        );
      } else {
        isLoading.value = false;
        checkGPS().then((value) {
          Get.snackbar(
            'Perhatian',
            'Sedang mengambil data lokasi, tunggu sebentar...',
          );
          position = value;
        });
      }
    }
  }
}
