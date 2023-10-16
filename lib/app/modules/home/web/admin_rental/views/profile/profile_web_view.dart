import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:app_rental_mobil/app/modules/home/web/admin_rental/controller/profile/profile_web_controller.dart';
import 'package:app_rental_mobil/app/widgets/buttons/custom_filled_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../helper/validation.dart';
import '../../../../../../utils/constants_lottie.dart';
import '../../../../../../widgets/card/cards.dart';
import '../../../../../auth/helper/validation_auth.dart';

class ProfileWebView extends GetView<ProfileWebController> {
  const ProfileWebView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final form = Form(
      key: controller.formKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: controller.fullNameC,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    hintText: 'Masukkan nama',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  validator: (value) => Validation.formField(
                    value: value,
                    titleField: 'Nama',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: controller.rentalNameC,
                  decoration: const InputDecoration(
                    labelText: 'Nama Rental',
                    hintText: 'Masukkan nama rental',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => Validation.formField(
                    value: value,
                    titleField: 'Nama rental',
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: controller.emailC,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan email',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationAuth.isEmailValid,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: controller.phoneC,
                  decoration: const InputDecoration(
                    labelText: 'Nomor HP',
                    hintText: 'Masukkan nomor HP',
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  maxLength: 13,
                  validator: ValidationAuth.isNumberPhoneValid,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: controller.addressC,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    hintText: 'Masukkan alamat',
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) => Validation.formField(
                    value: value,
                    titleField: 'Alamat',
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          )
        ],
      ),
    );

    Widget builderImage(UsersModel data) {
      return CachedNetworkImage(
        width: double.infinity,
        height: size.height * 0.5,
        imageUrl: '${data.urlImage}',
        fit: BoxFit.cover,
        errorWidget: (context, url, error) {
          return Image.asset('assets/img/placeholder_no_photo.png');
        },
      );
    }

    Widget builderButtonEdit() {
      return CustomFilledButton(
        onPressed: () {
          Get.defaultDialog(
            title: 'Edit Data',
            titleStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            contentPadding: const EdgeInsets.all(16.0),
            content: form,
            textConfirm: 'Simpan',
            textCancel: 'Batal',
            confirmTextColor: Colors.white,
            onConfirm: () async => await controller.updateUser(),
          );
        },
        isFilledTonal: false,
        child: const Text('Edit Data'),
      );
    }

    Widget builderButtonEditPicture() {
      return CustomFilledButton(
        onPressed: () {
          if (kIsWeb) {
            controller.pickImage();
          }
        },
        isFilledTonal: false,
        child: Obx(
          () => Text(
            (controller.urlImage.value != null) ? 'Edit Foto' : 'Pilih Foto',
          ),
        ),
      );
    }

    Widget builderLayoutProfile(UsersModel data) {
      if (size.width < 900) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: builderImage(data),
              ),
              const SizedBox(height: 21),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Nama Lengkap : ${data.fullName}',
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    AutoSizeText(
                      'Nomor HP : ${data.numberPhone}',
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    AutoSizeText(
                      'Email : ${data.email}',
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    AutoSizeText(
                      'Alamat : ${data.address}',
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 24),
                    builderButtonEdit(),
                    const SizedBox(height: 4),
                    builderButtonEditPicture(),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return SizedBox(
          // height: size.height * 0.5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    builderImage(data),
                    const SizedBox(height: 42),
                    Expanded(
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: builderButtonEditPicture(),)),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Nama Lengkap : ${data.fullName}',
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    AutoSizeText(
                      'Nomor HP : ${data.numberPhone}',
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    AutoSizeText(
                      'Email : ${data.email}',
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Alamat : ${data.address}',
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: builderButtonEdit(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }

    Widget builderContent(UsersModel data) {
      return Cards.elevated(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: builderLayoutProfile(data),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        child: StreamBuilder(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                  ConstantsLottie.loading,
                  width: size.width * 0.5,
                  height: size.height * 0.5,
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!;
              controller.setDataTextController(data);
              return builderContent(data);
            } else {
              return const Center(
                child: Text('Data Profile Kosong!'),
              );
            }
          },
        ),
      ),
    );
  }
}
