import 'package:app_rental_mobil/app/db/models/kendaraan_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../helper/currency_format.dart';
import '../../../../shared/shared_method.dart';
import '../controllers/home_mobile_controller.dart';

class HomeMobileView extends GetView<HomeMobileController> {
  const HomeMobileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final theme = context.theme;

    PreferredSizeWidget builderAppBar() {
      return AppBar(
        automaticallyImplyLeading: false,
        notificationPredicate: (notification) => notification.depth == 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              'Selamat ${checkDayMessage()}',
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
            AutoSizeText(
              '${controller.user?.displayName}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
          ],
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CachedNetworkImage(
              imageUrl: controller.user?.photoURL ?? '',
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
              ),
              errorWidget: (context, url, error) => const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/img/placeholder_no_photo.png'),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      );
    }

    Widget builderImage(KendaraanModel item) {
      return Expanded(
        flex: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              CachedNetworkImage(
                height: double.infinity,
                imageUrl: '${item.urlImg}',
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Image.asset(
                  'assets/img/no_image.png',
                  fit: BoxFit.cover,
                ),
              ),
              Obx(
                () {
                  controller.pesanan.value;

                  if (controller.checkIsRented(item.uid!)) {
                    return Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.all(4),
                      child: Center(
                        child: Text(
                          'Disewa',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      );
    }

    Widget builderInfo(KendaraanModel item) {
      return Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              '${item.carName}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${item.deskripsi}',
              style: theme.textTheme.bodySmall,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Harga', style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                AutoSizeText(
                  '${CurrencyFormat.convertToIdr(number: item.harga)} / hari',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget builderContent(List<KendaraanModel> data) {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) {
          final item = data[index];

          return Obx(
            () {
              controller.pesanan.value;

              return GestureDetector(
                onTap: () {
                  if (!controller.checkIsRented(item.uid!)) {
                    controller.moveToCarDetails(item);
                  }
                },
                child: SizedBox(
                  height: size.height * 0.2,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      builderImage(item),
                      const SizedBox(width: 21),
                      builderInfo(item),
                    ],
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 32),
        itemCount: data.length,
      );
    }

    return Scaffold(
      appBar: builderAppBar(),
      body: StreamBuilder(
        stream: controller.streamKendaraan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  'Terjadi kesalahan coba lagi',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            final data = snapshot.data!;
            return builderContent(data);
          }

          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'Belum ada kendaraan yang tersedia',
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
