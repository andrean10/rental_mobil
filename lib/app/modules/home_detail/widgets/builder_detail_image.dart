import 'package:app_rental_mobil/app/modules/home_detail/controllers/home_detail_controller.dart';
import 'package:app_rental_mobil/app/widgets/card/cards.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuilderDetailImage extends GetView<HomeDetailController> {
  const BuilderDetailImage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Cards.elevated(
      child: CachedNetworkImage(
        imageUrl: '${controller.data.urlImg}',
        imageBuilder: (context, imageProvider) {
          return Container(
            height: size.height * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Image.asset(
            'assets/img/no_image.png',
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
