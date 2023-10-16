import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../modules/home/web/widgets/actions/builder_actions_table_rental.dart';

class RentalDataSource extends DataGridSource {
  final List<UsersModel> users;
  List<DataGridRow> dataGridRows = [];

  RentalDataSource({required this.users}) {
    buildDataGridRows();
  }

  DataGridRow builderDataGridRow({
    required int index,
    required UsersModel users,
  }) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'no', value: index++),
        DataGridCell<String>(
            columnName: 'rental_name', value: users.rentalName),
        DataGridCell<String>(columnName: 'full_name', value: users.fullName),
        DataGridCell<String>(
            columnName: 'numberPhone', value: users.numberPhone),
        DataGridCell<String>(columnName: 'address', value: users.address),
        DataGridCell<UsersModel>(columnName: 'actions', value: users),
      ],
    );
  }

  void buildDataGridRows() {
    var index = 1;

    dataGridRows = users
        .map<DataGridRow>(
          (dataGridRow) => builderDataGridRow(
            index: index++,
            users: dataGridRow,
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
                dataGridCell.columnName == 'actions')
            ? Alignment.center
            : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: (dataGridCell.columnName == 'actions')
            ? BuilderActionsTableRental(
                value: dataGridCell.value as UsersModel,
                rowIndex: index,
              )
            : Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ),
      );
    }).toList());
  }

  void updateDataGridSource() {
    notifyListeners();
  }

  void changeDataGridRow({
    required int rowIndex,
    required UsersModel newData,
  }) {
    dataGridRows[rowIndex] = DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'no', value: rowIndex + 1),
        DataGridCell<String>(
            columnName: 'rental_name', value: newData.rentalName),
        DataGridCell<String>(columnName: 'full_name', value: newData.fullName),
        DataGridCell<String>(
            columnName: 'numberPhone', value: newData.numberPhone),
        DataGridCell<String>(columnName: 'address', value: newData.address),
        DataGridCell<UsersModel>(columnName: 'actions', value: newData),
      ],
    );
  }
}
