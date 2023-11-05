import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../super_admin/controllers/user/data_user_web_controller.dart';

class BuilderIsActiveTableUser extends GetView<DataUserWebController> {
  final UsersModel users;
  final int rowIndex;

  const BuilderIsActiveTableUser({
    required this.users,
    required this.rowIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: users.isActive ?? false,
      onChanged: (value) => controller.updateIsActive(
        uid: users.uid!,
        value: value,
      ),
    );
  }
}
