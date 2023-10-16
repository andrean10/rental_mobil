import 'package:app_rental_mobil/app/modules/home_detail/widgets/builder_detail_content.dart';
import 'package:app_rental_mobil/app/modules/home_detail/widgets/builder_detail_order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_detail_controller.dart';
import '../widgets/builder_detail_image.dart';

class HomeDetailView extends GetView<HomeDetailController> {
  const HomeDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    PreferredSizeWidget builderAppBar() {
      return AppBar(
        title: const Text('Detail Mobil'),
      );
    }

    return Scaffold(
      appBar: builderAppBar(),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            BuilderDetailImage(),
            SizedBox(height: 21),
            BuilderDetailContent(),
          ],
        ),
      ),
      bottomNavigationBar: const BuilderDetailOrder(),
    );
  }
}
