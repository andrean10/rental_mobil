// import 'package:app_rental_mobil/app/db/models/pesanan_model.dart';
// import 'package:app_rental_mobil/app/helper/validation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../admin_rental/controller/pesanan/data_pesanan_web_controller.dart';

// class BuilderActionsTablePesanan extends GetView<DataPesananWebController> {
//   final PesananModel value;
//   final int rowIndex;

//   const BuilderActionsTablePesanan({
//     required this.value,
//     required this.rowIndex,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           onPressed: () {
//             controller.setDataTextController(value);

//             Get.defaultDialog(
//               title: 'Edit Data',
//               titleStyle: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//               contentPadding: const EdgeInsets.all(16.0),
//               content: Form(
//                 key: controller.formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       controller: controller.orderNameC,
//                       decoration: const InputDecoration(
//                         labelText: 'Nama Pemesanan',
//                         hintText: 'Masukkan nama pemesanan',
//                       ),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.name,
//                       enabled: false,
//                       readOnly: true,
//                       validator: (value) => Validation.formField(
//                         value: value,
//                         titleField: 'Nama pemesanan',
//                       ),
//                     ),
//                     TextFormField(
//                       controller: controller.carNameC,
//                       decoration: const InputDecoration(
//                         labelText: 'Nama Kendaraan',
//                         hintText: 'Masukkan nama kendaraan',
//                       ),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.name,
//                       enabled: false,
//                       readOnly: true,
//                       validator: (value) => Validation.formField(
//                         value: value,
//                         titleField: 'Nama kendaraan',
//                       ),
//                     ),
//                     TextFormField(
//                       controller: controller.dateStartC,
//                       decoration: const InputDecoration(
//                         labelText: 'Tanggal Mulai',
//                         hintText: 'Masukkan tanggal',
//                       ),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.datetime,
//                       validator: (value) => Validation.formField(
//                         value: value,
//                         titleField: 'Tanggal mulai',
//                       ),
//                     ),
//                     TextFormField(
//                       controller: controller.dateStartC,
//                       decoration: const InputDecoration(
//                         labelText: 'Jam Mulai',
//                         hintText: 'Masukkan jam',
//                       ),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.datetime,
//                       validator: (value) => Validation.formField(
//                         value: value,
//                         titleField: 'Jam mulai',
//                       ),
//                     ),
//                     TextFormField(
//                       controller: controller.dateEndC,
//                       decoration: const InputDecoration(
//                         labelText: 'Tanggal Selesai',
//                         hintText: 'Masukkan tanggal selesai',
//                       ),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.datetime,
//                       validator: (value) => Validation.formField(
//                         value: value,
//                         titleField: 'Tanggal selesai',
//                       ),
//                     ),
//                     TextFormField(
//                       controller: controller.dateStartC,
//                       decoration: const InputDecoration(
//                         labelText: 'Jam Selesai',
//                         hintText: 'Masukkan jam',
//                       ),
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.datetime,
//                       validator: (value) => Validation.formField(
//                         value: value,
//                         titleField: 'Jam selesai',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               textConfirm: 'Simpan',
//               textCancel: 'Batal',
//               confirmTextColor: Colors.white,
//               onConfirm: () {
//                 final newData = PesananModel(
//                   uid: value.uid,
//                   userOrder: value.userOrder,
//                   kendaraanModel: value.kendaraanModel,
//                   tanggalMulai: DateTime.tryParse(controller.dateStartC.text) ??
//                       DateTime.now(),
//                   tanggalSelesai: DateTime.tryParse(controller.dateEndC.text) ??
//                       DateTime.now(),
//                   harga: int.tryParse(controller.priceC.text) ?? 0,
//                 );

//                 controller.updatePesanan(
//                   rowIndex: rowIndex,
//                   newData: newData,
//                 );
//               },
//             );
//           },
//           icon: Icon(
//             Icons.edit_rounded,
//             color: theme.colorScheme.primary,
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             Get.defaultDialog(
//               title: 'Konfirmasi',
//               middleText: 'Apakah anda yakin ingin menghapus data ini?',
//               textConfirm: 'Ya',
//               textCancel: 'Tidak',
//               confirmTextColor: Colors.white,
//               onConfirm: () => controller.deletePesanan(
//                 uid: value.uid ?? '',
//                 rowIndex: rowIndex,
//               ),
//             );
//           },
//           icon: Icon(
//             Icons.delete_rounded,
//             color: theme.colorScheme.error,
//           ),
//         ),
//       ],
//     );
//   }
// }
