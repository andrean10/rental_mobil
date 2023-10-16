import 'package:app_rental_mobil/app/db/models/pesanan_model.dart';
import 'package:app_rental_mobil/app/helper/currency_format.dart';
import 'package:app_rental_mobil/app/helper/format_date_time.dart';
import 'package:app_rental_mobil/app/shared/shared_method.dart';
import 'package:app_rental_mobil/app/widgets/buttons/custom_filled_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PesananDataSource extends DataGridSource {
  final List<PesananModel> pesanaan;
  List<DataGridRow> dataGridRows = [];

  PesananDataSource({required this.pesanaan}) {
    buildDataGridRows();
  }

  void buildDataGridRows() {
    var index = 1;

    dataGridRows = pesanaan
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<int>(columnName: 'no', value: index++),
              DataGridCell<String>(
                  columnName: 'order_name',
                  value: dataGridRow.userOrder?.order?.fullName),
              DataGridCell<String>(
                  columnName: 'car_name',
                  value: dataGridRow.kendaraanModel?.carName),
              DataGridCell<String>(
                  columnName: 'date_start',
                  value: FormatDateTime.dateToString(
                    newPattern: 'dd MMMM yyyy',
                    value: dataGridRow.tanggalMulai.toString(),
                  )),
              DataGridCell<String>(
                columnName: 'time_start',
                value: FormatDateTime.dateToString(
                  newPattern: DateFormat.HOUR24_MINUTE,
                  value: dataGridRow.tanggalMulai.toString(),
                ),
              ),
              DataGridCell<String>(
                columnName: 'date_end',
                value: FormatDateTime.dateToString(
                  newPattern: 'dd MMMM yyyy',
                  value: dataGridRow.tanggalSelesai.toString(),
                ),
              ),
              DataGridCell<String>(
                columnName: 'time_end',
                value: FormatDateTime.dateToString(
                  newPattern: DateFormat.HOUR24_MINUTE,
                  value: dataGridRow.tanggalSelesai.toString(),
                ),
              ),
              DataGridCell<num>(columnName: 'price', value: dataGridRow.harga),
              DataGridCell<GeoPoint?>(
                columnName: 'location',
                value: dataGridRow.userOrder?.order?.location,
              ),
              // DataGridCell<PesananModel>(
              //     columnName: 'actions', value: dataGridRow),
            ],
          ),
        )
        .toList();
  }

  bool isHasLocation(GeoPoint? geoPoint) => geoPoint != null;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map((dataGridCell) {
      // final index = dataGridRows.indexOf(row);

      return Container(
        alignment: (dataGridCell.columnName == 'id' ||
                dataGridCell.columnName == 'date_start' ||
                dataGridCell.columnName == 'time_start' ||
                dataGridCell.columnName == 'date_end' ||
                dataGridCell.columnName == 'time_end')
            ? Alignment.center
            : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: (dataGridCell.columnName == 'location')
            ? CustomFilledButton(
                onPressed: (isHasLocation(dataGridCell.value as GeoPoint?))
                    ? () async {
                        final geoPoint = dataGridCell.value as GeoPoint?;
                        String query = Uri.encodeComponent(
                            "${geoPoint!.latitude},${geoPoint.longitude}");
                        String googleUrl =
                            "https://www.google.com/maps/search/?api=1&query=$query";

                        if (await canLaunchUrl(Uri.parse(googleUrl))) {
                          await launchUrlString(googleUrl);
                        } else {
                          showSnackBar(
                            content:
                                const Text('Tidak dapat membuka google maps'),
                          );
                        }
                      }
                    : null,
                isFilledTonal: false,
                child: Text(
                  'Lihat Lokasi',
                  style: Get.theme.textTheme.labelSmall
                      ?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              )
            // (dataGridCell.columnName == 'actions')
            //     ? BuilderActionsTablePesanaan(
            //         value: dataGridCell.value as PesananModel,
            //         rowIndex: index,
            //       )
            : Text(
                (dataGridCell.columnName == 'price')
                    ? CurrencyFormat.convertToIdr(
                        number: dataGridCell.value ?? 0)
                    : dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
      );
    }).toList());
  }

  // void updateDataGridSource() {
  //   notifyListeners();
  // }

  // void changeDataGridRow({
  //   required int rowIndex,
  //   required PesananModel newData,
  // }) {
  //   dataGridRows[rowIndex] = DataGridRow(
  //     cells: [
  //       DataGridCell<int>(columnName: 'no', value: rowIndex + 1),
  //       DataGridCell<String>(
  //         columnName: 'order_name',
  //         value: newData.userOrder?.order?.fullName,
  //       ),
  //       DataGridCell<String>(
  //         columnName: 'car_name',
  //         value: newData.kendaraanModel?.carName,
  //       ),
  //       DataGridCell<String>(
  //           columnName: 'tanggal_mulai',
  //           value: newData.tanggalMulai.toString()),
  //       DataGridCell<String>(
  //           columnName: 'tanggal_selesai',
  //           value: newData.tanggalSelesai.toString()),
  //       DataGridCell<num>(columnName: 'harga', value: newData.harga),
  //       // DataGridCell<PesananModel>(columnName: 'actions', value: newData),
  //     ],
  //   );
  // }
}
