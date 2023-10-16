import 'package:app_rental_mobil/app/db/models/pesanan_model.dart';
import 'package:app_rental_mobil/app/modules/init/controllers/init_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/constants_lottie.dart';
import '../../../widgets/dialog/custom_dialog.dart';

class CheckoutController extends GetxController {
  late final InitController _initC;

  late final PesananModel data;

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

  void setData() {
    data = Get.arguments as PesananModel;
  }

  Future<void> checkout() async {
    try {
      final doc =
          await _initC.firestore.collection('pesanan').add(data.toFirestore());
      await doc.update({'uid': doc.id});

      Get.dialog(
        const CustomDialog(
          title: 'Berhasil',
          description: 'Data berhasil dihapus!',
          animation: ConstantsLottie.success,
        ),
      );
      Future.delayed(
        3.seconds,
        () => Get.offAllNamed(Routes.MAIN),
      );
    } on FirebaseException catch (e) {
      logger.e('error: $e');
    }
  }
}
