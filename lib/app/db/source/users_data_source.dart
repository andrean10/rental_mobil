import 'package:app_rental_mobil/app/db/models/users_model.dart';
import 'package:app_rental_mobil/app/shared/shared_values.dart';
import 'package:app_rental_mobil/app/widgets/buttons/custom_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
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
        DataGridCell<int>(
          columnName: 'no',
          value: index,
        ),
        DataGridCell<String>(
          columnName: 'name',
          value: users.fullName,
        ),
        DataGridCell<String>(
            columnName: 'role',
            value: (users.role == SharedValues.ADMIN_RENTAL)
                ? 'Admin Rental'
                : 'User'),
        DataGridCell<String>(columnName: 'email', value: users.email),
        DataGridCell<String>(
          columnName: 'numberPhone',
          value: users.numberPhone,
        ),
        DataGridCell<String>(
          columnName: 'address',
          value: users.address,
        ),
        DataGridCell<List<String>>(
          columnName: 'buktiKendaraan',
          value: users.urlKendaraanImages,
        ),
        DataGridCell<UsersModel>(
          columnName: 'isActive',
          value: users,
        ),
        DataGridCell<UsersModel>(
          columnName: 'actions',
          value: users,
        ),
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

      Widget builderChild() {
        return switch (dataGridCell.columnName) {
          'buktiKendaraan' => CustomFilledButton(
              onPressed: () {
                final value = dataGridCell.value as List<String>?;

                Get.dialog(
                  Dialog.fullscreen(
                    child: Stack(
                      children: [
                        (value != null)
                            ? ImageSlideshow(
                                height: double.infinity,
                                autoPlayInterval: 3000,
                                isLoop: true,
                                children: value
                                    .map(
                                      (e) =>
                                          Image.network(e, fit: BoxFit.cover),
                                    )
                                    .toList(),
                              )
                            : const Center(
                                child: Text('Bukti gambar tidak ada!'),
                              ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: IconButton.filled(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              isFilledTonal: false,
              child: const Text('Lihat'),
            ),
          'actions' => BuilderActionsTableUser(
              value: dataGridCell.value as UsersModel,
              rowIndex: index,
            ),
          'isActive' => BuilderIsActiveTableUser(
              users: dataGridCell.value as UsersModel,
              rowIndex: index,
            ),
          _ => Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.clip,
              softWrap: true,
            )
        };
      }

      return Container(
        alignment: (dataGridCell.columnName == 'id' ||
                dataGridCell.columnName == 'isActive' ||
                dataGridCell.columnName == 'actions')
            ? Alignment.center
            : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: builderChild(),
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
