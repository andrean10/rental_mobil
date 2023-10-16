import 'package:get/get.dart';

import '../controllers/init_controller.dart';

class InitBinding implements Bindings {
  @override
  void dependencies() =>
      Get.put<InitController>(InitController(), permanent: true);
}
