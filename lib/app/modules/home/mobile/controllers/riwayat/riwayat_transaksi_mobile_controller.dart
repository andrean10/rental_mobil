import 'package:app_rental_mobil/app/modules/init/controllers/init_controller.dart';
import 'package:get/get.dart';

import '../../../../../db/models/pesanan_model.dart';

class RiwayatTransaksiMobileController extends GetxController {
  late final InitController _initC;

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

  Stream<List<PesananModel>> streamRiwayatTransaksi() {
    return _initC.firestore
        .collection('pesanan')
        .where('users.order.uid', isEqualTo: _initC.auth.currentUser!.uid)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => PesananModel.fromFirestore(e.data()))
              .toList(),
        );
  }
}
