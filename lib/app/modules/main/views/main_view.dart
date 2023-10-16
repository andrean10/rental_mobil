import 'package:app_rental_mobil/app/modules/main/views/web/admin_rental/main_admin_rental_web_view.dart';
import 'package:app_rental_mobil/app/modules/main/views/web/super_admin/main_super_admin_web_view.dart';
import 'package:app_rental_mobil/app/shared/shared_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/main_controller.dart';
import 'mobile/main_mobile_view.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget builderScaffold(Widget body) {
      return Scaffold(
        body: Center(child: body),
      );
    }

    return FutureBuilder(
      future: controller.checkRoleUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return builderScaffold(
            const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError && snapshot.error != null) {
          Future.delayed(
            const Duration(seconds: 3),
            () => Get.offAllNamed(Routes.LOGIN),
          );
          return builderScaffold(const Text('Ada kesalahan!'));
        } else if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data;

          return (GetPlatform.isWeb)
              ? (data!.role == SharedValues.ADMIN_RENTAL)
                  ? const MainRentalAdminWebView()
                  : const MainSuperAdminWebView()
              : const MainMobileView();
        }

        return builderScaffold(
          const Text('Role user tidak ditemukan'),
        );
      },
    );
  }
}
