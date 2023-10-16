import 'package:app_rental_mobil/app/db/models/kendaraan_model.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';
import '../../../init/controllers/init_controller.dart';

class HomeMobileController extends GetxController {
  late final InitController _initC;

  get user => _initC.auth.currentUser;

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

  Stream<List<KendaraanModel>> streamKendaraan() {
    return _initC.firestore.collection('kendaraan').snapshots().map(
          (value) => value.docs
              .map((e) => KendaraanModel.fromFirestore(e.data()))
              .toList(),
        );
  }

  void logOut() {
    _initC.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  void moveToCarDetails(KendaraanModel item) => Get.toNamed(
        Routes.HOME_DETAIL,
        arguments: item,
      );
}
