import 'package:app_rental_mobil/app/modules/home/web/widgets/builder_data_table_web.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/rental/data_rental_web_controller.dart';

class DataRentalWebView extends GetView<DataRentalWebController> {
  const DataRentalWebView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerColumn = [
      GridColumn(
        columnName: 'no',
        columnWidthMode: ColumnWidthMode.fitByColumnName,
        allowFiltering: false,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'No',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'rental_name',
        width: 180,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nama Rental',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'full_name',
        width: 180,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nama Pemilik',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'numberPhone',
        width: 180,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nomor HP',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'address',
        columnWidthMode: ColumnWidthMode.fill,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Alamat',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'actions',
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
        title: const Text('Data Rental'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: StreamBuilder(
          stream: controller.streamRental(),
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
                source: controller.setRentalDataSource(data),
                headerColumn: headerColumn,
                rowHeight: 60,
              );
            } 

            return const Center(
              child: Text('Data rental masih kosong!'),
            );
          },
        ),
      ),
    );
  }
}
