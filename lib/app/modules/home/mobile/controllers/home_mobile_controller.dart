import 'package:app_rental_mobil/app/db/models/kendaraan_model.dart';
import 'package:app_rental_mobil/app/db/models/pesanan_model.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../../routes/app_pages.dart';
import '../../../init/controllers/init_controller.dart';

class HomeMobileController extends GetxController {
  late final InitController _initC;
  final pesanan = Rxn<List<PesananModel>>();

  get user => _initC.auth.currentUser;

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
  }

  Stream<List<KendaraanModel>> streamKendaraan() {
    streamPesanan();
    return _initC.firestore.collection('kendaraan').snapshots().map(
          (value) => value.docs
              .map((e) => KendaraanModel.fromFirestore(e.data()))
              .toList(),
        );
  }

  void streamPesanan() {
    _initC.firestore
        .collection('pesanan')
        .snapshots()
        .map(
          (value) => value.docs
              .map((e) => PesananModel.fromFirestore(e.data()))
              .toList(),
        )
        .listen((event) {
      pesanan.value = event;
    });
  }

  bool checkIsRented(String kendaraanUid) {
    final now = DateTime.now();

    final isRented = pesanan.value?.any((element) {
      final uid = element.kendaraanModel!.uid;

      if (uid != kendaraanUid) {
        return false;
      }

      final dateEnd = element.tanggalSelesai!;
      return dateEnd.isAfter(now);
    });

    logger.d('debug: isRented = $isRented, with uid = $kendaraanUid');

    return isRented ?? false;
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
