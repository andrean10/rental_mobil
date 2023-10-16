import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuilderActionsTableAdd extends StatelessWidget {
  final Form form;
  final Function() onConfirm;
  final Function() clearForm;

  const BuilderActionsTableAdd({
    required this.form,
    required this.onConfirm,
    required this.clearForm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.defaultDialog(
          title: 'Tambah Data',
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          contentPadding: const EdgeInsets.all(32.0),
          content: form,
          textConfirm: 'Simpan',
          textCancel: 'Batal',
          confirmTextColor: Colors.white,
          onConfirm: onConfirm,
          onCancel: clearForm,
          onWillPop: () async {
            clearForm();
            return true;
          },
        );
      },
      tooltip: 'Tambah data',
      child: const Icon(Icons.add_rounded),
    );
  }
}
