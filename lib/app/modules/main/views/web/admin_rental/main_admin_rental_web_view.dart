import 'package:app_rental_mobil/app/modules/home/web/admin_rental/views/home/home_admin_rental_web_view.dart';
import 'package:app_rental_mobil/app/modules/home/web/admin_rental/views/pesanan/data_pesanan_web_view.dart';
import 'package:app_rental_mobil/app/modules/home/web/admin_rental/views/profile/profile_web_view.dart';
import 'package:app_rental_mobil/app/modules/main/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../home/web/admin_rental/views/kendaraan/data_kendaraan_web_view.dart';
import '../../../../home/web/admin_rental/views/riwayat_pesanan/riwayat_pesanan_web_view.dart';

class MainRentalAdminWebView extends GetView<MainController> {
  const MainRentalAdminWebView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    List<Widget> builderScreen() {
      return [
        const HomeAdminRentalWebView(),
        const ProfileWebView(),
        const DataKendaraanWebView(),
        const DataPesananWebView(),
        const RiwayatPesananWebView(),
      ];
    }

    NavigationRailDestination builderNavigationRailDestination({
      required IconData icon,
      required IconData selectedIcon,
      required String label,
    }) {
      return NavigationRailDestination(
        icon: Icon(icon),
        selectedIcon: Icon(selectedIcon),
        label: Text(label),
        padding: const EdgeInsets.all(8),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          Obx(
            () => NavigationRail(
              extended: (size.width >= 1200) ? true : false,
              backgroundColor: theme.colorScheme.primaryContainer,
              elevation: 12,
              selectedIndex: controller.currentIndex.value,
              onDestinationSelected: controller.changeIndexRentalAdmin,
              labelType: NavigationRailLabelType.none,
              destinations: [
                builderNavigationRailDestination(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'Home',
                ),
                builderNavigationRailDestination(
                  icon: Icons.person,
                  selectedIcon: Icons.person,
                  label: 'Data Profile',
                ),
                builderNavigationRailDestination(
                  icon: Icons.directions_car_filled_outlined,
                  selectedIcon: Icons.directions_car_filled_rounded,
                  label: 'Data Kendaraan',
                ),
                builderNavigationRailDestination(
                  icon: Icons.dataset_outlined,
                  selectedIcon: Icons.dataset_rounded,
                  label: 'Data Pesanan',
                ),
                builderNavigationRailDestination(
                  icon: Icons.history_rounded,
                  selectedIcon: Icons.history_rounded,
                  label: 'Riwayat Pesanan',
                ),
                builderNavigationRailDestination(
                  icon: Icons.exit_to_app_outlined,
                  selectedIcon: Icons.exit_to_app_rounded,
                  label: 'Logout',
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: controller.currentIndex.value,
                children: builderScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
