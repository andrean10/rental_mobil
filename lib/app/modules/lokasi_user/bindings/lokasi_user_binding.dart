import 'package:get/get.dart';

import '../controllers/lokasi_user_controller.dart';

class LokasiUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LokasiUserController>(
      () => LokasiUserController(),
    );
  }
}
