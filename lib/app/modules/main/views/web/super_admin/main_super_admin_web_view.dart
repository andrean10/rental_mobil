import 'package:app_rental_mobil/app/modules/main/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../home/web/super_admin/views/home/home_web_view.dart';
import '../../../../home/web/super_admin/views/penyewaan/data_penyewaan_web_view.dart';
import '../../../../home/web/super_admin/views/rental/data_rental_web_view.dart';
import '../../../../home/web/super_admin/views/user/data_user_web_view.dart';

class MainSuperAdminWebView extends GetView<MainController> {
  const MainSuperAdminWebView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    List<Widget> builderScreen() {
      return [
        const HomeWebView(),
        const DataUserWebView(),
        const DataRentalWebView(),
        const DataPenyewaanWebView(),
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
              onDestinationSelected: controller.changeIndexWebSuperAdmin,
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
                  label: 'Data User',
                ),
                builderNavigationRailDestination(
                  icon: Icons.car_rental_outlined,
                  selectedIcon: Icons.car_rental_rounded,
                  label: 'Data Rental',
                ),
                builderNavigationRailDestination(
                  icon: Icons.dataset_outlined,
                  selectedIcon: Icons.dataset_rounded,
                  label: 'Data Penyewaan',
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
