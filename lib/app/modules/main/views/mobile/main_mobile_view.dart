import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../home/mobile/views/home_mobile_view.dart';
import '../../../home/mobile/views/riwayat/riwayat_transaksi_mobile_view.dart';
import '../../controllers/main_controller.dart';

class MainMobileView extends GetView<MainController> {
  const MainMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> builderScreen() {
      return [
        const HomeMobileView(),
        const RiwayatTransaksiMobileView(),
      ];
    }

    List<Widget> builderDestination() {
      return [
        const NavigationDestination(
          icon: Icon(Icons.car_rental_rounded),
          label: 'Rental Mobil',
        ),
        const NavigationDestination(
          icon: Icon(Icons.history_rounded),
          label: 'Riwayat Pinjaman',
        ),
        // logout
        const NavigationDestination(
          icon: Icon(Icons.exit_to_app_rounded),
          label: 'Logout',
        ),
      ];
    }

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: builderScreen(),
        ),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changeIndexMobile,
          destinations: builderDestination(),
        ),
      ),
    );
  }
}
