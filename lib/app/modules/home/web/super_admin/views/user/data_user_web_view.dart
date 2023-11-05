import 'package:app_rental_mobil/app/modules/home/web/super_admin/form/form_user_web.dart';
import 'package:app_rental_mobil/app/modules/home/web/widgets/builder_data_table_web.dart';
import 'package:app_rental_mobil/app/modules/home/web/widgets/actions/builder_actions_table_add.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../controllers/user/data_user_web_controller.dart';

class DataUserWebView extends GetView<DataUserWebController> {
  const DataUserWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        columnName: 'name',
        width: 150,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nama',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'role',
        width: 130,
        allowFiltering: false,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.center,
          child: const Text(
            'Role',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'email',
        columnWidthMode: ColumnWidthMode.auto,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Email',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'numberPhone',
        width: 150,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.center,
          child: const Text(
            'Nomor HP',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'address',
        width: 200,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.center,
          child: const Text(
            'Alamat',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'isActive',
        width: 150,
        allowFiltering: false,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.center,
          child: const Text(
            'Apakah aktif ?',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'actions',
        width: 150,
        allowSorting: false,
        allowFiltering: false,
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
        title: const Text('Data User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: StreamBuilder(
          stream: controller.streamUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
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
                source: controller.setUsersDataSource(data),
                headerColumn: headerColumn,
                rowHeight: 60,
              );
            }

            return const Center(
              child: Text('Belum ada data user!'),
            );
          },
        ),
      ),
      floatingActionButton: BuilderActionsTableAdd(
        form: formUserWeb(controller),
        onConfirm: () async {
          await controller.addUser();
        },
        clearForm: controller.clearDataTextController,
      ),
    );
  }
}
