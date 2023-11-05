import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:app_rental_mobil/app/shared/shared_values.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../modules/home/web/widgets/actions/builder_actions_table_user.dart';
import '../../modules/home/web/widgets/is_active/builder_is_active_table_user.dart';

class UsersDataSource extends DataGridSource {
  final List<UsersModel> users;
  List<DataGridRow> dataGridRows = [];

  UsersDataSource({required this.users}) {
    buildDataGridRows();
  }

  DataGridRow builderGridRow({
    required int index,
    required UsersModel users,
  }) {
    return DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'no', value: index),
        DataGridCell<String>(columnName: 'name', value: users.fullName),
        DataGridCell<String>(
            columnName: 'role',
            value: (users.role == SharedValues.ADMIN_RENTAL)
                ? 'Admin Rental'
                : 'User'),
        DataGridCell<String>(columnName: 'email', value: users.email),
        DataGridCell<String>(
            columnName: 'numberPhone', value: users.numberPhone),
        DataGridCell<String>(columnName: 'address', value: users.address),
        DataGridCell<UsersModel>(
          columnName: 'isActive',
          value: users,
        ),
        DataGridCell<UsersModel>(columnName: 'actions', value: users),
      ],
    );
  }

  void buildDataGridRows() {
    var index = 1;

    dataGridRows = users
        .map<DataGridRow>(
          (dataGridRow) => builderGridRow(
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
                dataGridCell.columnName == 'isActive' ||
                dataGridCell.columnName == 'actions')
            ? Alignment.center
            : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: (dataGridCell.columnName == 'actions')
            ? BuilderActionsTableUser(
                value: dataGridCell.value as UsersModel,
                rowIndex: index,
              )
            : (dataGridCell.columnName == 'isActive')
                ? BuilderIsActiveTableUser(
                    users: dataGridCell.value as UsersModel,
                    rowIndex: index,
                  )
                : Text(
                    dataGridCell.value.toString(),
                    overflow: TextOverflow.clip,
                    softWrap: true,
                  ),
      );
    }).toList());
  }

  // void updateDataGridSource() {
  //   notifyListeners();
  // }

  // void addDataGridRow(UsersModel newData) {
  //   dataGridRows.add(
  //     builderGridRow(index: dataGridRows.length + 1, users: newData),
  //   );
  // }

  // void changeDataGridRow({
  //   required int rowIndex,
  //   required UsersModel newData,
  // }) {
  //   dataGridRows[rowIndex] = builderGridRow(
  //     index: rowIndex + 1,
  //     users: newData,
  //   );
  // }
}
