import 'package:app_rental_mobil/app/modules/home/mobile/controllers/home_mobile_controller.dart';
import 'package:app_rental_mobil/app/modules/home/mobile/controllers/riwayat/riwayat_transaksi_mobile_controller.dart';
import 'package:app_rental_mobil/app/modules/home/web/admin_rental/controller/kendaraan/data_kendaraan_web_controller.dart';
import 'package:app_rental_mobil/app/modules/home/web/admin_rental/controller/pesanan/data_pesanan_web_controller.dart';
import 'package:app_rental_mobil/app/modules/home/web/admin_rental/controller/profile/profile_web_controller.dart';
import 'package:get/get.dart';

import '../../home/web/super_admin/controllers/penyewaan/data_penyewaan_web_controller.dart';
import '../../home/web/super_admin/controllers/rental/data_rental_web_controller.dart';
import '../../home/web/super_admin/controllers/user/data_user_web_controller.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<HomeMobileController>(() => HomeMobileController());

    // SUPER ADMIN
    Get.lazyPut<DataUserWebController>(() => DataUserWebController());
    Get.lazyPut<DataRentalWebController>(() => DataRentalWebController());
    Get.lazyPut<DataPenyewaanWebController>(() => DataPenyewaanWebController());

    // ADMIN RENTAL
    Get.lazyPut<DataKendaraanWebController>(() => DataKendaraanWebController());
    Get.lazyPut<DataPesananWebController>(() => DataPesananWebController());
    Get.lazyPut<ProfileWebController>(() => ProfileWebController());

    // USERS
    Get.lazyPut<RiwayatTransaksiMobileController>(
        () => RiwayatTransaksiMobileController());
  }
}
