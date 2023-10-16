import 'package:app_rental_mobil/app/modules/home/web/admin_rental/form/form_kendaraan_web.dart';
import 'package:app_rental_mobil/app/modules/home/web/widgets/builder_data_table_web.dart';
import 'package:app_rental_mobil/app/modules/home/web/widgets/actions/builder_actions_table_add.dart';
import 'package:app_rental_mobil/app/utils/constants_lottie.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controller/kendaraan/data_kendaraan_web_controller.dart';

class DataKendaraanWebView extends GetView<DataKendaraanWebController> {
  const DataKendaraanWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final headerColumn = [
      GridColumn(
        columnName: 'no',
        columnWidthMode: ColumnWidthMode.fitByColumnName,
        allowFiltering: false,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.center,
          child: const Text(
            'No',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'car_name',
        width: 200,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nama Kendaraan',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'harga',
        width: 130,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Harga',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
          ),
        ),
      ),
      GridColumn(
        columnName: 'deskripsi',
        width: 300,
        allowFiltering: false,
        allowSorting: false,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Deskripsi',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'images',
        width: 150,
        allowFiltering: false,
        allowSorting: false,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.center,
          child: const Text(
            'Gambar',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'actions',
        width: 150,
        allowSorting: false,
        allowFiltering: false,
        // columnWidthMode: ColumnWidthMode.lastColumnFill,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.center,
          child: const Text(
            'Aksi',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kendaraan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: StreamBuilder(
          stream: controller.streamKendaraan(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LottieBuilder.asset(
                  ConstantsLottie.loading,
                  width: size.width * 0.5,
                  height: size.height * 0.5,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.isNotEmpty) {
              final data = snapshot.data!;
              return BuilderDataTable(
                source: controller.setKendaraanDataSource(data),
                headerColumn: headerColumn,
              );
            }

            return const Center(
              child: Text(
                  'Data kendaraan belum ada, silahkan tambahkan data kendaraan anda!'),
            );
          },
        ),
      ),
      floatingActionButton: BuilderActionsTableAdd(
        form: formKendaraanWeb(controller),
        onConfirm: () async {
          await controller.addKendaraan();
        },
        clearForm: controller.clearDataTextController,
      ),
    );
  }
}
