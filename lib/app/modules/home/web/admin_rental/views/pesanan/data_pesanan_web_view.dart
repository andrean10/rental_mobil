import 'package:app_rental_mobil/app/modules/home/web/admin_rental/controller/pesanan/data_pesanan_web_controller.dart';
import 'package:app_rental_mobil/app/modules/home/web/widgets/builder_data_table_web.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DataPesananWebView extends GetView<DataPesananWebController> {
  const DataPesananWebView({Key? key}) : super(key: key);

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
        columnName: 'order_name',
        width: 200,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Nama Pemesan',
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
        columnName: 'date_start',
        width: 200,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Tanggal Mulai',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'time_start',
        width: 170,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Jam Pakai',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'date_end',
        width: 200,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Tanggal Selesai',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'time_end',
        width: 170,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Jam Selesai',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'price',
        width: 130,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.centerLeft,
          child: const Text(
            'Harga',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'keluhan',
        width: 300,
        allowFiltering: false,
        allowSorting: false,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          alignment: Alignment.center,
          child: const Text(
            'Keluhan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.clip,
            softWrap: true,
          ),
        ),
      ),
      GridColumn(
        columnName: 'location',
        columnWidthMode: ColumnWidthMode.auto,
        allowFiltering: false,
        allowSorting: false,
        label: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          alignment: Alignment.center,
          child: const Text(
            'Lokasi Pemesan',
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      // GridColumn(
      //   columnName: 'actions',
      //   allowSorting: false,
      //   allowFiltering: false,
      //   label: Container(
      //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //     alignment: Alignment.center,
      //     child: const Text(
      //       'Aksi',
      //       style: TextStyle(fontWeight: FontWeight.bold),
      //       overflow: TextOverflow.ellipsis,
      //     ),
      //   ),
      // ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pesanan Hari Ini'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: StreamBuilder(
          stream: controller.streamPesanan(),
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
                source: controller.setPesananDataSource(data),
                headerColumn: headerColumn,
                rowHeight: double.nan,
              );
            }

            return const Center(
              child: Text('Belum ada data pesanan!'),
            );
          },
        ),
      ),
    );
  }
}
