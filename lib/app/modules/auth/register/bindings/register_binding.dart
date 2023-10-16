import 'package:app_rental_mobil/app/modules/auth/register/mobile/controllers/register_mobile_controller.dart';
import 'package:app_rental_mobil/app/modules/auth/register/web/controllers/register_web_controller.dart';
import 'package:get/get.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterMobileController>(() => RegisterMobileController());
    Get.lazyPut<RegisterWebController>(() => RegisterWebController());
  }
}
