import 'package:app_rental_mobil/app/db/models/kendaraan_model.dart';
import 'package:app_rental_mobil/app/helper/currency_format.dart';
import 'package:app_rental_mobil/app/modules/home/web/widgets/actions/builder_actions_table_kendaraan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class KendaraanDataSource extends DataGridSource {
  final List<KendaraanModel> kendaraan;
  List<DataGridRow> dataGridRows = [];

  KendaraanDataSource({required this.kendaraan}) {
    buildDataGridRows();
  }

  DataGridRow builderDataGridRow({
    required int index,
    required KendaraanModel kendaraan,
  }) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'no', value: index++),
        DataGridCell<String>(columnName: 'car_name', value: kendaraan.carName),
        DataGridCell<num>(columnName: 'harga', value: kendaraan.harga),
        DataGridCell<String>(
            columnName: 'deskripsi', value: kendaraan.deskripsi),
        DataGridCell<String>(columnName: 'images', value: kendaraan.urlImg),
        DataGridCell<KendaraanModel>(columnName: 'actions', value: kendaraan),
      ],
    );
  }

  void buildDataGridRows() {
    var index = 1;

    dataGridRows = kendaraan
        .map<DataGridRow>(
          (dataGridRow) => builderDataGridRow(
            index: index++,
            kendaraan: dataGridRow,
          ),
        )
        .toList();
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((dataGridCell) {
      final index = dataGridRows.indexOf(row);

      return Container(
        alignment: (dataGridCell.columnName == 'id' ||
                dataGridCell.columnName == 'harga' ||
                dataGridCell.columnName == 'actions')
            ? Alignment.topCenter
            : Alignment.topLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: (dataGridCell.columnName == 'actions')
            ? BuilderActionsTableKendaraan(
                value: dataGridCell.value as KendaraanModel,
                rowIndex: index,
              )
            : (dataGridCell.columnName == 'images')
                ? CachedNetworkImage(
                    width: 100,
                    height: 100,
                    imageUrl: dataGridCell.value.toString(),
                    errorWidget: (context, url, error) {
                      return Image.asset('assets/img/no_image.png');
                    },
                    errorListener: (value) {
                      Logger().e('error: image error listener = $value');
                    },
                  )
                : Text(
                    (dataGridCell.columnName == 'harga')
                        ? CurrencyFormat.convertToIdr(
                            number: dataGridCell.value ?? 0)
                        : dataGridCell.value.toString(),
                    overflow: TextOverflow.clip,
                    softWrap: true,
                  ),
      );
    }).toList());
  }

  // void updateDataGridSource() {
  //   notifyListeners();
  // }

  // void changeDataGridRow({
  //   required int rowIndex,
  //   required KendaraanModel newData,
  // }) {
  //   dataGridRows[rowIndex] = DataGridRow(
  //     cells: [
  //       DataGridCell<int>(columnName: 'no', value: rowIndex + 1),
  //       DataGridCell<String>(columnName: 'car_name', value: newData.carName),
  //       DataGridCell<num>(columnName: 'harga', value: newData.harga),
  //       DataGridCell<String>(columnName: 'deskripsi', value: newData.deskripsi),
  //       DataGridCell<String>(columnName: 'deskripsi', value: newData.urlImg),
  //       DataGridCell<KendaraanModel>(columnName: 'actions', value: newData),
  //     ],
  //   );
  // }

  // void addDataGridRow(KendaraanModel newData) {
  //   dataGridRows.add(
  //     builderDataGridRow(index: dataGridRows.length + 1, kendaraan: newData),
  //   );
  // }
}
