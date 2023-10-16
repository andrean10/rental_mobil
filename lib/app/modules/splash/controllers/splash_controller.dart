import 'package:app_rental_mobil/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../init/controllers/init_controller.dart';

class SplashController extends GetxController {
  late final InitController _initC;

  final logger = Logger();

  @override
  void onInit() {
    super.onInit();

    if (Get.isRegistered<InitController>()) {
      _initC = Get.find<InitController>();
    }
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(4.seconds, () => checkAuth());
  }

  void checkAuth() {
    if (_initC.isUserLogged()) {
      Get.offAllNamed(Routes.MAIN);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
